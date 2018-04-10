//
//  Infrared.swift
//  SmartHome
//
//  Created by Komlin on 16/4/21.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class Infrared: NSObject {
    var name:String = ""
    var addr:String?
    init(aname:String,and ad:String) {
        name = aname
        addr = ad
    }
}
