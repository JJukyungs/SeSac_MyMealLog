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
        
        cell.homeTableCellImageView.image = UIImage(named: "test")
        cell.homeTableCellStarImageView.image = UIImage(named: "star_full")
        
        cell.homeTableCellTitleLabel.text = row.restaurantTitle
        cell.homeTableCellContentLabel.text = row.contentText
        cell.homeTableCellDateLabel.text = row.date
        cell.homeTableCellStarLabel.text = row.ratingStar
        
        return cell
        
    }


}



// tag CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 최신 거 5개만 받아올수 있게
        return tasks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = tasks[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as? HomeHeaderCollectionViewCell else { return UICollectionViewCell() }

        cell.headerImageView.image = UIImage(named: "test")
        cell.headerStarImageView.image = UIImage(named: "star_full")
        
        cell.headerTitleLabel.text = item.restaurantTitle
        cell.headerStarLabel.text = item.ratingStar

        return cell
    }


}


