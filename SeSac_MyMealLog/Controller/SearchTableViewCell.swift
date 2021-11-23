//
//  SearchTableViewCell.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var searchDateLabel: UILabel!
    @IBOutlet weak var searchStarImageView: UIImageView!
    @IBOutlet weak var searchStarLabel: UILabel!
    @IBOutlet weak var searchContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
