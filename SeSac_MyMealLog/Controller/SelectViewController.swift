//
//  SelectViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/29.
//

import UIKit
import RealmSwift

// UIScrollViewDelegate
class SelectViewController: UIViewController {

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var images = [String]()
    var imageViews = [UIImageView]()
    
    let localRealm = try! Realm()
    var tasks: Results<UserData>! {
        didSet {
            setUpUI()
        }
    }
    
    var tasksRow: Int = 0
    
    var searchSet: Bool = false
    
    var searchTasks: UserData?
    
//    var selectTitle: String = ""
//    var selectRating: String = ""
//    var selectLocation: String = ""
//    var selectDate: String = ""
//    var selectContent: String = ""
//
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = localRealm.objects(UserData.self)
        setUpUI()
        print("SelectView : ViewDidLoad")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpUI()
        print("SelectView : ViewWillAppear")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SelectView : viewDidAppear")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SelectView : viewWillDisappear")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("SelectView : viewDidDisappear")

    }
    
    func setUpUI() {
        if searchSet == false {
            changeButton.clipsToBounds = true
            changeButton.layer.cornerRadius = 10
            closeButton.clipsToBounds = true
            closeButton.layer.cornerRadius = closeButton.layer.frame.size.width / 2
    //        titleLabel.text = selectTitle
            titleLabel.text = tasks[tasksRow].restaurantTitle
            ratingLabel.text = tasks[tasksRow].ratingStar
            locationLabel.text = tasks[tasksRow].location
            dateLabel.text = tasks[tasksRow].date
    //        contentLabel.text = selectContent
            contentLabel.text = tasks[tasksRow].contentText
            contentLabel.layer.borderWidth = 1
            contentLabel.layer.borderColor = UIColor.mainRedColor?.cgColor
            
            listCollectionView.delegate = self
            listCollectionView.dataSource = self
            
            pageControl.numberOfPages = images.count
            pageControl.currentPage = 0
            
            pageControl.currentPageIndicatorTintColor = UIColor.mainRedColor
        
        } else {
            changeButton.clipsToBounds = true
            changeButton.layer.cornerRadius = 10
            closeButton.clipsToBounds = true
            closeButton.layer.cornerRadius = closeButton.layer.frame.size.width / 2
    //        titleLabel.text = selectTitle
            titleLabel.text = searchTasks?.restaurantTitle
            ratingLabel.text = searchTasks?.ratingStar
            locationLabel.text = searchTasks?.location
            dateLabel.text = searchTasks?.date
    //        contentLabel.text = selectContent
            contentLabel.text = searchTasks?.contentText
            contentLabel.layer.borderWidth = 1
            contentLabel.layer.borderColor = UIColor.mainRedColor?.cgColor
            
            listCollectionView.delegate = self
            listCollectionView.dataSource = self
            
            pageControl.numberOfPages = images.count
            pageControl.currentPage = 0
            
            pageControl.currentPageIndicatorTintColor = UIColor.mainRedColor
        }
    }
    

    
    // 도큐먼트에서 이미지 불러오기
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        // 제약조건
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        // 최종 경로
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
    }
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        images.removeAll()
    }
    
    
    @IBAction func changButtonClicked(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        
        // Present 방식
        let sb = UIStoryboard.init(name: "Add", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController

        vc.addViewSatus = false
        if searchSet == false{
            vc.tasksRow = tasksRow
        } else {
            vc.searchSet = true
            vc.searchTasks = searchTasks
        }
        
        vc.images = images
        vc.modalPresentationStyle = .fullScreen

        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension SelectViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width / 2.0)
        
        let newPage = Int(x / width)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}

extension SelectViewController: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ListCell else {
            return UICollectionViewCell()
            }
//            let img = UIImage(named: images[indexPath.item])
        //cell.imgView.image = UIImage(named: "test")
        
        cell.imgView.image = loadImageFromDocumentDirectory(imageName: images[indexPath.item]) ?? UIImage(named: "titleIcon")
        print("indexPath.item : \(indexPath.item)")
        print(images)
        
        return cell
    }
}

extension SelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return collectionView.bounds.size
    }
}


class ListCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}
