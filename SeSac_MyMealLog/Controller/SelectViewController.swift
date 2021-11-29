//
//  SelectViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/29.
//

import UIKit

class SelectViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var images = [String]()
    var imageViews = [UIImageView]()
    
    var selectTitle: String = ""
    var selectRating: String = ""
    var selectLocation: String = ""
    var selectDate: String = ""
    var selectContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        addContentScrollView()
        setPageControl()
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
        
    }
    
    func addContentScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            let xPos = self.selectView.bounds.width * CGFloat(i)
            print(xPos)
            imageView.frame = CGRect(x: xPos, y: 0, width: self.selectView.bounds.width, height: scrollView.bounds.height)
            imageView.contentMode = .scaleToFill
            imageView.image = loadImageFromDocumentDirectory(imageName: images[i]) ?? UIImage(named: "titleIcon")
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    
    // PageControll
    // 이미지가 맞게 안들어간다
    
    func setPageControl() {
        pageControl.numberOfPages = images.count
    }
    
    func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
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
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

