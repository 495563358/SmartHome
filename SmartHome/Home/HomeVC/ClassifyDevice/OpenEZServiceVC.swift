//
//  OpenEZServiceVC.swift
//  SmartHome
//
//  Created by sunzl on 16/6/14.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
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


class OpenEZServiceVC: UIViewController {
    var time = 30
    var timer:Timer?
    @IBOutlet var vcode: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var vcodeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let bbi_r2 = UIBarButtonItem(title: NSLocalizedString("立即开通", comment: ""),style:UIBarButtonItemStyle.plain, target:self ,action:Selector("openEZ"))
        bbi_r2.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItems = [bbi_r2]
       // vcodeBtn.setTitle(NSLocalizedString("点击获取开通萤石服务验证码", comment: ""), forState: .Normal)
        self.label.text = NSLocalizedString("点击获取开通萤石服务验证码", comment: "")
        vcode.text = NSLocalizedString("输入手机获取的验证码", comment: "")
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        
    }
    func openEZ(){
        if vcode.text?.trimString() == ""
        {
            showMsg(msg: "验证码不能为空")
            return
        }
        if  vcode.text?.trimString().count  < 4
        {
            showMsg(msg: "验证码长度不正确")
            return
        }
        EZOpenSDK.openEzvizService(BaseHttpService.userPhone(), smsCode: vcode.text?.trimString()){(err) -> Void in
            if err != nil{
                print((err! as NSError).userInfo["NSLocalizedDescription"]as!String)
                if ((err! as NSError).userInfo["NSLocalizedDescription"] as!String == "https error code = 10012") {
                    showMsg(msg: "账户不能重复开通")
                    
                }else   if ((err! as NSError).userInfo["NSLocalizedDescription"] as!String == "https error code = 10004") {
                    
                    showMsg(msg: "用户不存在")
                }else  if ((err! as NSError).userInfo["NSLocalizedDescription"] as!String == "https error code = 20018") {
                    
                    showMsg(msg: "手机号不合法")
                }
            }else{
                
                showMsg(msg: "开通成功")
            }
        }
        
        
    }
    
    @IBAction func onExit(_ sender: AnyObject) {
        
    }
    
    
    @IBAction func getCodeTap(_ sender: AnyObject) {
        EZOpenSDK.getOpenEzvizServiceSMSCode(BaseHttpService.userPhone()) { (err) -> Void in
            if(err == nil){
                self.vcodeBtn.isUserInteractionEnabled = false
                self.doTimer()
            }
        }
    }
    
    func doTimer(){
        
        time = 90
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
        timer!.fire()
    }
    
    func timerFireMethod(_ timer: Timer) {
        if time == 0 {
            
            self.vcodeBtn.isUserInteractionEnabled = true
            self.vcodeBtn.setTitleColor(UIColor.blue, for: UIControlState())
             //self.vcodeBtn.setTitle(NSLocalizedString("点击重新发送", comment: ""), forState: UIControlState.Normal)
            self.label.text = NSLocalizedString("点击重新发送", comment: "")
            timer.invalidate()
            return
        }
       // self.vcodeBtn.setTitle("\(time)\(NSLocalizedString("秒之后点击获取验证码重新发送", comment: ""))", forState: UIControlState.Normal)
        self.label.text = "\(time)\(NSLocalizedString("秒之后点击获取验证码重新发送", comment: ""))"
        time = time - 1
        
    }
    
}
