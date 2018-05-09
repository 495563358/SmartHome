//
//  AppDelegate.swift
//  SmartHome
//
//  Created by Smart house on 2018/1/23.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow? = UIWindow.init(frame: UIScreen.main.bounds)
    var user:UserModel?=UserModel()
    var  deviceToken:NSString = ""
    //友盟推送设备号
    @objc var uPushdeviceToken:NSString = ""
    //定时器
    var i=0
    //房间
    var App_room = ""
    var App_roomName = ""
    //红外模块数组、
    var infArr = [String]()
    @objc var models = [ChainModel]()
    var modelEquipArr = NSMutableArray()
    var isNotFirst:Bool?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
        self.window!.makeKeyAndVisible();
        dataDeal.creatUserTable()
        dataDeal.creatFloorTable()
        dataDeal.creatRoomTable()
        dataDeal.creatEquipTable()
        print(NSHomeDirectory())
        
        //第一次安装会走引导页
        isNotFirst = (UserDefaults.standard.object(forKey: "isNotFirstComming") as AnyObject).boolValue
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if isNotFirst == nil || isNotFirst == false {
            let guidevc:GuideViewController = GuideViewController(coverImageNames: ["引导页1","引导页2","引导页3"], backgroundImageNames: nil)
            guidevc.didSelectedEnter = didSelectedEnter
            UserDefaults.standard.set(true, forKey: "isNotFirstComming")
            self.window!.rootViewController = guidevc
        }else{
            
            //非第一次登陆，直接进入登陆界面
            secondLogin()
            
        }
        self.setUpErrorTest()
        self.registerRemoteNotification()
        
        let appKey = "59bb729265b6d611770006b8"
        UMessage.start(withAppkey: appKey, launchOptions: launchOptions,httpsEnable:true)
        
        UMessage.registerForRemoteNotifications()
        // 打开日志，方便调试
        UMessage.setLogEnabled(true)
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            UIApplication.shared.registerForRemoteNotifications()
            
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted:Bool,_ error:Error?) -> Void in
                
                if granted {
                    
                    //点击允许推送服务
                }else{
                    //点击不允许推送服务
                    
                }
                
            })
            
        } else {
            // Fallback on earlier versions
        }
        
        ObjectTools.createShare()
        ObjectTools.removeHead()
        
        IFlySpeechUtility.createUtility("appid=5ae3d768,timeout=20000")
        
        // Override point for customization after application launch.
        return true
    }
    
    func didSelectedEnter(){
        
        let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
        self.window!.rootViewController=nav
        print("完毕")
    }
    
    func secondLogin(){
        if BaseHttpService.userCode()=="" || BaseHttpService.refreshAccessToken()=="" || BaseHttpService.accessToken()==""
        {
            let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
            self.window!.rootViewController=nav
        }else{
            self.window!.rootViewController = TabbarC()
        }
        
    }
    
    //程序将进入后台
    func applicationWillResignActive(_ application: UIApplication) {
        let currVC:UIViewController = UIWindow.visibleViewController()
        if (currVC.navigationController == nil){
            print("不是导航控制器")
            return
        }
        let str = NSStringFromClass(currVC.classForCoder)
        if str == "CameraManagerVC"{
            print("当前在管理摄像头页面")
            return
        }
        for temp in (currVC.navigationController?.viewControllers)!{
            let str = NSStringFromClass(temp.classForCoder)
            print(str)
            if str == "CameraManagerVC"{
                print("返回了")
                currVC.navigationController?.popToViewController(temp, animated: false)
                return
            }
        }
        if str == "HTPlayCamerViewController"{
            currVC.navigationController?.popToRootViewController(animated: false)
        }
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    //程序进入前台 app启动时会进入此方法
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //判断版本
        Alamofire.request(appVersionManager,method:.post,parameters: ["phoneType":"1","provider":"6","appVersion":"1.0"]).responseJSON { (response) -> Void in
            print(response)
            
            if response.result.isFailure {
                print("网路问题-error:\(response.result.error)")
            }else{
                if (response.result.value!as![String:AnyObject]).keys.contains("statusCode"){
                    print("服务器返回异常数据")
                    return;
                }
                if ((response.result.value as! NSDictionary)["data"] as AnyObject).isEqual(NSNull()){
                    
                }else{
                    let arr = ((response.result.value as! NSDictionary)["data"] as! NSDictionary)
                    print(arr)
                    if arr.count == 1{
                        UIAlertView(title: NSLocalizedString("版本更新", comment: ""), message: NSLocalizedString("请更新版本", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("确定", comment: "")).show()
                    }
                }
            }
        }
        
        //如果设置了屏锁 就显示以下界面
        let password = UserDefaults.standard.object(forKey: "password")
        if (password as? String) == "1"{
            let db =  DBGViewController()
            db.hidesBottomBarWhenPushed = true
            db.isLogin = true
            UIWindow.visibleViewController().navigationController?.pushViewController(db, animated: true)
        }
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) -> Void in
                if let Alipayjson = resultDic as NSDictionary?{
                    let resultStatus = Alipayjson.value(forKey: "resultStatus") as! String
                    if resultStatus == "9000"{
                        print("OK")
                    }else if resultStatus == "8000" {
                        print("正在处理中")
                    }else if resultStatus == "4000" {
                        print("订单支付失败");
                    }else if resultStatus == "6001" {
                        print("用户中途取消")
                    }else if resultStatus == "6002" {
                        print("网络连接出错")
                    }
                }
            })
            return true
        }
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        print(2);
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onResp(_ resp: BaseResp!) {
        
        
        let ducumentPath = NSHomeDirectory() + "/Documents/orderinfo.plist"
        let mdict = NSMutableDictionary(contentsOfFile: ducumentPath)
        if mdict == nil{
            return
        }
        let flag:String = mdict?.object(forKey: "flag") as! String
        
        if flag == "cz"{
            
            if(resp.isKind(of: PayResp.self)){
                let response:PayResp = resp as! PayResp
                switch(response.errCode){
                case 0:
                    mdict?.setObject(self.getNowTimeTimestamp(), forKey:"timestamp" as NSCopying)
                    
                    print(mdict as Any)
                    let ipaddr = mdict?.object(forKey: "ip")
                    let nonce = mdict?.object(forKey: "nonce")
                    let ordersn = mdict?.object(forKey: "ordersn")
                    let price = mdict?.object(forKey: "price")
                    let sign = mdict?.object(forKey: "sign")
                    let timestamp = mdict?.object(forKey: "timestamp")
                    let token = mdict?.object(forKey: "token")
                    
                    Alamofire.request("http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.complete2",method:.post , parameters: ["ip":ipaddr!,"nonce":nonce!,"ordersn":ordersn!,"price":price!,"sign":sign!,"timestamp":timestamp!,"token":token!] ).responseJSON { (response) -> Void in
                        //                    print("结果",response)
                        
                        let alertCtr = UIAlertController.init(title: nil, message: "充值成功,重新进入个人中心即可查看最新余额", preferredStyle: UIAlertControllerStyle.alert)
                        alertCtr.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil))
                        
                        UIApplication.shared.keyWindow?.rootViewController?.present(alertCtr, animated:true, completion: nil)
                    }
                    
                    break
                default:
                    let alertCtr = UIAlertController.init(title: nil, message: "充值失败,您取消了支付", preferredStyle: UIAlertControllerStyle.alert)
                    alertCtr.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil))
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertCtr, animated:true, completion: nil)
                    break
                }
                
                print(response.errCode)
                
            }
        }else if flag == "dd"{
            
            if(resp.isKind(of: PayResp.self)){
                let response:PayResp = resp as! PayResp
                switch(response.errCode){
                case 0:
                    
                    mdict?.setObject(self.getNowTimeTimestamp(), forKey:"timestamp" as NSCopying)
                    
                    print(mdict)
                    
                    let nonce = mdict?.object(forKey: "nonce")
                    let ordersn = mdict?.object(forKey: "ordersn")
                    let sign = mdict?.object(forKey: "sign")
                    let timestamp = mdict?.object(forKey: "timestamp")
                    let token = mdict?.object(forKey: "token")
                    
                    
                    Alamofire.request("http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.complete",method:.post, parameters: ["nonce":nonce!,"ordersn":ordersn!,"sign":sign!,"timestamp":timestamp!,"token":token!] ).responseJSON { (response) -> Void in
                        //                    print("结果",response)
                        
                        let alertCtr = UIAlertController.init(title: nil, message: "支付成功,您可以进入个人订单查看订单信息", preferredStyle: .alert)
                        alertCtr.addAction(UIAlertAction.init(title: "确定", style: .default, handler: {
                            action in
                            print("支付成功")
                            
                        }))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alertCtr, animated:true, completion: nil)
                    }
                    
                    break
                default:
                    print(mdict as Any);
                    let alertCtr = UIAlertController.init(title: nil, message: "支付失败,您取消了支付", preferredStyle: .alert)
                    alertCtr.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertCtr, animated:true, completion: nil)
                    break
                }
                
                print(response.errCode)
                
            }
            
        }
        
        
    }
    
    
    func getNowTimeTimestamp() ->String{
        let date = Date()
        let timeinterv = date.timeIntervalSince1970
        
        let dateSt:Int = Int(timeinterv)
        
        return String(dateSt)
        
    }
    
    //iOS10以下使用这个方法接收通知
    func application(_application:UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable:Any]) {
        print("iOS10以下系统接收到通知 = \(userInfo)")
        /// 统计点击数
        UMessage.didReceiveRemoteNotification(userInfo)
        
        //通知名称常量
        let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyOutView")
        //发送通知接收到审核通过退押金的消息退出用户登录
        NotificationCenter.default.post(name:NotifyChatMsgRecv, object: nil, userInfo: nil)
    }
    
    //iOS10新增：处理前台收到通知的代理方法 (就是 APP 正在用的时候就是前台)
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center:UNUserNotificationCenter, willPresent notification:UNNotification, withCompletionHandler completionHandler:@escaping(UNNotificationPresentationOptions) ->Void) {
        
        print("前台收到通知 = \(notification.request.content.userInfo)")
        
        let userInfo: [AnyHashable:Any]? = notification.request.content.userInfo
        
        print(userInfo!["typekey"] as Any)
        
        if(notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            UMessage.setAutoAlert(false)
            //必须加这句代码，统计点击数
            UMessage.didReceiveRemoteNotification(userInfo)
            
            //            FYUserDefaults.save(obj: "pushUserInfo", forKey: "pushUserInfo")
            
            //通知名称常量
            let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyOutView")
            //发送通知接收到审核通过退押金的消息退出用户登录
            NotificationCenter.default.post(name:NotifyChatMsgRecv, object: nil, userInfo: nil)
            
            if(userInfo!["typekey"] != nil){
                //客户端离线
                if userInfo!["typekey"] as! String == "appoffline"{
                    let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                    UserDefaults.standard.set(0, forKey: "\(BaseHttpService.userCode())RoomInfoVersionNumber")
                    BaseHttpService.clearToken()
                    //let app = UIApplication.sharedApplication().delegate as! AppDelegate
                    app.window!.rootViewController=nav
                    // [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"password"];
                    
                    UserDefaults.standard.set("0", forKey: "password")
                }
                if userInfo!["typekey"] as! String == "malllogin"{
                    let user = UserDefaults.standard
                    user.set(nil, forKey: "userToken")
                    user.synchronize()
                }
            }
//
//            let messageVC = MessageViewController()
//            UIWindow.visibleViewController().navigationController?.pushViewController(messageVC, animated: true)
            
        }
            
        else{
            
            //应用处于前台时的本地推送接受
            
        }
        
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler([.alert, .sound, .badge])
        
    }
    
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("后台收到通知 = \(response.notification.request.content.userInfo)")
        
        let userInfo: [AnyHashable:Any]? = response.notification.request.content.userInfo
        
        if(response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            
            //应用处于后台时的远程推送接受
            
            //必须加这句代码，统计点击数
            UMessage.didReceiveRemoteNotification(userInfo)
            
            
            //通知名称常量
            let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyOutView")
            //发送通知接收到审核通过退押金的消息退出用户登录
            NotificationCenter.default.post(name:NotifyChatMsgRecv, object: nil, userInfo: nil)
            
            print(userInfo!["typekey"] as Any)
            
            if(userInfo!["typekey"] != nil){
                if userInfo!["typekey"] as! String == "malllogin"{
                    let user = UserDefaults.standard
                    user.set(nil, forKey: "userToken")
                    user.synchronize()
                    
                    let loadVC = LoadViewController()
                    loadVC.hidesBottomBarWhenPushed = true
                    UIWindow.visibleViewController().navigationController?.pushViewController(loadVC, animated: true)
                    loadVC.hidesBottomBarWhenPushed = false
                }
                return
            }
            
            let messageVC = MessageViewController()
            messageVC.hidesBottomBarWhenPushed = true
            UIWindow.visibleViewController().navigationController?.pushViewController(messageVC, animated: true)
            messageVC.hidesBottomBarWhenPushed = false
        }
            
        else{
            
            //应用处于后台时的本地推送接受
            
        }
    }
    
    // 获取 deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let device = NSData(data: deviceToken)
        
        let deviceId = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
        uPushdeviceToken = deviceId as NSString
        UMessage.registerDeviceToken(deviceToken)
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.konlin.SmartHome" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SmartHome", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SmartHome")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

