//
//  LockUser.swift
//  SmartHome
//
//  Created by Komlin on 16/11/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LockUser: NSObject {
    var userID = ""
    var lockAddress = ""
    var userimg = ""
    var userName = ""
    var usersubscript = ""
    func setValue(userID:String,lockAddress:String,userimg:String,userName:String,usersubscript:String){
        self.userID = userID
        self.lockAddress = lockAddress
        self.userimg = userimg
        self.userName = userName
        self.usersubscript = usersubscript
    }
}
