//
//  SideOtherCell.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/14.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class SideOtherCell: UITableViewCell {
    
    var imageV = UIImageView.init(frame: CGRect(x: 15, y: 17, width: 20, height: 20))
    
    var titleLab = UILabel.init(frame: CGRect(x: 50, y: 10, width: ScreenWidth * 0.75 - 60 , height: 35))
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageV.contentMode = .scaleAspectFit
        
        titleLab.font = UIFont.systemFont(ofSize: 15)
        titleLab.textColor = UIColor.black
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(imageV)
        
        let lab = UIView.init(frame: CGRect(x: 50, y: 54, width: self.frame.size.width - 50, height: 1))
        lab.backgroundColor = UIColor.gray
//        self.contentView.addSubview(lab)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted{
            self.backgroundColor = UIColor.groupTableViewBackground
        }else{
            self.backgroundColor = UIColor.white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
