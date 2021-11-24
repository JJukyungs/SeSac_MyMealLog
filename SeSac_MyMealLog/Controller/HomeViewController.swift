//
//  HomeViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/19.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var homeTableHeaderCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetUI()
        //xib
        registerXib()
        delegateSet()
        
       
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
        
        
    }
    
    
    func navigationSetUI() {
        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationItem.title = "내 뱃속의 기록"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .mainRedColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont().nvTitleFont]
        
        // font 변경
        
        
        
        
    }
    

}

// Main TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 나중에 분기 처리 해야함
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.homeTableCellImageView.image = UIImage(named: "test")
        cell.homeTableCellStarImageView.image = UIImage(named: "star_full")
        return cell
        
    }


}



// tag CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as? TagCollectionViewCell else {
//            print("error")
//            return UICollectionViewCell()
//        }
//        print("Test")
//        cell.tagButton.backgroundColor = .green
//        cell.tagButton.setTitle("testestest", for: .normal)
//        return cell

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as? HomeHeaderCollectionViewCell else { return UICollectionViewCell() }

        cell.headerImageView.image = UIImage(named: "test")
        cell.headerStarImageView.image = UIImage(named: "star_full")

        return cell
    }


}


