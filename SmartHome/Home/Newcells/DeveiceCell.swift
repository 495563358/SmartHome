//
//  DeveiceCell.swift
//  SmartHome
//
//  Created by Smart house on 2017/11/27.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class DeveiceCell: UITableViewCell {
    
    var imageV = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 25, height: 25))
    
    var titleLab = UILabel.init(frame: CGRect(x: 60, y: 17.5, width: 150, height: 20))
    
    var centerImg = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLab.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(imageV)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted{
            self.backgroundColor = UIColor.groupTableViewBackground
        }else{
            self.backgroundColor = UIColor.white
        }
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
