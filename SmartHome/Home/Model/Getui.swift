//
//  Getui.swift
//  SmartHome
//
//  Created by Komlin on 16/8/16.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

class Getui: NSObject {
    
    var timer = ""
    var name = ""
    var type = ""
    var Identification = "" //标识位 下拉加载
    var Identificationnum = "" //加载行数
    
    func setvale(timer:String,name:String,type:String/*,Identification:String,Identificationnum:String*/)->Void{
        self.timer = timer
        self.name = name
        self.type = type
      //  self.Identification = Identification
//        self.Identificationnum = Identificationnum
    }
}