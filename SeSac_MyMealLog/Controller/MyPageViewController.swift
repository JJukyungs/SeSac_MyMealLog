//
//  MyPageViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/19.
//

import UIKit

class MyPageViewController: UIViewController {

    
    @IBOutlet weak var myPageImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    

    func setUI () {
        nickNameLabel.backgroundColor = .mainRedColor
        nickNameLabel.layer.cornerRadius = 8
        nickNameLabel.clipsToBounds = true
        nickNameLabel.textAlignment = .center
        nickNameLabel.textColor = .white
        
        reviewLabel.backgroundColor = .mainRedColor
        reviewLabel.layer.cornerRadius = 8
        reviewLabel.clipsToBounds = true
        reviewLabel.textAlignment = .center

        reviewLabel.textColor = .white
        
        myPageImageView.image = UIImage(named: "test")
        myPageImageView.layer.cornerRadius = myPageImageView.frame.height/2
        myPageImageView.clipsToBounds = true
        myPageImageView.contentMode = .scaleAspectFill
    }
   

}
