//
//  SideHeaderCell.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/14.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class SideHeaderCell: UITableViewCell {
    
    var imageV = UIImageView.init(frame: CGRect(x: ScreenWidth * 0.75 / 2 - 40, y: 60, width: 80, height: 80))
    
    var titleLab = UILabel.init(frame: CGRect(x: 0, y: 72+80, width: ScreenWidth * 0.75, height: 20))
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageV.layer.cornerRadius = 40
        imageV.layer.masksToBounds = true
        
        titleLab.font = UIFont.systemFont(ofSize: 17)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.white
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(imageV)
        
        self.backgroundColor = UIColor.init(patternImage: UIImage(named: "侧滑背景")!)
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
