//
//  SensorModel.swift
//  SmartHome
//
//  Created by Komlin on 16/6/24.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SensorModel: NSObject {
    var sensorhost:String = "" //主机
    var SensorID:String = ""//几路
    var SensorName:String = "" //名称
    var SensorSwiht:Bool = true //全开全关
    var SensorTimerNum:String = "" //那个时间段
    var sensorTimer:[String] = [] //时间段
    var sensordeviceType:String = "" //998
    var sensorType:String = "" //撤防布防
    var sensorstate:String = "" //判断是控制盒 还是自己定义的
    //var sensorTimerEnd:[String] = []//结束时间段
    init(deviceCode:String,deviceAddress:String,nickName:String,start1:String,start2:String,start3:String,deviceType:String,securityType:String,sensorstate:String) {
        self.sensorhost = deviceCode
        self.SensorID = deviceAddress
        self.SensorName = nickName
        self.sensordeviceType = deviceType
        self.sensorType = securityType
        self.sensorstate = sensorstate
        
        self.sensorTimer.append(start1)
        self.sensorTimer.append(start2)
        self.sensorTimer.append(start3)
    }
}
