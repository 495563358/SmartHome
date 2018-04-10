//
//  LoginVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ChangeSetPasVC: UIViewController,UIAlertViewDelegate  {
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var VerificationText: UITextField!
    @IBOutlet var passText: UITextField!
    @IBOutlet var pass2Text: UITextField!
    @IBOutlet weak var SenBtn: UIButton!
    var time = 30
    var timer:Timer?

    @IBOutlet weak var showTime: UILabel!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet var loginBtn: UIButton!
    
    //判断手机号还是邮箱
    var phoneStat = "0"
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.navigationItem.title = "密码找回"
      
        self.configView()


    }


    @objc func change(_ sender:UISegmentedControl){
        self.view.endEditing(true)
        phoneText.text = ""
        VerificationText.text = ""
        passText.text = ""
        pass2Text.text = ""
        if sender.selectedSegmentIndex == 0{
            phoneText.placeholder = NSLocalizedString("请输入手机号", comment: "")
            phoneText.keyboardType = .phonePad
            phoneStat = "0"
        } else if sender.selectedSegmentIndex == 1{
            phoneText.placeholder = NSLocalizedString("请输入注册邮箱", comment: "")
            phoneText.keyboardType = UIKeyboardType.default
            phoneStat = "1"
        }
    }
    //初始化
    func configView()
    {
 
        self.view.backgroundColor=UIColor.white
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
        self.loginBtn.setBackgroundImage(btnBgImage, for: UIControlState())
        self.loginBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        
        passText.placeholder = NSLocalizedString("请输入验证码", comment: "")
        loginBtn.setTitle(NSLocalizedString("提交", comment: ""), for: UIControlState())
        SenBtn.setTitle(NSLocalizedString("发送验证码", comment: ""), for: UIControlState())
        SenBtn.addTarget(self, action: #selector(ChangeSetPasVC.sendVCodeTap(_:)), for: UIControlEvents.touchUpInside)
        phoneText.placeholder = NSLocalizedString("请输入手机号", comment: "")
        VerificationText.placeholder = NSLocalizedString("请输入验证码", comment: "")
        passText.placeholder = NSLocalizedString("请输入登录密码", comment: "")
        pass2Text.placeholder = NSLocalizedString("请确认登录密码", comment: "")
        segmented.setTitle(NSLocalizedString("手机号找回", comment: ""), forSegmentAt: 0)
        segmented.setTitle(NSLocalizedString("邮箱找回", comment: ""), forSegmentAt: 1)
        segmented.addTarget(self, action: #selector(ChangeSetPasVC.change(_:)), for: UIControlEvents.valueChanged)
        showTime.isHidden = true
        showTime.text = NSLocalizedString("60秒之后点击获取验证码重新发送", comment: "")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let image:UIImage = imageWithColor(color: UIColor.clear)
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage=image
        
    }
    @objc func sendVCodeTap(_ sender: UIButton){
        if phoneText.text == ""{
            showMsg(msg: NSLocalizedString("请输入账号", comment: ""))
            return
        }
        self.view.endEditing(true)
        if phoneStat == "0"{
            //手机号发送验证码
            BaseHttpService.sendRequest(phoneVcode, parameters: ["userPhone":phoneText.text!,"versionType":"6"]) {[unowned self] (any:AnyObject) -> () in
                if any["success"] as! Bool == true{
                    if any.count == 0{
                        self.showTime.isHidden = true
                        self.SenBtn.isUserInteractionEnabled = true
                        return
                    }
                    
                    self.showTime.isHidden = false
                    sender.isUserInteractionEnabled = false
                    self.SenBtn.setTitleColor(UIColor.gray, for: UIControlState())
                    //self.passText.becomeFirstResponder()
                    
                    print(any)
                    self.doTimer()
                }else{
                    showMsg(msg: NSLocalizedString(any["message"] as! String, comment: ""))
                }
                
            }
        }else{
            //邮箱发送验证码
            BaseHttpService.sendRequest(emailVcode, parameters: ["userEmail":phoneText.text!,"versionType":"6"]) {[unowned self] (any:AnyObject) -> () in
                if any["success"] as! Bool == true{
                    if any.count == 0{
                        self.showTime.isHidden = true
                        self.SenBtn.isUserInteractionEnabled = true
                        return
                    }
                    
                    self.showTime.isHidden = false
                    sender.isUserInteractionEnabled = false
                    self.SenBtn.setTitleColor(UIColor.gray, for: UIControlState())
                    //self.passText.becomeFirstResponder()
                    
                    print(any)
                    self.doTimer()
                }else{
                    showMsg(msg: NSLocalizedString(any["message"] as! String, comment: ""))
                }
                
            }
        }
    }
    
    func doTimer(){
        
        time = 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ChangeSetPasVC.timerFireMethod(_:)), userInfo: nil, repeats:true);
        timer!.fire()
    }
    @objc func timerFireMethod(_ timer: Timer) {
        if time == 0 {
            self.showTime.isHidden = true
            self.SenBtn.isUserInteractionEnabled = true
            self.SenBtn.setTitleColor(UIColor.blue, for: UIControlState())
            timer.invalidate()
            return
        }
        
        self.showTime!.text = "\(time)\(NSLocalizedString("秒之后点击获取验证码重新发送", comment: ""))"
        time = time - 1
        print(time)
    }
    
    @IBAction func loginTap(_ sender: AnyObject) {
        //--------------------------提交
            self.view.endEditing(true)
        
        if phoneText.text == ""{
            showMsg(msg: NSLocalizedString("请输入账号", comment: ""))
            return
        }
        if VerificationText.text == ""{
            showMsg(msg: NSLocalizedString("请输入验证码", comment: ""))
            return
        }
        if passText.text == "" || pass2Text.text == ""{
            showMsg(msg: NSLocalizedString("请输入密码", comment: ""))
            return
        }
        if passText.text?.characters.count < 6 || passText.text?.count > 19{
            showMsg(msg: NSLocalizedString("密码格式不正确(6-18)", comment: ""))
            return
        }
        if passText.text != pass2Text.text{
            showMsg(msg: NSLocalizedString("两次密码不一致", comment: ""))
            return
        }
        if phoneStat == "0"{
             //手机号找回
            let dic = ["userPhone":phoneText.text!,"userPwd":passText.text!,"code":VerificationText.text!,"versionType":"6"]
            BaseHttpService.sendRequest(find_pwd, parameters: dic as NSDictionary) { (any:AnyObject) -> () in
                if any["success"] as! Bool == true{
                    let alertView = UIAlertView(title: NSLocalizedString("设置成功", comment: ""), message: nil, delegate: self, cancelButtonTitle: NSLocalizedString("确定", comment: ""))
                    alertView.tag = 1
                    alertView.show()
                }else{
                    showMsg(msg: NSLocalizedString(any["message"] as! String, comment: ""))
                }
            }
        }else{
                //邮箱找回
            let dic = ["userEmail":phoneText.text!,"userPwd":passText.text!,"code":VerificationText.text!,"versionType":"6"]
            BaseHttpService.sendRequest(find_email_pwd, parameters: dic as NSDictionary) { (any:AnyObject) -> () in
                if any["success"] as! Bool == true{
                    let alertView = UIAlertView(title: "设置成功", message: nil, delegate: self, cancelButtonTitle: "确定")
                    alertView.tag = 1
                    alertView.show()
                }else{
                    showMsg(msg: NSLocalizedString(any["message"] as! String, comment: ""))
                }
            }
        }
        
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 1{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onExit(_ sender: AnyObject) {
        self.view.endEditing(true)
       // self.userNameTableView?.hidden = true
    }

 
    //键盘消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
