//
//  Floor.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
class Floor {
    let floorCode: String  //floorCode
    var userCode: String = ""
    var name: String = ""
    init(floorCode: String) {
        self.floorCode = floorCode
    }
    
    func saveFloor() {
        if dataDeal.searchModel(type: .Floor, byCode: self.floorCode) != nil {
            dataDeal.updateModel(type: .Floor, model: self)
        } else {
            dataDeal.insertModel(type: .Floor, model: self)
        }
    }
    func delete(){
        if dataDeal.searchModel(type: .Floor, byCode: self.floorCode) != nil {
            dataDeal.deleteModel(type: .Floor, model: self)
        } 

    
    }
    
    
    
}
