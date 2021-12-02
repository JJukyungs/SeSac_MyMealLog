//
//  SearchViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/19.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {

    let localRealm = try! Realm()
    
    var mainTasks: Results<UserData>! {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    var searchTasks: Results<UserData>! {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchStatus: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    var searchStringText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        delegateSet()
        registerXib()
        
        
        mainTasks = localRealm.objects(UserData.self)
//        searchTasks = localRealm.objects(UserData.self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTableView.reloadData()
    }
    
    func setUpUI() {
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.searchController = searchController
        // search
        searchController.searchBar.placeholder = "가게 이름, 위치를 입력하세요"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
//        searchController.searchBar.becomeFirstResponder()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.backgroundColor = .white
//        searchController.searchBar.sizeToFit()
        
        // navigation
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.mainRedColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont().smallNvTitleFont]
        navigationItem.standardAppearance = appearance
        
        
        navigationController?.navigationBar.topItem?.title = "뱃속 기록 찾아보기"
        
        navigationController?.navigationBar.backgroundColor = UIColor.mainRedColor

        
    }
    
    
    func delegateSet() {
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchController.searchResultsUpdater = self
    }
    
    
    func registerXib() {
        self.searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
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
   

}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {

        

        
        guard let text = searchController.searchBar.text else { return }
        
//        let predicate = NSPredicate(format: "restaurantTitle CONTAINS[c] %@ OR location CONTAINS[c]  %@",text as CVarArg,text as CVarArg)
        searchTasks = localRealm.objects(UserData.self).filter("restaurantTitle CONTAINS[c] %@ OR location CONTAINS[c] %@",text as CVarArg,text as CVarArg)
        //self.searchTasks = mainTasks?.filter(predicate)
        
        searchTableView.reloadData()
        
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 수정해보자
        if inSearchStatus {
            return searchTasks.count
        } else {
            return mainTasks.count
        }
        
//        return inSearchStatus ? searchTasks.count : mainTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        let row = inSearchStatus ? searchTasks[indexPath.row] : mainTasks[indexPath.row]
        //let row = searchTasks[indexPath.row]
        
        cell.searchTitleLabel.text = row.restaurantTitle
        cell.searchContentLabel.text = row.contentText
        cell.searchDateLabel.text = row.date
        cell.searchStarLabel.text = row.ratingStar
        cell.searchImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id)_first.png") ?? UIImage(named: "titleIcon")
        
        if inSearchStatus {
            cell.searchTitleLabel.highlight(searchText: searchStringText ?? "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inSearchStatus {
            let row = searchTasks[indexPath.row]
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
            vc.searchSet = true
            vc.searchTasks = searchTasks[indexPath.row]
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        } else {
            
            let row = mainTasks[indexPath.row]
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
    }
    
}

