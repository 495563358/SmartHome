//
//  EquipTableRoomCell.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class EquipTableRoomCell: UITableViewCell {

    @IBOutlet var roomName: UILabel!
    @IBOutlet var unfoldImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.unfoldImage.center = CGPoint(x: ScreenWidth - 30, y: 21)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
