//
//  SenTimerTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SenChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimer: UIButton!
    @IBOutlet weak var stopTimer: UIButton!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
