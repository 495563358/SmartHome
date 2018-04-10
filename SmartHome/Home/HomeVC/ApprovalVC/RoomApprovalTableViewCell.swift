//
//  RoomApprovalTableViewCell.swift
//  SmartHome
//
//  Created by Smart house on 2018/3/7.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class RoomApprovalTableViewCell: UITableViewCell {
    
    var mytextLabel: UILabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: 180, height: 50))
    var myswitchBtn:UISwitch = UISwitch(frame: CGRect(x: ScreenWidth - 70, y: 10, width: 60, height: 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mytextLabel.text = "客厅"
        myswitchBtn.onTintColor = systemColor
        self.contentView.addSubview(mytextLabel)
        self.contentView.addSubview(myswitchBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
