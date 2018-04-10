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


class ChangeRegisterVC: UIViewController,UIAlertViewDelegate  {
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var mailboxText: UITextField!
    @IBOutlet var passText: UITextField!
    @IBOutlet var pass2Text: UITextField!
 
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
//        self.navigationController?.navigationItem.title = "用户注册"
      
        self.configView()
        loginBtn.setTitle(NSLocalizedString("提交", comment: ""), for: UIControlState())
        phoneText.placeholder=NSLocalizedString("请输入手机号", comment: "")
        mailboxText.placeholder=NSLocalizedString("请输入邮箱(可选)", comment: "")
        passText.placeholder=NSLocalizedString("请输入登录密码", comment: "")
        pass2Text.placeholder=NSLocalizedString("请确认登录密码", comment: "")


    }



    


    func configView()
    {
        self.view.backgroundColor=UIColor.white
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
        self.loginBtn.setBackgroundImage(btnBgImage, for: UIControlState())
        self.loginBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let image:UIImage = imageWithColor(color: UIColor.clear)
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage=image
        
    }

    @IBAction func loginTap(_ sender: AnyObject) {
        self.view.endEditing(true)
        let languages = Locale.preferredLanguages
        let currentLanguage = languages[0]
        print(currentLanguage)
        if phoneText.text == ""{
            showMsg(msg: NSLocalizedString("请输入手机号", comment: ""))
            return
        }
        //判断是否中文，中文邮箱可以不填
        if mailboxText.text == "" && currentLanguage != "zh-Hans-CN"{
            showMsg(msg: NSLocalizedString("请填写邮箱", comment: ""))
            return
        }
        if passText.text == "" || pass2Text.text == ""{
            showMsg(msg: NSLocalizedString("请输入密码", comment: ""))
            return
        }
        if passText.text?.characters.count < 6 || passText.text?.characters.count > 19{
            showMsg(msg: NSLocalizedString("密码格式不正确(6-18)", comment: ""))
            return
        }
        if passText.text != pass2Text.text{
            showMsg(msg: NSLocalizedString("两次密码不一致", comment: ""))
            return
        }
      //  参数 userPhone手机号 userPwd 密码 userEmail 邮箱
        let dic = ["userPhone":phoneText.text!,"userPwd":passText.text!,"userEmail":mailboxText.text!,"versionType":"6"]
        BaseHttpService.sendRequest(appUserRegister, parameters: dic as NSDictionary) { (any:AnyObject) -> () in
            if (any as! NSDictionary)["message"] as! String == "1"{
                let alertView = UIAlertView(title: NSLocalizedString("设置成功", comment: ""), message: nil, delegate: self, cancelButtonTitle: NSLocalizedString("确定", comment: ""))
                alertView.tag = 1
                alertView.show()
            }else{
                showMsg(msg: NSLocalizedString((any as! NSDictionary)["message"] as! String, comment: ""))
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
