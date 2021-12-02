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
    var dateTasks: Results<UserData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeView : ViewDidLoad")
        navigationSetUI()
        //xib
        registerXib()
        delegateSet()
        
        headerViewTitleLabel.font = UIFont().headerTitleFont
        headerViewTitleLabel.textColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("HomeView : ViewWillAppear")
        tasks = localRealm.objects(UserData.self)
        dateTasks = localRealm.objects(UserData.self)
        dateTasks = dateTasks!.sorted(byKeyPath: "date", ascending: false)
        homeTableView.reloadData()
        homeTableHeaderCollectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeView : viewDidAppear")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeView : viewWillDisappear")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("HomeView : viewDidDisappear")

    }
    

    private func delegateSet() {

        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        self.homeTableHeaderCollectionView.delegate = self
        self.homeTableHeaderCollectionView.dataSource = self
        
    }
    
    
    private func registerXib() {
       
        
        self.homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        self.homeTableHeaderCollectionView.register(UINib(nibName: "HomeHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderCollectionViewCell")
        
        self.homeTableView.register(UINib(nibName: "CustomSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        
    }
    
    
    func navigationSetUI() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.mainRedColor
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont().nvTitleFont]

        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont().smallNvTitleFont]
        navigationItem.standardAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "내 뱃속 기록"
        navigationController?.navigationBar.backgroundColor = .mainRedColor
        
        navigationController?.navigationBar.isTranslucent = true
                                                    
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
        headerView.titleLabel.font = UIFont().headerTitleFont
        headerView.titleLabel.textColor = UIColor.darkGray
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let row = tasks[indexPath.row]
        
        // 나중에 분기 처리 해야함
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.selectionStyle = .none
        
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
        vc.tasksRow = indexPath.row

        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    // 스와이프시 delete 기능
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let delete = UIContextualAction(style: .normal, title: "") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                print("delete")
                // 삭제기능 구현
        
                let taskToDelete = self.tasks[indexPath.row]
                try! self.localRealm.write {
                    self.localRealm.delete(taskToDelete)
                }
    
                self.homeTableView.reloadData()
                self.homeTableHeaderCollectionView.reloadData()
            }
            delete.backgroundColor = .red
            delete.image = UIImage(systemName: "trash")
            delete.title = "삭제"
        
            return UISwipeActionsConfiguration(actions: [delete])
    }
}



// tag CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 최신 거 5개만 받아올수 있게
        if dateTasks.count <= 5 {
            return dateTasks.count
        } else {
            return 5
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = dateTasks[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as? HomeHeaderCollectionViewCell else { return UICollectionViewCell() }

        cell.headerImageView.image = loadImageFromDocumentDirectory(imageName: "\(item._id)_first.png") ?? UIImage(named: "titleIcon")
        cell.headerStarImageView.image = UIImage(named: "star_full")
        
        cell.headerTitleLabel.text = item.restaurantTitle
        cell.headerStarLabel.text = item.ratingStar

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = dateTasks[indexPath.item]
        print("foodImagecount : \(item.foodImageCount)")
        
        
        let sb = UIStoryboard.init(name: "Select", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
        print("SelectViewController 창")
        
        switch item.foodImageCount - 1 {
        case 0:
            vc.images.append("\(item._id)_first.png")
        case 1:
            vc.images.append("\(item._id)_first.png")
            vc.images.append("\(item._id)_second.png")
        default:
            // 2
            vc.images.append("\(item._id)_first.png")
            vc.images.append("\(item._id)_second.png")
            vc.images.append("\(item._id)_thrid.png")
        }
//        vc.tasksRow = indexPath.item
        vc.searchSet = true
        vc.searchTasks = dateTasks[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}


