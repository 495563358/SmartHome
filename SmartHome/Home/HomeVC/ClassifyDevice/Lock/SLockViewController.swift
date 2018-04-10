//
//  SLockViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/11/10.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SLockViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    var tableView = UITableView()
    var equip:Equip?
    
    var getPass = "" //获取修改后长期密码
    var getGlPass = "" //获取修改后的管理密码
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.gray
        self.navigationItem.title = NSLocalizedString("长期密码管理", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
       // let itm = UIBarButtonItem(title: NSLocalizedString("删除", comment:""), style: UIBarButtonItemStyle.Plain, target: self, action: "selectRightAction:")
       // self.navigationItem.rightBarButtonItem = itm
        
        self.tableView.frame = UIScreen.main.bounds
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.register(UINib(nibName: "LockPasswordTableViewCell", bundle: nil), forCellReuseIdentifier: "LockPasswordTableViewCell")
        self.tableView.register(UINib(nibName: "locktiTableViewCell", bundle: nil), forCellReuseIdentifier: "locktiTableViewCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        getBaseHttpPass()
    }
    
    //获取临时密码
    func getBaseHttpPass(){
        let dic = ["lockAddress":self.equip!.equipID,"lockType":"1"]
        BaseHttpService.sendRequestAccess(longTermPassList, parameters: dic as NSDictionary) {[unowned self] (arr) -> () in
            print(arr)
            let info = (arr as! NSArray)[0] as! NSDictionary
            print(info["lockPwd"])
            self.getPass = (info["lockPwd"] as! String).aesDecrypt()
            
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        print(textField.tag)
        if textField.tag == 0{
            self.getPass = textField.text!
        }else if textField.tag == 1{
            self.getGlPass = textField.text!
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LockPasswordTableViewCell", for: indexPath) as! LockPasswordTableViewCell
            cell.passlabe.text = NSLocalizedString("长期密码:", comment: "")
            cell.passText.delegate = self
            cell.passText.isSecureTextEntry=true
            cell.passText.text = self.getPass
            cell.passText.tag = 0
            cell.passText.tag = indexPath.row
            //cell.passText.secureTextEntry = !cell.passText.secureTextEntry
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell

        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LockPasswordTableViewCell", for: indexPath) as! LockPasswordTableViewCell
            cell.passlabe.text = NSLocalizedString("管理密码:", comment: "")
            cell.passText.delegate = self
            cell.passText.isSecureTextEntry=true
            cell.passText.tag = indexPath.row
            cell.passText.tag = 1
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "locktiTableViewCell", for: indexPath) as! locktiTableViewCell
            cell.OKbutt.layer.cornerRadius = 10.0
            cell.OKbutt.backgroundColor = UIColor(red: 54/255, green: 176/255, blue: 202/255, alpha: 1.0)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.OKbutt.addTarget(self, action: #selector(SLockViewController.SubmitButt(_:)), for: UIControlEvents.touchUpInside)
            
            return cell
        }
    }
    @objc func  SubmitButt(_ butt:UIButton){
        self.view.endEditing(true)
        if self.getGlPass == "" || self.getPass == "" {
            let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
            popView.parentView = UIWindow.visibleViewController().view
            popView.setText(NSLocalizedString("请输入密码", comment: ""))
            popView.parentView.addSubview(popView)
            return
        }
        if self.getGlPass.characters.count<4||self.getGlPass.characters.count>16||self.getPass.characters.count<4||self.getPass.characters.count>16{
            let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
            popView.parentView = UIWindow.visibleViewController().view
            popView.setText(NSLocalizedString("密码格式不对", comment: ""))
            popView.parentView.addSubview(popView)
            return
        }
        
        let dic = ["lockAddress":self.equip!.equipID,"lockPwd":self.getPass,"lockType":"1","adminPwd":self.getGlPass]
        BaseHttpService.sendRequestAccess(remotePasswordSet, parameters: dic as NSDictionary) { (arr) -> () in
//            let  popView = PopupView(frame: CGRectMake(100, ScreenHeight-200, 0, 0))
//            popView.ParentView = UIWindow.visibleViewController().view
//            popView.setText(NSLocalizedString("设置成功", comment: ""))
//            popView.ParentView.addSubview(popView)
            let alertView = UIAlertView(title: NSLocalizedString("设置成功", comment: ""), message: nil, delegate: self, cancelButtonTitle: NSLocalizedString("确定", comment: ""))
            alertView.tag = 1
            alertView.show()
        }
        
    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 1{
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
