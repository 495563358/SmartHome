//
//  DeviceApprovalCell.swift
//  SmartHome
//
//  Created by Smart house on 2018/3/8.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class DeviceApprovalCell: UITableViewCell {
    
    var myswitchBtn:UISwitch = UISwitch(frame: CGRect(x: ScreenWidth - 70, y: 10, width: 60, height: 30))
    
    var imageV = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 25, height: 25))
    
    var titleLab = UILabel.init(frame: CGRect(x: 60, y: 17.5, width: 150, height: 20))
    
    var centerImg = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        myswitchBtn.onTintColor = systemColor
        self.contentView.addSubview(myswitchBtn)
        titleLab.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(imageV)
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
