//
//  HomeTableViewCell.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var homeTableCellImageView: UIImageView!
    @IBOutlet weak var homeTableCellTitleLabel: UILabel!
    @IBOutlet weak var homeTableCellStarImageView: UIImageView!
    @IBOutlet weak var homeTableCellStarLabel: UILabel!
    @IBOutlet weak var homeTableCellDateLabel: UILabel!
    @IBOutlet weak var homeTableCellContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TableViewCell Font set
        homeTableCellStarLabel.font = UIFont().contentFont
        homeTableCellDateLabel.font = UIFont().smallContentFont
        homeTableCellTitleLabel.font = UIFont().sectiontitleFont
        homeTableCellContentLabel.font = UIFont().contentFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
