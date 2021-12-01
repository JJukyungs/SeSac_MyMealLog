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
    
//    var mainTasks: Results<UserData>? {
//        didSet {
//            searchTableView.reloadData()
//        }
//    }
    
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
        delegateSet()
        registerXib()
        setUpUI()
    }
    
    func setUpUI() {
        navigationController?.navigationBar.topItem?.title = "내 뱃속 기록"
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "검색어를 입력하세요"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.becomeFirstResponder()
        searchController.hidesNavigationBarDuringPresentation = true
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

        
        let text = searchController.searchBar.text?.lowercased() ?? ""
        
        searchTasks = localRealm.objects(UserData.self).filter("restaurantTitle CONTAINS[c] '\(text)' OR location CONTAINS[c] '\(text)'")
        searchStringText = text
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 수정해보자
//        if inSearchStatus {
//            return searchTasks.count
//        } else {
//            return mainTasks.count
//        }
        return searchTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
//        let row = inSearchStatus ? searchTasks[indexPath.row] : mainTasks?[indexPath.row]
        let row = searchTasks[indexPath.row]
        
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
    
    
}

