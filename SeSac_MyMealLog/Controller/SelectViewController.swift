//
//  SelectViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/29.
//

import UIKit

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
    
    var selectTitle: String = ""
    var selectRating: String = ""
    var selectLocation: String = ""
    var selectDate: String = ""
    var selectContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()

    }
    
    func setUpUI() {
        
        changeButton.clipsToBounds = true
        changeButton.layer.cornerRadius = 10
        closeButton.clipsToBounds = true
        closeButton.layer.cornerRadius = closeButton.layer.frame.size.width / 2
        titleLabel.text = selectTitle
        ratingLabel.text = selectRating
        locationLabel.text = selectLocation
        dateLabel.text = selectDate
        contentLabel.text = selectContent
        contentLabel.layer.borderWidth = 1
        contentLabel.layer.borderColor = UIColor.mainRedColor?.cgColor
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = UIColor.mainRedColor
    }
    
//    func addContentScrollView() {
//        for i in 0..<images.count {
//            let imageView = UIImageView()
//            let xPos = scrollView.bounds.width * CGFloat(i)
//            print(xPos)
////            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
//            imageView.contentMode = .scaleToFill
//            imageView.image = loadImageFromDocumentDirectory(imageName: images[i]) ?? UIImage(named: "titleIcon")
//
//            scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
//            scrollView.contentSize.height = scrollView.frame.height
//
//            scrollView.addSubview(imageView)
//        }
//    }
    
    // PageControll
    // 이미지가 맞게 안들어간다
    
//    func setPageControl() {
//        pageControl.numberOfPages = images.count
//    }
//
//    func setPageControlSelectedPage(currentPage: Int) {
//        pageControl.currentPage = currentPage
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let value = scrollView.contentOffset.x / scrollView.frame.size.width
//        setPageControlSelectedPage(currentPage: Int(round(value)))
//    }
    
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
        self.dismiss(animated: true, completion: nil)
        
        
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
        print(x)
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
