//
//  LocationManager.swift
//  SmartHome
//
//  Created by sunzl on 15/12/28.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import CoreLocation
typealias CallbackCityName=(String!)->()
class MyLocationManager:NSObject,
CLLocationManagerDelegate{
   var currentlocation:CLLocationManager?
    var callback:CallbackCityName?
 
    class func sharedManager()->MyLocationManager{
        struct YRSingleton{
            static var sharedAccountManagerInstance:MyLocationManager? = nil;
            static var predicate = 0
        }
        YRSingleton.sharedAccountManagerInstance = MyLocationManager()
//       dispatch_once(&YRSingleton.predicate,{
//        YRSingleton.sharedAccountManagerInstance = MyLocationManager()
//        })
      
        return YRSingleton.sharedAccountManagerInstance!
    }
    func configLocation()
    {
       
        if (currentlocation == nil)
        {
            
            if (!CLLocationManager.locationServicesEnabled() || (CLLocationManager.authorizationStatus()==CLAuthorizationStatus.denied))
            {
                showMsg(msg: NSLocalizedString("您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!", comment: ""))
             
            }
            else
            {
                
                //开启定位
                currentlocation = CLLocationManager()//创建位置管理器
                currentlocation!.delegate=self
                currentlocation!.desiredAccuracy=kCLLocationAccuracyBest
                currentlocation!.distanceFilter=1000.0
                

                if  (currentlocation?.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)))! {
                        print("--------6")
                        currentlocation!.requestWhenInUseAuthorization()
                    }
                   
                
                       //启动位置更新
               currentlocation?.startUpdatingLocation()
            }
          
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation=locations.last
        let geoCoder:CLGeocoder  = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(newLocation!) { (placemarks:[CLPlacemark]?, error:NSError?) in
//            if (error == nil)
//            {
//
//                for placemark:CLPlacemark in placemarks!{
//
//                    let test:NSDictionary = placemark.addressDictionary!
//
//
//                    self.callback!(test["City"] as! String)
//                    print(test["City"])
//
//                }
//            }
//            self.currentlocation!.stopUpdatingLocation()
//
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
//        switch(error.classForCoder) {
//        case CLError.denied:
//            showMsg(msg: NSLocalizedString("您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!", comment: ""))
//            break;
//        case CLError.locationUnknown:
//
//            break;
//        default:
//            break;
//        }
    }
    
    
    
}
