//
//  box.swift
//  SmartHome
//
//  Created by Komlin on 16/8/17.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

class boxx: NSObject {
    var name = ""
    var state = ""
    var id = ""
    var deviceCode = ""
    
    func setvale(name:String,stat:String,id:String,deviceCode:String){
        self.name = name
        self.state = stat
        self.id = id
        self.deviceCode = deviceCode
    }
}