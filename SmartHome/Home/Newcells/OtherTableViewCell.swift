//
//  OtherTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/3/29.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class OtherTableViewCell: UITableViewCell {

    @IBOutlet var leab: UILabel!
    @IBOutlet var information: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    func setUser1(u:UserModify){
//        
//        self.user = u
//        self.leab.text = u.name
//        self.information.text = u.sex
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
