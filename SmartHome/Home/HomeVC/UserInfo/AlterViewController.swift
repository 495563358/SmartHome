//
//  AlterViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/30.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class AlterViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    var alteText:String!
    var textName:String?
    //声明一个闭包
    var myClosure:callbackfunc?
    //红外数据 地址
    var addr:String?
    //门锁
    var lockuser:LockUser?
    //按钮编号
    var inv = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        let itm = UIBarButtonItem(title: NSLocalizedString("提交", comment:""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AlterViewController.selectRightAction(_:)))
        self.navigationItem.rightBarButtonItem = itm
        self.navigationItem.title = alteText
        textField.clearButtonMode = UITextFieldViewMode.always
        textField.text = textName;
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
    }
    //提交数据
    @objc func selectRightAction(_ butt:UIButton)->Void{
        if textField.text == ""{
            showMsg(msg: "请输入")
            return
        }
        if self.alteText == NSLocalizedString("修改姓名", comment: ""){
            let parameters=["userName":textField.text!,"userPhone":BaseHttpService.getUserPhoneType()]
            BaseHttpService.sendRequestAccess(GetUserName, parameters:parameters as NSDictionary) {[unowned self] (response) -> () in
                print(response)
                self.navigationController?.popViewController(animated: true)
                self.myClosure?(self.textField.text!)
            }
        }else if self.alteText == NSLocalizedString("修改签名", comment: ""){
            let parameters=["signature":textField.text!,"userPhone":BaseHttpService.getUserPhoneType()]
            BaseHttpService.sendRequestAccess(GetUserSignature, parameters:parameters as NSDictionary) {[unowned self] (response) -> () in
                print(response)
                self.navigationController?.popViewController(animated: true)
                self.myClosure?(self.textField.text!)
            }
            
        }else if self.alteText == NSLocalizedString("添加红外线", comment: ""){
            var i = self.inv
            i = i+1
            let dic = ["deviceAddress":self.addr!,
                "infraredButtonsName":textField.text!,
                "infraredButtonsValuess":String(i)]
            print(dic)
            BaseHttpService.sendRequestAccess(Add_addinfraredbuttonses, parameters:dic as NSDictionary) { [unowned self](response) -> () in
                print(response)
                self.navigationController?.popViewController(animated: true)
                self.myClosure?(self.textField.text!)
            }
        //红外线添加接口
        }else if self.alteText == NSLocalizedString("修改姓名 ", comment: ""){
            print("成员修改")
            let dic = ["fingerprintMembersId":self.lockuser!.userID,"membersName":textField.text!]
            BaseHttpService.sendRequestAccess(updateFingerprintName, parameters: dic as NSDictionary, success: { (arr) -> () in
                self.navigationController?.popViewController(animated: true)
                self.myClosure?(self.textField.text!)
            })
        }
        

    }
    //设置输入长度
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.characters.count > 10 {
         return false
        }
        
        return true
    }
    //键盘消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //块
    typealias callbackfunc = (String)->()
  
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针

    func completeBlock(_ chName:callbackfunc)->Void{
        
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
