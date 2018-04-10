//
//  EquipTableFloorCell.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class EquipTableFloorCell: UITableViewCell {

    @IBOutlet var roomName: UILabel!
    @IBOutlet var unfoldImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
