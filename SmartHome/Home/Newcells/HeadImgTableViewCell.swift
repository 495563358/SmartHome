//
//  HeadImgTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/3/29.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class HeadImgTableViewCell: UITableViewCell {
    @IBOutlet var HeadImg: UIImageView!
    @IBOutlet var leab: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        HeadImg.layer.cornerRadius = 12.0
        HeadImg.layer.masksToBounds = true
        HeadImg.layer.borderWidth = 3
        HeadImg.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
