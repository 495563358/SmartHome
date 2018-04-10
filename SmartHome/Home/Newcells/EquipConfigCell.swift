//
//  EquipConfigCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class EquipConfigCell: UITableViewCell {

    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellDetail: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellDetail.text = NSLocalizedString("请选择设备类型", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
