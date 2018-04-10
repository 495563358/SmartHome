//
//  SenTimerTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LockTimernum: UITableViewCell {

    @IBOutlet weak var kai: UILabel!
    @IBOutlet weak var guan: UILabel!
    @IBOutlet weak var startTimer: UIButton!
    @IBOutlet weak var stopTimer: UIButton!
    override func awakeFromNib() {
        self.kai.text=NSLocalizedString("使用一次", comment: "")
        self.guan.text=NSLocalizedString("无限制使用", comment: "")
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
