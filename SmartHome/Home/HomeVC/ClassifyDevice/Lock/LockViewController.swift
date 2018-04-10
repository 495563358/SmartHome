//
//  LockViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/11/9.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LockViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    
    var equip:Equip?
    //var lockUser:LockUser? //门锁成员
    //var lockUserArr = [LockUser]() //保存门锁成员

    let scalew = ScreenWidth / 320
    let scaleh = ScreenHeight / 568
    //view1
    var Electric = UILabel()
    var GeiTui = UILabel()
    var ElectricStat = UILabel()
    var ElectricStatS = UILabel()
    var GeiTuiStat = UIButton()
    var StatLock = UILabel()
    //view 2
    var kg = UIButton()
    
    var keyboard:ZenKeyboard?
    
    //view3
    var LpassM = UIButton()
    var SpassM = UIButton()
    
    //获取推送
    var getuiStat1 = "0"
    
    //获取门锁成员列表
    var LockName = NSArray()
    var LockImg = NSArray()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.gray
        self.navigationItem.title = self.equip?.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        //视图1
        let view1 = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: ScreenHeight/8))
        view1.backgroundColor = UIColor.white
        
        self.Electric.frame = CGRect(x: 20*scalew, y: 0, width: 80*scalew, height: view1.hight/2)
        self.StatLock.frame = CGRect(x: self.view.width-60*scalew, y: 0, width: 60*scalew, height: view1.hight/2)
        self.GeiTui.frame = CGRect(x: 20*scalew, y: view1.hight/2, width: 80*scalew, height: view1.hight/2)
        self.ElectricStat.frame = CGRect(x: 100*scalew, y: 4*scaleh, width: 60*scalew, height: view1.hight/2-4*scaleh)
        self.ElectricStatS.frame = CGRect(x: 160*scalew, y: 0, width: 80*scalew, height: view1.hight/2)
        self.GeiTuiStat.frame = CGRect(x: 100*scalew, y: view1.hight/2, width: view1.hight/2, height: view1.hight/2)
        
        self.Electric.text = NSLocalizedString("电量状态", comment: "")
        self.Electric.font = UIFont(name: "Arial", size: 18*scalew)
        self.Electric.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
       // self.Electric.backgroundColor = UIColor.redColor()
        
        self.ElectricStat.text = "STATUS"
        self.ElectricStat.font = UIFont(name: "Arial", size: 13*scalew)
        self.ElectricStat.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
       // self.ElectricStat.backgroundColor = UIColor.redColor()
        
        self.GeiTui.text = NSLocalizedString("推送设置", comment: "")
        self.GeiTui.font = UIFont(name: "Arial", size: 18*scalew)
        self.GeiTui.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
        //self.GeiTui.backgroundColor = UIColor.redColor()
        
        self.ElectricStatS.text = NSLocalizedString("正常", comment: "")
        self.ElectricStatS.font = UIFont(name: "Arial", size: 18*scalew)
        self.ElectricStatS.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
        // self.ElectricStatS.backgroundColor = UIColor.redColor()
        
        self.StatLock.text = NSLocalizedString("未反锁", comment: "")
        self.StatLock.font = UIFont(name: "Arial", size: 18*scalew)
        self.StatLock.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
        // self.ElectricStatS.backgroundColor = UIColor.redColor()
        
        self.GeiTuiStat.setImage(UIImage(named: "开启推送"), for: UIControlState())
        self.GeiTuiStat.addTarget(self, action: #selector(LockViewController.GeiTuiStatButt(_:)), for: UIControlEvents.touchUpInside)
        
        view1.addSubview(self.Electric)
        view1.addSubview(self.ElectricStat)
        view1.addSubview(self.GeiTui)
        view1.addSubview(self.ElectricStatS)
        view1.addSubview(self.GeiTuiStat)
        view1.addSubview(self.StatLock)
        
        let view2 = UIView(frame: CGRect(x: 0,y: view1.hight+1*scaleh,width: ScreenWidth,height: ScreenHeight/8*3))
        view2.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.kg.frame = CGRect(x: (view2.width-(view2.hight-20*scaleh))/2, y: 10*scaleh, width: view2.hight-20*scaleh, height: view2.hight-20*scaleh)
       // self.kg.backgroundColor = UIColor.redColor()
        self.kg.setImage(UIImage(named: "关锁"), for: UIControlState())
        self.kg.addTarget(self, action: #selector(LockViewController.kgButt(_:)), for: UIControlEvents.touchUpInside)
        
        
        view2.addSubview(self.kg)
        
        let view3 = UIView(frame: CGRect(x: 0,y: view1.hight+2*scaleh+view2.hight,width: ScreenWidth,height: ScreenHeight/8-20*scaleh))
        view3.backgroundColor = UIColor.white
        
        self.LpassM.frame = CGRect(x: 10*scalew, y: 5*scaleh, width: view3.width/2-20*scalew, height: view3.hight-10*scaleh)
        self.SpassM.frame = CGRect(x: view3.width/2+10*scalew, y: 5*scaleh, width: view3.width/2-20*scalew, height: view3.hight-10*scaleh)
        
        self.LpassM.backgroundColor = UIColor(red: 54/255, green: 176/255, blue: 202/255, alpha: 1.0)
        self.SpassM.backgroundColor = UIColor(red: 54/255, green: 176/255, blue: 202/255, alpha: 1.0)
        
        self.LpassM.setTitle(NSLocalizedString("长期密码管理", comment: ""), for: UIControlState())
        self.SpassM.setTitle(NSLocalizedString("临时密码管理", comment: ""), for: UIControlState())
        
        self.LpassM.addTarget(self, action: #selector(LockViewController.LpassMButt(_:)), for: UIControlEvents.touchUpInside)
        self.SpassM.addTarget(self, action: #selector(LockViewController.SpassMButt(_:)), for: UIControlEvents.touchUpInside)
        
        self.LpassM.setTitleColor(UIColor.white, for: UIControlState())
        self.SpassM.setTitleColor(UIColor.white, for: UIControlState())
        
        self.LpassM.titleLabel?.font = UIFont(name: "Arial", size: 13*scalew)
        self.SpassM.titleLabel?.font = UIFont(name: "Arial", size: 13*scalew)
        self.LpassM.layer.cornerRadius = 10.0
        
        
        self.SpassM.layer.cornerRadius = 10.0
        
        view3.addSubview(self.LpassM)
        view3.addSubview(self.SpassM)
        
        
        
        self.tableView.frame = CGRect(x: 0, y: view1.hight+3*scaleh+view2.hight+view3.hight, width: ScreenWidth, height: ScreenHeight-view1.hight+3*scalew+view2.hight+view3.hight)
        
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        self.view.addSubview(view3)
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactsTableViewCell")
        
        
       
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        getBaseHttp()
    }
    func getBaseHttp(){
        let dic = ["lockAddress":self.equip!.equipID]

        BaseHttpService.sendRequestAccess(gainParams, parameters: dic as NSDictionary) { /*[unowned self]*/(arr) -> () in
            print(arr)
            print(arr["pushSet"])

            self.getuiStat1 = arr["pushSet"] as! String
            if self.getuiStat1 == "0"{
                self.GeiTuiStat.setImage(UIImage(named: "开启推送"), for: UIControlState())
                self.GeiTui.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
            }else if self.getuiStat1 == "1"{
                self.GeiTuiStat.setImage(UIImage(named: "关闭推送"), for: UIControlState())
                self.GeiTui.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
            }
            
            if arr["whetherLocked"] as! String == "0"{
                self.StatLock.text = NSLocalizedString("未反锁", comment: "")
                self.StatLock.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
            }else if arr["whetherLocked"] as! String == "1"{
                self.StatLock.text = NSLocalizedString("已反锁", comment: "")
                self.StatLock.textColor = UIColor.red
            }
            
            if arr["electric"] as! String == "0"{
//                self.Electric.textColor = UIColor.redColor()
//                self.ElectricStat.textColor = UIColor.redColor()
                self.ElectricStatS.text = NSLocalizedString("低电量", comment: "")
                self.ElectricStatS.textColor = UIColor.red
            }
        }
        
 
    }
    
    @objc func SpassMButt(_ butt:UIButton){
        let vc =  LockTemViewController()
        vc.equip = self.equip
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func LpassMButt(_ butt:UIButton){
        let vc =  SLockViewController()
        vc.equip = self.equip
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func GeiTuiStatButt(_ butt:UIButton){
        
        if self.getuiStat1 == "1"{
            self.GeiTuiStat.setImage(UIImage(named: "开启推送"), for: UIControlState())
            self.GeiTui.textColor = UIColor(red: 24/255, green: 211/255, blue: 160/255, alpha: 1.0)
            self.getuiStat1 = "0"
            let dic = ["lockAddress":self.equip!.equipID,"pushSet":self.getuiStat1]
            BaseHttpService.sendRequestAccess(pushSet, parameters: dic as NSDictionary, success: { (arr) -> () in
                let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                popView.parentView = UIWindow.visibleViewController().view
                popView.setText(NSLocalizedString("设置成功", comment: ""))
                popView.parentView.addSubview(popView)
            })
            
        }else if self.getuiStat1 == "0"{
            self.GeiTuiStat.setImage(UIImage(named: "关闭推送"), for: UIControlState())
            self.GeiTui.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
            self.getuiStat1 = "1"
            let dic = ["lockAddress":self.equip!.equipID,"pushSet":self.getuiStat1]
            BaseHttpService.sendRequestAccess(pushSet, parameters: dic as NSDictionary, success: { (arr) -> () in
                let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                popView.parentView = UIWindow.visibleViewController().view
                popView.setText(NSLocalizedString("设置成功", comment: ""))
                popView.parentView.addSubview(popView)
            })
        }
        
    }
    //开锁
    @objc func kgButt(_ butt:UIButton){
        let dic = ["lockAddress":self.equip!.equipID]
        BaseHttpService.sendRequestAccess(verifyLock, parameters: dic as NSDictionary) { (arr) -> () in
            let alertView = UIAlertView()
            alertView.alertViewStyle =  UIAlertViewStyle.secureTextInput
            alertView.delegate = self
            alertView.title = NSLocalizedString("密码", comment: "")
            alertView.message = NSLocalizedString("请输入密码(4-16位数字)", comment: "")
            alertView.addButton(withTitle: NSLocalizedString("取消", comment: ""))
            alertView.addButton(withTitle: NSLocalizedString("好的",comment:""))
            
            self.keyboard = ZenKeyboard(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width/320*216))
            //alertView.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.NumberPad
            self.keyboard?.textField = alertView.textField(at: 0)
            alertView.show()
        }
        
    }
    //自定键盘密码事件
    func textFieldDidChange(_ textField:UITextField){
        print(textField.text)
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1{
            print(alertView.textField(at: 0)?.text)
                    let dic = ["lockAddress":self.equip!.equipID,"lockPwd":alertView.textField(at: 0)!.text!]
            BaseHttpService.sendRequestAccess(lockControl, parameters: dic as NSDictionary) { (arr) -> () in
                        let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                        popView.parentView = UIWindow.visibleViewController().view
                        popView.setText(NSLocalizedString("操作成功", comment: ""))
                        popView.parentView.addSubview(popView)
                    }
        }else{
            print("取消")
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
//        
//        if (cell == nil){
//            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
//        }
//        cell?.textLabel?.text = "aaaa"
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as! ContactsTableViewCell
        cell.equip = self.equip
        cell.getHttp()
        return cell
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
