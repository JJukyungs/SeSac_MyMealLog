//
//  CustomSectionHeaderView.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/25.
//

import UIKit

class CustomSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var simbolImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont().nvTitleFont
//        backgroundView = customView
    }
}
