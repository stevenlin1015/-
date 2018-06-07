//
//  BackgroundImageTableViewCell.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/6/7.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class BackgroundImageTableViewCell: UITableViewCell {
    @IBOutlet var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
