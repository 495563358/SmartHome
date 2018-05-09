//
//  ChangeAccountVC.swift
//  SmartHome
//
//  Created by Smart house on 2018/5/8.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class ChangeAccountVC: UIViewController {
    
    var userPhoneText:UITextField = UITextField(frame: CGRect(x: 30, y: 130, width: ScreenWidth - 60, height: 35))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.title = "移交主账户"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChangeAccountVC.backClick))
        // Do any additional setup after loading the view.
        
        let noticeLabel = UILabel(frame: CGRect(x: 30, y: 20, width: ScreenWidth - 60, height: 100))
        noticeLabel.numberOfLines = 0
        noticeLabel.font = UIFont.systemFont(ofSize: 13)
        noticeLabel.textColor = UIColor.red
        noticeLabel.text = "温馨提示:\n    移交主账户后会失去该主账户下的所有设备信息以及管理权限,被移交人会获得该账户的所有设备信息以及管理权限,请谨慎操作。"
        self.view.addSubview(noticeLabel)
        
        userPhoneText.placeholder = "请输入接收用户的手机号"
        userPhoneText.font = UIFont.systemFont(ofSize: 15)
        userPhoneText.borderStyle = .roundedRect
        self.view.addSubview(userPhoneText)
        
        let sure = UIButton(frame: CGRect(x: ScreenWidth/2 - 100/2, y: userPhoneText.y + userPhoneText.mj_h + 30, width: 100, height: 35))
        sure.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sure.layer.cornerRadius = 5
        sure.layer.masksToBounds = true
        sure.setTitle("确认移交", for: .normal)
        sure.backgroundColor = systemColor
        sure.addTarget(self, action: #selector(ChangeAccountVC.approvalClick), for: .touchUpInside)
        self.view.addSubview(sure)
    }
    
    @objc func approvalClick(){
        self.view.endEditing(true)
        if BaseHttpService.getUserPhoneType() == ""{
            showMsg(msg: "获取主账户失败,请尝试重新登录")
            return
        }
        if (userPhoneText.text == nil) {
            showMsg(msg: "请输入被移交的用户账号")
            return
        }
        if isTelNumber(num: userPhoneText.text! as NSString) != true{
            showMsg(msg: NSLocalizedString("请输入正确的手机号", comment: ""))
            return
        }
        
        let oldNum = BaseHttpService.getUserPhoneType()
        let newNum = userPhoneText.text
        let parameter = ["newPhone":newNum,"oldPhone":oldNum]
        BaseHttpService.sendRequestAccessAndBackall(changeAccount, parameters: parameter as NSDictionary) { (AnyObject) in
            let result = AnyObject as! NSDictionary
            if result["message"] as! String == "移交成功"{
                showMsg(msg: result["message"] as! String)
                //退出登录
                let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
                UserDefaults.standard.set(0, forKey: "\(BaseHttpService.userCode())RoomInfoVersionNumber")
                BaseHttpService.clearToken()
                app.window!.rootViewController=nav
                UserDefaults.standard.set("0", forKey: "password")
            }else{
                showMsg(msg: result["message"] as! String)
            }
        }
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
