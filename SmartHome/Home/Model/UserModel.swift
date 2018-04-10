//
//  UserModel.swift
//  SmartHome
//
//  Created by sunzl on 15/12/14.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation



class UserModel: NSObject {
    var userName:String? = ""//姓名
    var userSex: String? = "" //男女
    var headPic:String? = ""//图片
    var signature:String? = ""//签名
    var city:String? = ""//城市
 
    convenience init(dict:[String : AnyObject]) {
        self.init()
        print("userInfo = \(dict)")
        self.userName = dict["userName"] as? String
        self.userSex = dict["userSex"] as? String
        self.headPic = dict["headPic"] as? String
        self.signature = dict["signature"] as? String
        self.city = dict["city"] as? String
        
//        self.setValuesForKeys(userInfo)
    }
    func releaseUser()->Void{
        app.user!.userName = ""
        app.user!.userSex = ""
        app.user!.headPic = ""
        app.user!.signature = ""
        app.user!.city = ""
    }
}
