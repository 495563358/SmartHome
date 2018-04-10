//
//  ApprovalViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/10/10.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class ApprovalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var iphone: UITextField!
    @IBOutlet weak var approval: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var yesButt: UIButton!
    @IBOutlet weak var noButt: UIButton!
    
    var buttBool:String = "2"
    
    var userDic:[String] = []
    
    var alert:MyAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("授权用户", comment: "")
        alert = MyAlert(title:"请输入密码",message:"授权后对方将显示您的房间信息",delegate:self,cancelButtonTitle:"取消",otherButtonTitles:NSLocalizedString("确认", comment: ""))
        
        // Do any additional setup after loading the view.
        approval.layer.cornerRadius = 5
        approval.layer.masksToBounds = true
        approval.backgroundColor = mainColor
        tableview.delegate = self
        tableview.dataSource = self
        iphone.keyboardType = UIKeyboardType.numberPad
        
        self.tableview.tableFooterView = UIView()
        
        self.yesButt.addTarget(self, action: #selector(ApprovalViewController.Operable(_:)), for: .touchUpInside)
        self.noButt.addTarget(self, action: #selector(ApprovalViewController.NotOperable(_:)), for: .touchUpInside)
        
        approval.addTarget(self, action: #selector(ApprovalViewController.approvalUp), for: .touchUpInside)
        
        BaseHttpService.sendRequestAccess(gainAuthorizeList, parameters: [:]) {[unowned self] (any) -> () in
            print(any)
            if any.count == 0{
                return
            }
            for var i in 0...any.count-1{
                self.userDic.append(((any as! NSArray)[i] as! NSDictionary)["userPhone"] as! String)
            }
            self.tableview.reloadData()
        }
        
        let backBtn = UIButton.init(frame: CGRect(x: 0, y: 35, width: 40, height: 40))
        backBtn.setImage(UIImage(named: "fanhui(b)"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(ApprovalViewController.backClick), for: UIControlEvents.touchUpInside)
        
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func Operable(_ butt:UIButton){
        print("可操作")
        buttBool = "1"
        self.yesButt.setImage(UIImage(named: "传感器选择"), for: UIControlState())
        self.noButt.setImage(UIImage(named: "传感器不选择"), for: UIControlState())
    }
    @objc func NotOperable(_ butt:UIButton){
        print("不可操作")
        buttBool = "2"
        self.yesButt.setImage(UIImage(named: "传感器不选择"), for: UIControlState())
        self.noButt.setImage(UIImage(named: "传感器选择"), for: UIControlState())
    }
 
    
    @objc func approvalUp(){
        if self.iphone.text == ""{
            showMsg(msg: NSLocalizedString("请输入手机号", comment: ""))
            return
        }
//        if self.iphone.text!.characters.count != 11{
//            showMsg(NSLocalizedString("请输入正确的手机号", comment: ""))
//            return
//        }
        if self.iphone.text == BaseHttpService.getUserPhoneType(){
            showMsg(msg: NSLocalizedString("不能给自己授权", comment: ""))
            return
        }
        self.view.endEditing(true)
        
//        let dic = ["userPhone":self.iphone.text!,
//                    "versionType":"1"]
//       // alert.dismissWithClickedButtonIndex(0, animated: true)
//        Alamofire.request(.POST, authorizeSendMsg, parameters: dic, encoding: .URL).responseJSON { (response) -> Void in
//            print(response)
//            
//            if response.result.isFailure {
//            
//            }else{
//                if (response.result.value!as![String:AnyObject]).keys.contains("statusCode"){
//                    print("服务器返回异常数据")
//                    return;
//                }
//                
//                if response.result.value!["success"] as! Bool == true{
//
//                    
//                    self.alert!.alertViewStyle = UIAlertViewStyle.PlainTextInput
//                    
//                    self.alert!.show()
//                }else{
//                    showMsg(response.result.value!["message"]as!String)
//                }
//            }
//        }
        
        //改-----------点击授权之后 authorize
        
        let dic = ["userPhone":self.iphone.text!,
            "accountOperationType":buttBool]
        BaseHttpService.sendRequestAccess(authorize, parameters: dic as NSDictionary, success: { [unowned self] (any) -> () in
            let dic = any as! Dictionary<String, String>
            if dic.count == 1{
                if dic["result"] == "账户已被其他账户授权"{
                    let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                    popView.parentView = UIWindow.visibleViewController().view
                    popView.setText(NSLocalizedString("账户已被其他账户授权", comment: ""))
                    popView.parentView .addSubview(popView)
                }else if dic["result"] == "授权成功"{
                    let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                    popView.parentView = UIWindow.visibleViewController().view
                    popView.setText(NSLocalizedString("授权成功", comment: ""))
                    popView.parentView .addSubview(popView)
                    BaseHttpService.sendRequestAccess(gainAuthorizeList, parameters: [:]) {[unowned self] (any) -> () in
                        print(any)
                        if any.count == 0{
                            return
                        }
                        self.userDic = []
                        
                        for var i in 0...any.count-1 {
                            self.userDic.append(((any as! NSArray)[i] as!NSDictionary)["userPhone"] as! String)
                        }
                        self.tableview.reloadData()
                    }
                    self.view.endEditing(true)
                }
            }
        })

    }
    
    
    func alertView(_ alertView:UIAlertView, clickedButtonAt buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
            self.alert!.dismiss()
            self.view.endEditing(true)
        }
        else
        {
            let str = alertView.textField(at: 0)
            if str?.text == ""{
                showMsg(msg: "请输入密码")
                return
            }
            print(str?.text)
           
            
            let dic = ["userPhone":self.iphone.text!,
                "verifyCode":str!.text!,
            "accountOperationType":buttBool]
            BaseHttpService.sendRequestAccess(startAuthorize, parameters: dic as NSDictionary, success: { [unowned self] (any) -> () in
                let dic = any as! Dictionary<String, String>
                if dic.count == 1{
                    if dic["result"] == "验证码错误" {
//                        let alert = UIAlertView(title:"请输入正确的验证码",message:"",delegate:self,cancelButtonTitle:"取消",otherButtonTitles:"确认")
//                        
//                        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
//                        alert.show()
                        let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                        popView.parentView = UIWindow.visibleViewController().view
                        popView.setText("验证码错误")
                        popView.parentView .addSubview(popView)
                    }else if dic["result"] == "账户已被其他账户授权"{
                        let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                        popView.parentView = UIWindow.visibleViewController().view
                        popView.setText("账户已被其他账户授权")
                        popView.parentView .addSubview(popView)
                    }else if dic["result"] == "授权成功"{
                        //self.didSelectedEnter()
                        self.alert!.dismiss()
                        BaseHttpService.sendRequestAccess(gainAuthorizeList, parameters: [:]) {[unowned self] (any) -> () in
                            print(any)
                            if any.count == 0{
                                return
                            }
                            self.userDic = []
                            for var i in 0...any.count-1 {
                                self.userDic.append(((any as! NSArray)[i] as!NSDictionary)["userPhone"] as! String)
                            }
                            self.tableview.reloadData()
                        }
                        self.view.endEditing(true)
                    }
                }
                
            })
            
        }
    }

    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            // cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.userDic[indexPath.row]
        cell?.textLabel?.textColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1.0)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("授权列表", comment: "")
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return NSLocalizedString("解绑", comment: "")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete && userDic.count > 0
        {
            let dic = ["userPhone":userDic[indexPath.row]]
            BaseHttpService.sendRequestAccess(primaryAccountRemoveBelowAccount, parameters: dic as NSDictionary, success: { [unowned self](any) -> () in
                let row = indexPath.row
                self.userDic.remove(at: row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            })

        }
        
        
    }
    
    //键盘消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
