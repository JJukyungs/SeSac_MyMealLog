//
//  HomeViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/19.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeTableHeaderCollectionView: UICollectionView!
    @IBOutlet weak var headerViewTitleLabel: UILabel!
    
    
    let localRealm = try! Realm()
    var tasks: Results<UserData>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetUI()
        //xib
        registerXib()
        delegateSet()
        
        headerViewTitleLabel.font = UIFont().sectiontitleFont
        headerViewTitleLabel.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tasks = localRealm.objects(UserData.self)
        homeTableView.reloadData()
        homeTableHeaderCollectionView.reloadData()
    }
    

    private func delegateSet() {
//        self.tagCollectionView.delegate = self
//        self.tagCollectionView.dataSource = self
//
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        self.homeTableHeaderCollectionView.delegate = self
        self.homeTableHeaderCollectionView.dataSource = self
        
    }
    
    
    private func registerXib() {
        // tag collectionView -> 후에 세그먼트 컨트롤로 바꿀예정
        //self.tagCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
        
        self.homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        self.homeTableHeaderCollectionView.register(UINib(nibName: "HomeHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderCollectionViewCell")
        
        self.homeTableView.register(UINib(nibName: "CustomSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        
    }
    
    
    func navigationSetUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.mainRedColor
        self.navigationItem.title = "내 뱃속 기록"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .mainRedColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont().nvTitleFont]
    }
    
    // 도큐먼트 폴더 경로에서 이미지 찾아 넣기
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
    
    // 도큐먼트에서 이미지 파일 지우는 함수
    func deleteImageFromDocumentDirectory(imageName: String) {
        // 1. 이미지 저장하기 위한 경로 설정 : 명확하게 설정되어있음. 도큐먼트 폴더!!, FileManager(싱글턴 패턴)
        
        // for:   / in: 정보의 제한
        // Desktop/jack/ios/folder/
        guard let documentDirctory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 2. 이미지 파일 이름 & 최종 경로 설정  [매개변수로 파일 이름을 설정을 함]
        // Desktop/jack/ios/folder/222.png
        let imageURL = documentDirctory.appendingPathComponent(imageName)
        
      
        
        // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        // 4 - 1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            
            // 4 - 2. 기존 경로에 있는 임지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제")
            } catch {
                print("이미지를 삭제하지 못했습니다.")
            }
        }
    }

}

// Main TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomSectionHeaderView //먼저 재사용 queue에서 header가져오기
        headerView.titleLabel.text = "뱃속 기록들"
        headerView.titleLabel.font = UIFont().sectiontitleFont
        headerView.titleLabel.textColor = UIColor.lightGray
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = tasks[indexPath.row]
        
        // 나중에 분기 처리 해야함
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
//        cell.homeTableCellImageView.image = UIImage(named: "test")
        cell.homeTableCellImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id)_first.png") ?? UIImage(named: "titleIcon")
        cell.homeTableCellStarImageView.image = UIImage(named: "star_full")
        
        cell.homeTableCellTitleLabel.text = row.restaurantTitle
        cell.homeTableCellContentLabel.text = row.contentText
        cell.homeTableCellDateLabel.text = row.date
        cell.homeTableCellStarLabel.text = row.ratingStar
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = tasks[indexPath.row]
        print("foodImagecount : \(row.foodImageCount)")
        
        
        let sb = UIStoryboard.init(name: "Select", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
        print("SelectViewController 창")
        
        switch row.foodImageCount - 1 {
        case 0:
            vc.images.append("\(row._id)_first.png")
        case 1:
            vc.images.append("\(row._id)_first.png")
            vc.images.append("\(row._id)_second.png")
        default:
            // 2
            vc.images.append("\(row._id)_first.png")
            vc.images.append("\(row._id)_second.png")
            vc.images.append("\(row._id)_thrid.png")
        }
       
        vc.selectTitle = row.restaurantTitle
        vc.selectRating = row.ratingStar
        vc.selectDate = row.date
        vc.selectContent = row.contentText ?? ""
        vc.selectLocation = row.location ?? ""
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

}



// tag CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 최신 거 5개만 받아올수 있게
        if tasks.count <= 5 {
            return tasks.count
        } else {
            return 5
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = tasks[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as? HomeHeaderCollectionViewCell else { return UICollectionViewCell() }

        cell.headerImageView.image = loadImageFromDocumentDirectory(imageName: "\(item._id)_first.png") ?? UIImage(named: "titleIcon")
        cell.headerStarImageView.image = UIImage(named: "star_full")
        
        cell.headerTitleLabel.text = item.restaurantTitle
        cell.headerStarLabel.text = item.ratingStar

        return cell
    }


}


