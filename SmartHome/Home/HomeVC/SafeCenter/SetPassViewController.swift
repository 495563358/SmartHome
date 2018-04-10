//
//  SetPassViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/6/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SetPassViewController: UIViewController,UITextFieldDelegate {
    let scalew = ScreenWidth / 320
    let scaleh = ScreenHeight / 568
    var text1 = UITextField()
    var text = UITextField()
    var text2 = UITextField()
    var bool = true
    typealias ReBoolk = ()->()
    var fan:ReBoolk?
    func fanhui(_ sboolk:@escaping ReBoolk)->Void{
        fan = sboolk
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("修改登录密码", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("提交", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SetPassViewController.handleRightItem(_:)))
        
        let vcfirs = UIView(frame: CGRect(x: 0,y: 10*scaleh,width: ScreenWidth,height: 40*scaleh))
        vcfirs.backgroundColor = UIColor.white
        
//        let lab = UILabel(frame: CGRectMake(5*scalew,0,80*scalew,vcfirs.frame.size.height))
//        lab.font = UIFont.systemFontOfSize(14.0)
//        lab.textAlignment = NSTextAlignment.Center
//        lab.adjustsFontSizeToFitWidth=true
//        lab.minimumScaleFactor=0.6
//        lab.text = "输入原始密码"
//        lab.backgroundColor = UIColor.clearColor()
//        vcfirs.addSubview(lab)
        
        text = UITextField(frame:CGRect(x: 5*scalew,y: 0,width: vcfirs.frame.width,height: vcfirs.frame.size.height))
        text.borderStyle = UITextBorderStyle.none
        text.textAlignment = .left
        text.clearButtonMode=UITextFieldViewMode.unlessEditing
        text.delegate = self
        text.keyboardType = UIKeyboardType.default
        text.isSecureTextEntry=true
        text.placeholder=NSLocalizedString("输入原始密码", comment: "")
        text.font = UIFont.systemFont(ofSize: 14.0)
        vcfirs.addSubview(text)
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        
        let vcsecond = UIView(frame: CGRect(x: 0,y: 25*scaleh+vcfirs.frame.size.height,width: ScreenWidth,height: 40*scaleh))
        vcsecond.backgroundColor = UIColor.white
        
//        let lab1 = UILabel(frame: CGRectMake(5*scalew,0,80*scalew,vcfirs.frame.size.height))
//        lab1.font = UIFont.systemFontOfSize(14.0)
//        lab1.textAlignment = NSTextAlignment.Center
//        lab1.adjustsFontSizeToFitWidth=true
//        lab1.minimumScaleFactor=0.6
//        lab1.text = "请输入密码"
//        lab1.backgroundColor = UIColor.clearColor()
//        vcsecond.addSubview(lab1)
        
        text1 = UITextField(frame:CGRect(x: 5*scalew,y: 0,width: vcfirs.frame.width,height: vcfirs.frame.size.height))
        text1.borderStyle = UITextBorderStyle.none
        text1.textAlignment = .left
        text1.clearButtonMode=UITextFieldViewMode.unlessEditing
        text1.keyboardType = UIKeyboardType.default
        text1.delegate = self
        text1.isSecureTextEntry=true
        text1.placeholder=NSLocalizedString("请输入密码", comment: "")
        text1.font = UIFont.systemFont(ofSize: 14.0)
        vcsecond.addSubview(text1)
        
        let vcThree = UIView(frame: CGRect(x: 0,y: 40*scaleh+vcfirs.frame.size.height+vcsecond.frame.height,width: ScreenWidth,height: 40*scaleh))
        vcThree.backgroundColor = UIColor.white
        
//        let lab2 = UILabel(frame: CGRectMake(5*scalew,0,80*scalew,vcThree.frame.size.height))
//        lab2.font = UIFont.systemFontOfSize(14.0)
//        lab2.textAlignment = NSTextAlignment.Center
//        lab2.adjustsFontSizeToFitWidth=true
//        lab2.minimumScaleFactor=0.6
//        lab2.text = "再次输入密码"
//        lab2.backgroundColor = UIColor.clearColor()
//        vcThree.addSubview(lab2)
        
        text2 = UITextField(frame:CGRect(x: 5*scalew,y: 0,width: vcThree.frame.width,height: vcThree.frame.size.height))
        text2.borderStyle = UITextBorderStyle.none
        text2.textAlignment = .left
        text2.clearButtonMode=UITextFieldViewMode.unlessEditing
        text2.keyboardType = UIKeyboardType.default
        text2.delegate = self
        text2.isSecureTextEntry=true
        text2.placeholder=NSLocalizedString("再次输入密码", comment: "")
        text2.font = UIFont.systemFont(ofSize: 14.0)
        vcThree.addSubview(text2)
        
        
        self.view.addSubview(vcfirs)
        self.view.addSubview(vcsecond)
        self.view.addSubview(vcThree)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        //收起键盘
        textField.resignFirstResponder()
        //打印出文本框中的值
        return true;
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
    }
    @objc func handleRightItem(_ barButton: UIBarButtonItem) {
        if text.text == "" || text1.text == "" || text2.text == ""{
            showMsg(msg: NSLocalizedString("请输入正确的密码", comment: ""))
            return
        }
        if text2.text != text1.text{
            showMsg(msg: NSLocalizedString("两次密码不一致", comment: ""))
            return
        }
        if text2.text!.characters.count < 6 || text2.text!.count > 18{
            showMsg(msg: NSLocalizedString("密码格式不正确", comment: ""))
            return
        }
        let dic = ["oldUserPwd":text.text!,"userPwd":text1.text!,"userPhone":BaseHttpService.getUserPhoneType()]
        print(dic)
        BaseHttpService.sendRequestAccess(setPwd, parameters: dic as NSDictionary) { (arr) -> () in
            self.navigationController?.popViewController(animated: true)

        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
