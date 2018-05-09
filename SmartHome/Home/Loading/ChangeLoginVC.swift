//
//  LoginVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class ChangeLoginVC: UIViewController  {
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var passText: UITextField!
    @IBOutlet var phoneNumBg: UIImageView!
    @IBOutlet var smartLog: UIImageView!

    @IBOutlet weak var possLod: UIButton!
//    @IBOutlet var bgImg: UIImageView!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!

    
    var userlist:[String:String]?=["":""]
    var userNames:[String]?=[""]
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.configView()
        phoneText.placeholder = NSLocalizedString("请输入手机号", comment: "")
        phoneText.keyboardType = .numberPad
        passText.placeholder = NSLocalizedString("请输入密码", comment: "")
        passText.keyboardType = .default
        loginBtn.setTitle(NSLocalizedString("登录", comment: ""), for: UIControlState())
        registerBtn.setTitle(NSLocalizedString("注册", comment: ""), for: UIControlState())
        possLod.setTitle(NSLocalizedString("找回密码", comment: ""), for: UIControlState())
        
        
    }
    @IBAction func passwordload(_ sender: AnyObject) {
        let creatHomeVC = ChangeSetPasVC(nibName: "ChangeSetPasVC", bundle: nil)
        self.navigationController?.pushViewController(creatHomeVC, animated: true)
    }
    @IBAction func RegisterbtnUp(_ sender: AnyObject) {
        let creatHomeVC = ChangeRegisterVC(nibName: "ChangeRegisterVC", bundle: nil)
        self.navigationController?.pushViewController(creatHomeVC, animated: true)
    }
    
    func configView()
    {
 
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
        self.loginBtn.setBackgroundImage(btnBgImage, for: UIControlState())
        self.loginBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)

        self.registerBtn.layer.cornerRadius=7.0
        self.registerBtn.layer.masksToBounds=true
        
        
        phoneNumBg.frame = CGRect(x: 15 , y: 66 + 120 + 44, width: ScreenWidth - 30, height: 100)
        smartLog.frame = CGRect(x: (ScreenWidth - 120)/2 , y: 66, width: 120, height: 120)
        phoneText.frame = CGRect(x: 30 , y: 66 + 120 + 44, width: ScreenWidth - 60, height: 50)
        passText.frame = CGRect(x: 30 , y: 66 + 120 + 44 + 50, width: ScreenWidth - 60, height: 50)
        
        let spaceL:UILabel = UILabel(frame: CGRect(x: 15 , y: 66 + 120 + 44 + 49, width: ScreenWidth - 30, height: 1))
        let mygray:UIColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        spaceL.backgroundColor = mygray
        
        self.view.addSubview(spaceL)
        
        //Y = 66 + 120 + 44 + 100 = 330
        
        loginBtn.frame = CGRect(x: 15, y: 330 + 40, width: ScreenWidth - 30, height: 50)
        loginBtn.layer.cornerRadius = 10.0;
        
        
        registerBtn.frame = CGRect(x: 21, y: 420 + 14 , width: 50, height: 25)
        registerBtn.backgroundColor = UIColor.clear
        
        possLod.frame = CGRect(x: ScreenWidth - 21 - 80, y: 420 + 14, width: 80, height: 25)
        passText.isSecureTextEntry = true
        
        let showPWD:UIButton = UIButton()
        showPWD.frame = CGRect(x: 0, y: 0, width: 16, height: 20)
        showPWD.setImage(UIImage(named: "buxiansmm"), for:UIControlState())
        showPWD.addTarget(self, action:#selector(ChangeLoginVC.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        showPWD.tag = 100
        
        passText.rightViewMode = UITextFieldViewMode.always
        passText.rightView = showPWD
        
        
        
        let spaceL2:UIImageView = UIImageView(frame: CGRect(x: 0 , y: ScreenHeight - 155, width: ScreenWidth, height: 15 * ScreenWidth/375))
//        spaceL2.backgroundColor = UIColor.grayColor()
        spaceL2.image = UIImage(named: "dsfdl")
        
        
        
        let qqLoad:UIButton = UIButton(frame: CGRect(x: 134, y: ScreenHeight - 120, width: 40, height: 40))
        
        
        qqLoad.setImage(UIImage(named: "qq"), for:UIControlState())
        qqLoad.addTarget(self, action:#selector(ChangeLoginVC.qqLoadClick), for: UIControlEvents.touchUpInside)
        
        
        
        
        
        
        let wxLoad:UIButton = UIButton(frame: CGRect(x: ScreenWidth - 134 - 40, y: ScreenHeight - 120, width: 40, height: 40))
        
        
        wxLoad.setImage(UIImage(named: "weixin"), for:UIControlState())
        wxLoad.addTarget(self, action:#selector(ChangeLoginVC.wxLoadClick), for: UIControlEvents.touchUpInside)
        
        
        //qq 微信 登录
//        self.view.addSubview(wxLoad)
//        self.view.addSubview(qqLoad)
//        self.view.addSubview(spaceL2)
        
        
 
    }
    
    
    @objc func qqLoadClick(){
        
        print("qq")
    }
    
    @objc func wxLoadClick(){
        print("wx")
        
    }
    
    
    
    @objc func buttonTapped(_ sender: UIButton){
        if (sender.tag == 100) {
            sender.tag = 1
            sender.setImage(UIImage(named: "xiansmm"), for:UIControlState())
            passText.isSecureTextEntry = false
        }else{
            sender.tag = 100;
            sender.setImage(UIImage(named: "buxiansmm"), for:UIControlState())
            passText.isSecureTextEntry = true
        }
    }
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let image:UIImage = imageWithColor(color: UIColor.clear)
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        if BaseHttpService.getUserPhoneType() == ""{
            phoneText.placeholder = NSLocalizedString("请输入手机号", comment: "")
        }else{
            phoneText.text = BaseHttpService.getUserPhoneType()
        }
        self.navigationController!.navigationBar.shadowImage=image
        
    }

    @IBAction func loginTap(_ sender: AnyObject) {
        //------------------------------------------------
        self.view.endEditing(true)
        BaseHttpService.clearToken()
        UserDefaults.standard.set("0", forKey: "password")
        let phone = self.phoneText.text?.trimString()
        let pwd = self.passText.text?.trimString()
        print("登录信息\(["CID":app.deviceToken,"账号":phone!,"密码":pwd!,"推送设备号":app.uPushdeviceToken])")
        BaseHttpService.sendRequest(appUserLogin, parameters: ["phoneType":"1","CID":app.deviceToken,"userPhone":phone!,"userPwd":pwd!,"versionType":"6","devicetoken":app.uPushdeviceToken]) { [unowned self](any:AnyObject) -> () in
                if any["success"] as! Bool == true{
                    let dataDict:NSDictionary = any["data"] as! NSDictionary
                    let isFirst = dataDict["isFirst"] as! Bool
                    BaseHttpService.setAccessToken(dataDict["accessToken"] as! NSString)
                    BaseHttpService.setRefreshAccessToken(dataDict["refreshToken"] as! NSString)
                    BaseHttpService.setUserCode(dataDict["userCode"] as! NSString)
                    BaseHttpService.setUserPhone(phone! as NSString)
                    //判断主次账号
                    BaseHttpService.setUserlogoAccountType(dataDict["logoAccountType"] as! NSString)
                    let ezToken = dataDict["ez_token"] as!String
                    //let isFirst = dataDict["isFirst"] as! Bool
                    BaseHttpService.setUserCity(dataDict["city"] as! NSString)
                    BaseHttpService.setUserPhoneType(dataDict["userPhone"] as! NSString)
                    BaseHttpService.setAccountOperationType(dataDict["accountOperationType"] as! NSString)
                    print("login : \(ezToken)")
//                    GlobalKit.share().accessToken = ezToken == "NO_BUNDING" ? nil : ezToken
//                    EZOpenSDK.setAccessToken(GlobalKit.share().accessToken)
                    //------------------------------------------------
                    //判断设置密码
                    let bool = dataDict["whetherSetPwd"] as! Bool
                    if bool {
//                        self.loginSuccess(!isFirst)
                        self.loginSuccess(false)
                    }else{
//                        let vc1 = loadPassViewController()
//                        vc1.bool = bool
//                        vc1.fanhui({ [unowned self](and) -> () in
//                            self.loginSuccess(!isFirst)
//                            })
//                        self.navigationController?.pushViewController(vc1, animated: true)
                    }

                } else{
                    showMsg(msg: NSLocalizedString(any["message"] as! String, comment: ""))
                }//失效
                
                print(any)
                
            }

 
        
        //保存到本地
//          setDefault(phone!, pwd:pwd!)
        //登陆到服务器
    }
    func loginSuccess(_ isFisrt:Bool){
        //读取房间信息
            if isFisrt == true
            {
                UserDefaults.standard.set(true, forKey: "isSecondLogin")
                
                let creatHomeVC = CreatHomeViewController(nibName: "CreatHomeViewController", bundle: nil)
                let creatNavigationC = UINavigationController(rootViewController: creatHomeVC)
                app.window!.rootViewController = creatNavigationC
                
                
            }else{
                 app.window!.rootViewController = TabbarC()
            }
       
    
    
    }
    @IBAction func onExit(_ sender: AnyObject) {
        self.view.endEditing(true)
       // self.userNameTableView?.hidden = true
    }
       @IBAction func showUserList(_ sender: UIButton) {
        userlist = UserDefaults.standard.object(forKey: "userList") as? [String:String]
        userNames?.removeAll()
        for key in (userlist?.keys)!{
           userNames?.append(key)
        }

    }
 
    
         // MARK: - Table view data source
    //返回节的个数
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        return 1
//    }
//    //返回某个节中的行数
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return (self.userNames?.count)!
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell:userNameCell? = tableView.dequeueReusableCellWithIdentifier("userNameCell",forIndexPath: indexPath) as? userNameCell
//        
//        cell?.tag=indexPath.row
//        print(cell?.tag)
//        cell?.deleteSelf=deleteSelf
//        cell?.userName?.text = self.userNames?[indexPath.row]
//        return cell!
//    }
//    func deleteSelf(tag:Int){
//        print(tag)
//        self.userlist?.removeValueForKey((self.userNames?[tag])!)
//        self.userNames?.removeAtIndex(tag)
//        self.userNameTableView?.frame=CGRectMake(2, phoneNumBg.frame.height+phoneNumBg.frame.origin.y, phoneNumBg.frame.width-4, CGFloat(Float((self.userNames?.count)!*35)))
//        NSUserDefaults.standardUserDefaults().setObject(userlist, forKey: "userList")
//        self.userNameTableView?.reloadData()
//        
//    }    //点击事件
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        self.phoneText.text=self.userNames?[indexPath.row]
//        print(self.userlist!)
//        self.passText.text=self.userlist![(self.userNames?[indexPath.row])!]
//        self.userNameTableView?.hidden = true
//    }
//    //高度
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 35
//    }
    
}
