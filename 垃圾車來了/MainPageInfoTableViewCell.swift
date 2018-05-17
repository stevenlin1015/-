//
//  MainPageInfoTableViewCell.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/17.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class MainPageInfoTableViewCell: UITableViewCell {
    @IBOutlet var distanceFromUserLabel: UILabel!
    @IBOutlet var licensePlateNumberLabel: UILabel!
    @IBOutlet var currentLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
