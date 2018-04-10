//
//  Equip.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
//func ==(lhs: Equip, rhs: Equip) -> Bool {
//    return lhs.hashValue == rhs.hashValue
//}
class Equip : NSObject{
    @objc var equipID: String //
    @objc var hostDeviceCode: String = "unload"
    @objc var userCode: String = ""
    @objc var roomCode: String = ""
    @objc var name: String = ""
    @objc var type: String = ""//99
    @objc var icon: String = ""
    @objc var num: String = ""//yanzhengma
    @objc var status:String = ""
    @objc var delay:String = "300"
    @objc var isApproval:Bool = true
    @objc init(equipID: String) {
        self.equipID = equipID
    }
    @objc func saveEquip() {
        if dataDeal.searchModel(type: .Equip, byCode: self.equipID) != nil {
            dataDeal.updateModel(type: .Equip, model: self)
        } else {
            dataDeal.insertModel(type: .Equip, model: self)
        }
        
    }
    @objc func delete(){
        if dataDeal.searchModel(type: .Equip, byCode: self.equipID) != nil {
            dataDeal.deleteModel(type: .Equip, model: self)
        }
        
    }
    
//    var hashValue: Int {
//       
//        return "\(equipID),\(userCode),\(roomCode),\(icon),\(type),\(num),\(name)".hashValue
//    }
}
