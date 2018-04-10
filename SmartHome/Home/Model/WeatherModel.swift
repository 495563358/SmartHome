//
//  WeatherModel.swift
//  SmartHome
//
//  Created by sunzl on 15/12/24.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    var address:String=""
    var aMaxTemp:String=""
    var aSmallTemp:String=""
    var aWeather:String=""
    var aWind:String=""
  
    init(address:String,aMaxTemp:String,aSmallTemp:String,aWeather:String,aWind:String) {
        self.address=address
        self.aMaxTemp=aMaxTemp
        self.aSmallTemp=aSmallTemp
        self.aWeather=aWeather
        self.aWind=aWind
     
    }
}
