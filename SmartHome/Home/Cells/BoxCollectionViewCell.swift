//
//  BoxCollectionViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/8/16.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class BoxCollectionViewCell: UICollectionViewCell {

    var isMoni:Bool?
    var box:boxx?
    
    
    @IBOutlet weak var state: UISwitch!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        //self.state.addTarget(self, action: Selector("switchDidChange:"), forControlEvents:  UIControlEvents.ValueChanged )
    }

}
