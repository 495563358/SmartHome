//
//  EditView.swift
//  SmartHome
//
//  Created by kincony on 15/12/15.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class EditView: UIView {

    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        label.text = NSLocalizedString("编辑", comment: "")
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        self.backgroundColor = UIColor(RGB: 0xfda074, alpha: 1)
    }
    
    
          
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        label.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        label.text = "编辑"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        self.backgroundColor = UIColor(RGB: 0xfda074, alpha: 1)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
