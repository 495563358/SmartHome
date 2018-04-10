//
//  BaseHttpService.swift
//  SmartHome
//
//  Created by sunzl on 16/3/28.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
class BaseHttpService: NSObject {
    
    typealias RequestSuccessBlock = (AnyObject) -> ()
    
    static func sendRequest(_ url:String,parameters dic:NSDictionary,success successBlock:@escaping RequestSuccessBlock){
        let app_secret = "12345"
        let sign = (dic.ping()+app_secret).md5
        print(dic.ping()+app_secret)
        MBProgressHUD.showAdded(to: app.window, animated: true)
        let head_dict:[String:String]? = ["timestamp":timeStamp(),"nonce":randomNumAndLetter(),"sign":sign]
        print("head_dict=\(head_dict)")
        
        Alamofire.request(url,method: .post, parameters: dic as? [String : AnyObject], encoding: URLEncoding.default, headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
            print(response)
            MBProgressHUD.hideAllHUDs(for: app.window, animated: true)
            if response.result.isFailure {
                print("网路问题-error:\(response.result.error)")
                //  successBlock([])

            } else {
                if (response.result.value!as![String:AnyObject]).keys.contains("statusCode"){
                    print("服务器返回异常数据")
                    return;
                }
                //                if response.result.value!["success"] as! Bool == true{
                //                    successBlock(response.result.value! )
                //                }else{
                //                    let str = response.result.value!["message"]as!String
                //                    BaseHttpService.showMMSSGG(str)
                //                }
                successBlock(response.result.value! as AnyObject )

            }

        })
        
    }
    static func saveImageAccess(_ url:String,data:Data,success successBlock:RequestSuccessBlock){
        let app_secret = "12345"
        
        let token = accessToken()
        let stamp = timeStamp()
        let nonce = randomNumAndLetter()
        let code = userCode()
        let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
        
        print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
        let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code,"userPhone":BaseHttpService.getUserPhoneType()]
        //GetUserFileupload
        //Alamofire.Manager
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "fileupload", fileName: randomNumAndLetter(), mimeType: "image/jpeg")
        }, to: url, headers: head_dict, encodingCompletion:{ encodingResult in
            switch encodingResult{
            case .success(request: let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value as? [String : AnyObject]{
                        print(value)
                    }
                })
            case .failure(let error):
                print(error)
            }
        })
//        Alamofire.upload(.POST,url, headers: head_dict, multipartFormData: { (multipartFormData) -> Void in
//            multipartFormData.appendBodyPart(data: data, name: "fileupload", fileName:randomNumAndLetter(), mimeType: "image/jpeg")     }, encodingMemoryThreshold: 10 * 1024 * 1024) { (result) -> Void in
//                //successBlock(result)
//        }
        
        
        
    }
    
    static func locksaveImageAccess(_ url:String,data:Data,success successBlock:RequestSuccessBlock){
        let app_secret = "12345"
        
        let token = accessToken()
        let stamp = timeStamp()
        let nonce = randomNumAndLetter()
        let code = userCode()
        let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
        
        print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
        let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code,"userPhone":BaseHttpService.getUserPhoneType()]
        //GetUserFileupload
        //Alamofire.Manager
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "fileupload", fileName: randomNumAndLetter(), mimeType: "image/jpeg")
        }, to: url, headers: head_dict, encodingCompletion:{ encodingResult in
            switch encodingResult{
            case .success(request: let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value as? [String : AnyObject]{
                        print(value)
                    }
                })
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
    @objc static func sendRequestAccess(_ url:String,parameters dic:NSDictionary,success successBlock:@escaping RequestSuccessBlock){
        if deviceStatus_do != url  {
            MBProgressHUD.showAdded(to: app.window, animated: true)
        }
        if commandmodel == url || commad_do == url{
            let time: TimeInterval = 1.0
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                MBProgressHUD.hideAllHUDs(for: app.window, animated: true)
            }
        }
        
        
        let app_secret = "12345"
        
        let token = accessToken()
        let stamp = timeStamp()
        let nonce = randomNumAndLetter()
        let code = userCode()
        let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
        
        print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
        let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code]
        
        print(dic)
        
        
        Alamofire.request(url,method:.post, parameters:dic as? [String : AnyObject], encoding:URLEncoding.default , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
            
            //  print(NSString(data:response.data!, encoding:NSUTF8StringEncoding))
            MBProgressHUD.hideAllHUDs(for: app.window, animated: true)
            if response.result.isFailure {
                
                //let  popView = PopupView(frame: CGRectMake(100, ScreenHeight-200, 0, 0))
                //popView.ParentView = UIWindow.visibleViewController().view
                //  popView.setText("检查网络状态")
                //popView.ParentView .addSubview(popView)
                showMsg(msg: "网络不给力,请检查网络后重试!")
                print("网路问题-error:\(String(describing: response.result.error))")
                //  UIApplication.sharedApplication().openURL(NSURL(string: "tel:15105873889")!);
                
            } else {
                
                print("\(url)-\(String(describing: response.result.value))")
                
                
                if (response.result.value!as![String:AnyObject]).keys.contains("statusCode"){
                    
                    //                    let  popView = PopupView(frame: CGRectMake(100, ScreenHeight-200, 0, 0))
                    //                    popView.ParentView = UIWindow.visibleViewController().view
                    //                    popView.setText("服务器繁忙")
                    //                      popView.ParentView .addSubview(popView)
                    print("服务器返回异常数据")
                    return;
                }
                if (response.result.value as! NSDictionary)["message"]as!String == "Invalid_User"
                    
                {
                    print("无效的用户重新登录")
                    
                    let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                    
                    app.window!.rootViewController=nav
                    return
                    
                }
                let str = (response.result.value as! NSDictionary)["message"]as!String
                BaseHttpService.showMMSSGG(str)
                let separArr:[String] = str.components(separatedBy: ",")
                if separArr.last == "离线"{
                    showMsg(msg: "\(String(describing: separArr.first!))离线,请检查主机")
                }
                print(str)
                
                
                if (response.result.value as! NSDictionary)["success"] as! Bool == true{
                    
                    
                    if ((response.result.value as! NSDictionary)["data"]! as AnyObject).isEqual(NSNull())
                    {
                        successBlock([["信息为<null>"]] as AnyObject)
                        return
                    }
                    successBlock((response.result.value as! NSDictionary)["data"]! as AnyObject)
                    
                } else{
                    // state 2
                    if (response.result.value as! NSDictionary)["message"]as!String != "超时了" && (response.result.value as! NSDictionary)["message"]as!String != "验证不通过" {
                        //不是超时的其他问题
                        return
                        
                    }
                    
                    // state 1
                    //失效
                    print("accessToken已经失效了重新获取!")
                    sendRequest(refreshToken_do, parameters: ["refreshToken":refreshAccessToken(),"userCode":userCode()]) { (any:AnyObject) -> () in
                        
                        if any["success"]as! Bool == true
                        {
                            //得到新的accessToken 和 refreshToken 保存
                            setAccessToken((any["data"] as! NSDictionary)["accessToken"] as! NSString)
                            setRefreshAccessToken((any["data"] as! NSDictionary)["refreshToken"] as! NSString)
                            
                            //重新发送之前的请求
                            let token = accessToken()
                            let stamp = timeStamp()
                            let nonce = randomNumAndLetter()
                            
                            
                            let app_secret = "12345"
                            
                            
                            let code = userCode()
                            let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
                            
                            print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
                            let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code]
                            
                            
                            Alamofire.request(url, method: .post, parameters:dic as? [String : AnyObject], encoding:URLEncoding.default , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
                                
                                if response.result.isFailure {
                                    print("网路问题-error:\(response.result.error)")
                                    
                                } else {
                                    if (response.result.value as! NSDictionary)["success"] as! Bool == true{
                                        successBlock((response.result.value as! NSDictionary)["data"]! as AnyObject )
                                        
                                    } else{
                                        /// print("操作失败")
                                        let msg =  (response.result.value as! NSDictionary)["message"]as!String
                                        switch (msg)
                                        {
                                        case "refreshToken令牌失效","超时了","验证不通过":
                                            self.clearToken()
                                            print("refreshToken令牌失效"+"超时了"+"验证不通过")
                                            let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                                            app.window!.rootViewController=nav
                                            break
                                        default:
                                            break
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }})
                            
                        }
                        else
                        {//彻底失效
                            let msg =  (response.result.value as! NSDictionary)["message"]as!String
                            switch (msg)
                            {
                            case "refreshToken令牌失效","超时了","验证不通过":
                                
                                print("refreshToken令牌失效"+"超时了"+"验证不通过")
                                let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                                
                                app.window!.rootViewController=nav
                                break
                            default:
                                break
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
        })
        
    }
    
    //返回所有数据的封装
    @objc static func sendRequestAccessAndBackall(_ url:String,parameters dic:NSDictionary,success successBlock:@escaping RequestSuccessBlock){
        if deviceStatus_do != url  {
            MBProgressHUD.showAdded(to: app.window, animated: true)
        }
        if commandmodel == url || commad_do == url{
            let time: TimeInterval = 1.0
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                MBProgressHUD.hideAllHUDs(for: app.window, animated: true)
            }
        }
        
        
        let app_secret = "12345"
        
        let token = accessToken()
        let stamp = timeStamp()
        let nonce = randomNumAndLetter()
        let code = userCode()
        let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
        
        print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
        let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code]
        
        print("提交给服务器的参数 = \(dic)")
        
        Alamofire.request(url,method:.post, parameters:dic as? [String : AnyObject], encoding:URLEncoding.default , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
            
            MBProgressHUD.hideAllHUDs(for: app.window, animated: true)
            if response.result.isFailure {
                
                showMsg(msg: "网络不给力,请检查网络后重试!")
                print("网路问题-error:\(String(describing: response.result.error))")
                
            } else {
                
                print("\(url)-\(String(describing: response.result.value))")
                
                
                if (response.result.value!as![String:AnyObject]).keys.contains("statusCode"){
                    print("服务器返回异常数据")
                    return;
                }
                if (response.result.value as! NSDictionary)["message"]as!String == "Invalid_User"
                {
                    print("无效的用户重新登录")
                    
                    let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                    
                    app.window!.rootViewController=nav
                    return
                    
                }
                let str = (response.result.value as! NSDictionary)["message"]as!String
                BaseHttpService.showMMSSGG(str)
                let separArr:[String] = str.components(separatedBy: ",")
                if separArr.last == "离线"{
                    showMsg(msg: "\(String(describing: separArr.first!))离线,请检查主机")
                }
                print(str)
                
                if (response.result.value as! NSDictionary)["success"] as! Bool == true{
                    
                    
                    if ((response.result.value as! NSDictionary)["data"]! as AnyObject).isEqual(NSNull())
                    {
                        successBlock([["信息为<null>"]] as AnyObject)
                        return
                    }
                    successBlock(response.result.value as AnyObject)
                    
                } else{
                    // state 2
                    if (response.result.value as! NSDictionary)["message"]as!String != "超时了" && (response.result.value as! NSDictionary)["message"]as!String != "验证不通过" {
                        //不是超时的其他问题
                        return
                        
                    }
                    
                    // state 1
                    //失效
                    print("accessToken已经失效了重新获取!")
                    sendRequest(refreshToken_do, parameters: ["refreshToken":refreshAccessToken(),"userCode":userCode()]) { (any:AnyObject) -> () in
                        
                        if any["success"]as! Bool == true
                        {
                            //得到新的accessToken 和 refreshToken 保存
                            setAccessToken((any["data"] as! NSDictionary)["accessToken"] as! NSString)
                            setRefreshAccessToken((any["data"] as! NSDictionary)["refreshToken"] as! NSString)
                            
                            //重新发送之前的请求
                            let token = accessToken()
                            let stamp = timeStamp()
                            let nonce = randomNumAndLetter()
                            
                            
                            let app_secret = "12345"
                            
                            
                            let code = userCode()
                            let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
                            
                            print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
                            let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code]
                            
                            
                            Alamofire.request(url, method: .post, parameters:dic as? [String : AnyObject], encoding:URLEncoding.default , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
                                
                                if response.result.isFailure {
                                    print("网路问题-error:\(response.result.error)")
                                    
                                } else {
                                    if (response.result.value as! NSDictionary)["success"] as! Bool == true{
                                        successBlock((response.result.value as! NSDictionary)["data"]! as AnyObject )
                                        
                                    } else{
                                        /// print("操作失败")
                                        let msg =  (response.result.value as! NSDictionary)["message"]as!String
                                        switch (msg)
                                        {
                                        case "refreshToken令牌失效","超时了","验证不通过":
                                            self.clearToken()
                                            print("refreshToken令牌失效"+"超时了"+"验证不通过")
                                            let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                                            app.window!.rootViewController=nav
                                            break
                                        default:
                                            break
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }})
                            
                        }
                        else
                        {//彻底失效
                            let msg =  (response.result.value as! NSDictionary)["message"]as!String
                            switch (msg)
                            {
                            case "refreshToken令牌失效","超时了","验证不通过":
                                
                                print("refreshToken令牌失效"+"超时了"+"验证不通过")
                                let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                                
                                app.window!.rootViewController=nav
                                break
                            default:
                                break
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
        })
        
    }
    
    static func showMMSSGG(_ str:String){
        switch(str){
            
        case "该主机已被绑定","您没有绑定主机","主机处于离线状态","不能重复绑定主机","摄像头密码不能为空","正在执行情景模式","解绑成功","解绑失败,请重新解绑","当前版本暂时只能授权用户7个","授权失败","网络超时,查询失败","连续输错5次，APP远程开启锁定10分钟。","操作失败,密码错误","服务器发生异常","网络超时,通讯失败","设置失败,管理员密码错误","没有临时密码列表","操作失败,管理员密码错误","没有临时密码,请先设置个临时密码","主机已被绑定","服务器尚未添设该主机,请联系管理员处理","密码不正确","旧密码不正确","手机号或密码不正确","验证码错误","控制盒不能添加传感器","邮箱格式不正确","该邮箱已被其他账号绑定,请重新填写","当前ip请求频繁","该账号已注册,请去登录","手机号码格式不正确","该手机号码未注册","验证码已失效,请重新获取","验证码输入错误,请重新输入","修改失败","该邮箱未绑定过账号","该账户尚未注册","操作失败,门反锁","您已使用过该昵称","该情景模式没有情景信息":
            
            showMsg(msg: str)
            
            break
        default:
            if str.count > 8{
                print("提示字符串为:\(str)")
                if (str as NSString).substring(with: NSMakeRange(0, 4)) == "连续输错"{
                    print("设置失败")
                    
                }
            }
            break
            
        }
        
        
    }
    static func setUserPhone(_ userPhone:NSString){
        UserDefaults.standard.set(userPhone, forKey: "userPhone")
    }
    static func userPhone()->String{
        let acc = UserDefaults.standard.object(forKey: "userPhone") as? String
        if acc == nil{
            return ""
        }
        return acc!
        
    }
    
    static func accessToken()->String{
        let acc = UserDefaults.standard.object(forKey: "AccessToken") as? String
        if acc == nil{
            return ""}
        return acc!
    }
    @objc static func setAccessToken(_ accessToken:NSString){
        UserDefaults.standard.set(accessToken, forKey: "AccessToken")
    }
    static func refreshAccessToken()->String{
        let acc = UserDefaults.standard.object(forKey: "RefreshAccessToken") as? String
        if acc == nil{
            return ""
        }
        return acc!
        
    }
    static func setRefreshAccessToken(_ refreshAccessToken:NSString){
        UserDefaults.standard.set(refreshAccessToken, forKey: "RefreshAccessToken")
    }
    static func userCode()->String{
        let acc = UserDefaults.standard.object(forKey: "userCode") as? String
        if acc == nil{
            return ""
        }
        return acc!
        
    }
    static func userCity()->String{
        let acc = UserDefaults.standard.object(forKey: "userCity") as? String
        
        if acc == nil{
            return ""
        }
        return acc!
        
    }
    
    static func getuiserlogoAccountType()->String{
        let acc = UserDefaults.standard.object(forKey: "uiserlogoAccountType") as? String
        
        if acc == nil{
            return ""
        }
        return acc!
    }
    //授权解绑时候用
    static func getUserPhoneType()->String{
        let acc = UserDefaults.standard.object(forKey: "UserPhoneType") as? String
        
        if acc == nil{
            return ""
        }
        return acc!
    }
    //获取权限授权用户
    static func GetAccountOperationType()->String{
        let acc = UserDefaults.standard.object(forKey: "accountOperationType") as? String
        
        if acc == nil{
            return ""
        }
        return acc!
    }
    
    
    static func setUserCode(_ userCode:NSString){
        UserDefaults.standard.set(userCode, forKey: "userCode")
    }
    
    static func setUserCity(_ userCity:NSString){
        UserDefaults.standard.set(userCity, forKey: "userCity")
    }
    //设置判断授权
    static func setUserlogoAccountType(_ uiserlogoAccountType:NSString){
        UserDefaults.standard.set(uiserlogoAccountType, forKey: "uiserlogoAccountType")
    }
    //授权解绑时候用
    static func setUserPhoneType(_ UserPhoneType:NSString){
        UserDefaults.standard.set(UserPhoneType, forKey: "UserPhoneType")
    }
    //设置保存权限授权用户
    static func setAccountOperationType(_ accountOperationType:NSString){
        UserDefaults.standard.set(accountOperationType, forKey: "accountOperationType")
    }
    
    
    
    static func clearToken(){
        setRefreshAccessToken("")
        setAccessToken("")
        setUserCode("")
        setUserCity("")
        app.user?.releaseUser()
        setUserlogoAccountType("")
        app.App_room = ""
        //setUserPhoneType("")
    }
    
    static func timeStamp()->String {
        
        let localDate = Date().timeIntervalSince1970  //获取当前时间
        let  recordTime = UInt64(localDate)  //时间戳,*1000为取到毫秒
        
        
        let timesTamp = String(format: "%lld", recordTime)
        print(recordTime)
        return timesTamp
    }
    static func randomNumAndLetter()->String
    {
        let kNumber = 16;
        let sourceStr:NSString="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var resultStr = ""
        srandom(UInt32(time(nil)))
        for   _ in  0..<kNumber
        {
            let index = Int(arc4random_uniform(UInt32(time(nil))))%sourceStr.length
            let oneStr = sourceStr.substring(with: NSMakeRange(index, 1))
            resultStr += oneStr
        }
        return resultStr
    }
    
    
    
}
