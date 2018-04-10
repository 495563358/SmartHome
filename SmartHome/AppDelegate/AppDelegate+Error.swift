//
//  AppDelegate+Error.swift
//  SmartHome
//
//  Created by sunzl on 15/12/28.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

extension AppDelegate{
   
    func setUpErrorTest()
    {
        
        //错误处理
        
        let err:String? = UserDefaults.standard.object(forKey: "error.log") as? String
            
        print("---->\(String(describing: err))")
        if (err != nil && err != "")
             {
                
                //1.管理器
                
               
                
                //   获得设备列表
                
                let dict = ["USER":"","appName":"APP_NAME","CRASH_INFO":err!]
                
                
                let url1 = "http://121.41.42.167:8080/crash/crash_report.do"
                print(dataDeal.toJSONString(jsonSource: dict as AnyObject))
                
//                let parame:NSDictionary = ["parameter":dataDeal.toJSONString(jsonSource: dict as AnyObject)]
//                let currRequest = Alamofire.request(url1, method: .post, parameters: parame, encoding:URLEncoding.default, headers: nil)
                
                Alamofire.request(url1).responseJSON(completionHandler: { (response) in
                    UserDefaults.standard.set("", forKey:"error.log")
                })
        }
  
        NSSetUncaughtExceptionHandler { (exception:NSException) in
            //异常的堆栈信息
            let stackArray:NSArray = exception.callStackSymbols as NSArray
            
            //出现异常的原因
            let reason:NSString=exception.reason! as NSString
            
            //异常名称
            let name:NSString=exception.name.rawValue as NSString
            
            let exceptionInfo:NSString=NSString(format:"Exceptionreason：%@nExceptionname：%@nExceptionstack：%",name,reason,stackArray)
            print(exceptionInfo)
            UserDefaults.standard.set(exceptionInfo, forKey:"error.log")
        }
      
        
        
    }

}
