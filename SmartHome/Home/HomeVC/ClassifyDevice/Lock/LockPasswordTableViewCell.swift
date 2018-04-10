//
//  LockPasswordTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/11/10.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LockPasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var passShow: UIButton!
    @IBOutlet weak var passlabe: UILabel!
    @IBOutlet weak var passText: UITextField!
    
    var showpass = "1"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.passShow.addTarget(self, action: Selector("passTextShow:"), for: UIControlEvents.touchUpInside)
        self.passShow.isHidden = true
    }
    
    func passTextShow(_ but:UIButton){
        //self.passText.enabled = true
        self.passText.isSecureTextEntry = !self.passText.isSecureTextEntry
        //self.passText.enabled = false
        let text = self.passText.text;
        self.passText.text = " ";
        self.passText.text = text;
        if showpass == "1"{
            self.passShow.setImage(UIImage(named: "密码显示"), for: UIControlState())
            self.showpass = "0"
        }else if showpass == "0"{
            self.passShow.setImage(UIImage(named: "密码不显示"), for: UIControlState())
            self.showpass = "1"
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
