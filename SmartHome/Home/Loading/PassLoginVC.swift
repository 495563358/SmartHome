//
//  LoginVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class PassLoginVC: UIViewController  {
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var passText: UITextField!
    @IBOutlet weak var passLoad: UIButton!
    var time = 30
    var timer:Timer?
    @IBOutlet var phoneNumBg: UIImageView!

    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var vcodeBtn: UIButton!
   
    @IBOutlet var missCodeLabel: UILabel!
    
    var userlist:[String:String]?=["":""]
    var userNames:[String]?=[""]
    override func viewDidLoad() {

        super.viewDidLoad()
      
        self.configView()
        //self.passLoad.hidden = true
        self.vcodeBtn.isHidden = true

        passText.placeholder = NSLocalizedString("请输入密码", comment: "")
        loginBtn.setTitle(NSLocalizedString("登录", comment: ""), for: UIControlState())
      
    }
    @IBAction func passwordload(_ sender: AnyObject) {
        print("忘记密码")
//        self.navigationController?.pushViewController(ForgetPassViewController(), animated: true)
        
    }
    //判断手机号
    func isTelNumber(_ num:NSString)->Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: num) == true)
            || (regextestcm.evaluate(with: num)  == true)
            || (regextestct.evaluate(with: num) == true)
            || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
 
    @IBAction func sendVCodeTap(_ sender: UIButton) {
        
         let phone = self.phoneText.text?.trimString()
        if phone == ""{
            showMsg(msg: NSLocalizedString("请输入正确的手机号", comment: ""))
            return
        }
        if phone!.characters.count != 11{
            showMsg(msg: NSLocalizedString("请输入正确的手机号", comment: ""))
            return
        }
//        if self.isTelNumber(phone!) != true{
//            return
//        }
        
        sender.isUserInteractionEnabled = false
        self.missCodeLabel.isHidden = false
            self.vcodeBtn.setTitleColor(UIColor.gray, for: UIControlState())
        self.passText.becomeFirstResponder()

        BaseHttpService.sendRequest(sendCode_do, parameters: ["userPhone":phone!,"versionType":"1"]) {[unowned self] (any:AnyObject) -> () in
        
            print(any)
            self.doTimer()
        }
        //to do Btn 上跑一个定时器；
      //  doTimer()
        
    }
    
    func doTimer(){
        
        time = 90
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PassLoginVC.timerFireMethod(_:)), userInfo: nil, repeats:true);
        timer!.fire()
    }
    @objc func timerFireMethod(_ timer: Timer) {
        if time == 0 {
            self.missCodeLabel.isHidden = true
            self.vcodeBtn.isUserInteractionEnabled = true
             self.vcodeBtn.setTitleColor(UIColor.blue, for: UIControlState())
            timer.invalidate()
        return
        }
        self.missCodeLabel!.text = "\(time)\(NSLocalizedString("秒之后点击获取验证码重新发送", comment: ""))"
        time = time - 1
        
    }
 
    func configView()
    {
        self.missCodeLabel.isHidden = true
        self.bgImg.image=loginBgImage!
        self.view.backgroundColor=UIColor.white
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
        self.loginBtn.setBackgroundImage(btnBgImage, for: UIControlState())
        self.loginBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        self.vcodeBtn.layer.cornerRadius=4.0
        self.vcodeBtn.layer.masksToBounds=true
        
               
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
        self.view.endEditing(true)
        BaseHttpService.clearToken()
        UserDefaults.standard.set("0", forKey: "password")
      let phone = self.phoneText.text?.trimString()
      let pwd = self.passText.text?.trimString()
        print("----a\(phone),\(pwd)")
        
        print(["phoneType":"1","CID":app.deviceToken,"userPhone":phone!,"userPwd":pwd!])
        BaseHttpService.sendRequest(lo_pass, parameters: ["phoneType":"1","CID":app.deviceToken,"userPhone":phone!,"userPwd":pwd!,"versionType":"1"]) { [unowned self](any:AnyObject) -> () in

            
            if any["success"] as! Bool == true{
                let dataDict:NSDictionary  = any["data"] as! NSDictionary
                BaseHttpService.setAccessToken(dataDict["accessToken"] as! NSString)
                BaseHttpService.setRefreshAccessToken(dataDict["refreshToken"] as! NSString)
                BaseHttpService.setUserCode(dataDict["userCode"] as! NSString)
                //判断主次账号
                BaseHttpService.setUserlogoAccountType(dataDict["logoAccountType"] as! NSString)
                BaseHttpService.setUserPhoneType(dataDict["userPhone"] as! NSString)
                BaseHttpService.setAccountOperationType(dataDict["accountOperationType"] as! NSString)
                
                let ezToken = dataDict["ez_token"] as! NSString
                let isFirst = dataDict["isFirst"] as! Bool
                BaseHttpService.setUserCity(dataDict["city"] as! NSString)
//                ezToken == "NO_BUNDING" ? nil : ezToken
//                GlobalKit.share().accessToken = ezToken as String!
//                EZOpenSDK.setAccessToken(GlobalKit.share().accessToken)
                self.loginSuccess(!isFirst)
                
            } else{
                showMsg(msg: any["message"] as! String)
                
            }//失效

            print(any)
        }
        
        //保存到本地
        //  setDefault(phone!, pwd:pwd!)
        //登陆到服务器
        
    
        
        
    }
    func loginSuccess(_ isFisrt:Bool){
        //读取房间信息
      
        
            if
                isFisrt == true
            {
                
                UserDefaults.standard.set(true, forKey: "isSecondLogin")
                
//                let creatHomeVC = CreatHomeViewController(nibName: "CreatHomeViewController", bundle: nil)
//                let creatNavigationC = UINavigationController(rootViewController: creatHomeVC)
//                app.window!.rootViewController = creatNavigationC
                
                
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
