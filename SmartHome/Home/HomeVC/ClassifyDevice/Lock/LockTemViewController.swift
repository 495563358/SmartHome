//
//  LockTemViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/11/10.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit


class LockTemViewController: UIViewController,UITextFieldDelegate, KMDatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    var tableView = UITableView()
    var equip:Equip?
    var newDtae = Date()//开始时间保存
    var newDtae1 = Date()//结束时间保存
    

    
    var rect = CGRect(x: 0.0, y: UIScreen.main.bounds.height - 280.0, width: UIScreen.main.bounds.width, height: 216.0)
    var datePicker:KMDatePicker?
    
    var arr = ["","","1","",""]
    var arrI = 0
    
    var butArr = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = NSLocalizedString("临时密码管理", comment: "")
        
        self.tableView.register(UINib(nibName: "LockTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "LockTimeTableViewCell")
        self.tableView.register(UINib(nibName: "LockTimernum", bundle: nil), forCellReuseIdentifier: "LockTimernum")
        self.tableView.register(UINib(nibName: "LockPasswordTableViewCell", bundle: nil), forCellReuseIdentifier: "LockPasswordTableViewCell")
        self.tableView.register(UINib(nibName: "locktiTableViewCell", bundle: nil), forCellReuseIdentifier: "locktiTableViewCell")
        
        
        let itm = UIBarButtonItem(title: NSLocalizedString("删除", comment:""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(LockTemViewController.selectRightAction(_:)))
        self.navigationItem.rightBarButtonItem = itm
        
        
     
        
        self.tableView.frame = UIScreen.main.bounds
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
        
        self.view.addSubview(self.tableView)
        
        datePicker = KMDatePicker.init(frame: rect, delegate: self, datePickerStyle: KMDatePickerStyle.yearMonthDayHourMinute)
        self.view.addSubview(datePicker!)
        datePicker?.isHidden = true
        
        GetBaseHttp()
    }
    
    func GetBaseHttp(){
        let dic = ["lockAddress":self.equip!.equipID,"lockType":"65535"]
        BaseHttpService.sendRequestAccess(longTermPassList, parameters: dic as NSDictionary) {[unowned self] (arr) -> () in
            print(arr)
            let info = (arr as! NSArray)[0] as! NSDictionary
            self.arr[0] = info["startTime"] as! String
            self.arr[1] = info["endTime"] as! String
            self.arr[3] = (info["lockPwd"] as! String).aesDecrypt()
            self.arr[2] = info["lockOfTimes"] as! String
            self.tableView.reloadData()
        }
    }
    
    @objc func selectRightAction(_ butt:UIButton)->Void{
        //删除
        let alertView = UIAlertView()
        alertView.alertViewStyle =  UIAlertViewStyle.secureTextInput
        alertView.delegate = self
        alertView.tag = 0;
        alertView.title = NSLocalizedString("密码", comment: "")
        alertView.message = NSLocalizedString("请输入管理员密码", comment: "")
        alertView.addButton(withTitle: NSLocalizedString("取消", comment: ""))
        alertView.addButton(withTitle: NSLocalizedString("好的",comment:""))
        alertView.textField(at: 0)?.keyboardType = UIKeyboardType.numberPad
        alertView.show()

    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 0{
            if buttonIndex == 1{
                print(alertView.textField(at: 0)?.text)
                let dic = ["lockAddress":self.equip!.equipID,"adminPwd":alertView.textField(at: 0)!.text!]
                BaseHttpService.sendRequestAccess(lockPwdDelete, parameters: dic as NSDictionary) { (arr) -> () in
                    let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                    popView.parentView = UIWindow.visibleViewController().view
                    popView.setText(NSLocalizedString("操作成功", comment: ""))
                    popView.parentView.addSubview(popView)
                }
            }else if buttonIndex == 1{
                print("取消")
            }
        }else if alertView.tag == 1{
            //提交成功
            self.navigationController?.popViewController(animated: true)
        }

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LockTimeTableViewCell", for: indexPath) as! LockTimeTableViewCell
            cell.timeleab.text = self.arr[indexPath.row]
            
            if self.arr[indexPath.row] != ""{
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                newDtae = dateFormatter.date(from: self.arr[indexPath.row])!
                
                print("获取开始时间-",newDtae)
            }

            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LockTimeTableViewCell", for: indexPath) as! LockTimeTableViewCell
            cell.headleab.text = NSLocalizedString("结束时间:", comment: "")
            cell.timeleab.text = self.arr[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if self.arr[indexPath.row] != ""{
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                newDtae1 = dateFormatter.date(from: self.arr[indexPath.row])!
                
                print("获取结束时间-",newDtae1)
            }
            
            return cell
        }else if indexPath.row == 2{

            let cell = tableView.dequeueReusableCell(withIdentifier: "LockTimernum", for: indexPath) as! LockTimernum
            cell.startTimer.addTarget(self, action: #selector(LockTemViewController.cellstatButt(_:)) , for: UIControlEvents.touchUpInside)
            cell.startTimer.tag = 0
            self.butArr.append(cell.startTimer)
            
            cell.stopTimer.addTarget(self, action: #selector(LockTemViewController.cellstatButt(_:)) , for: UIControlEvents.touchUpInside)
            cell.stopTimer.tag = 1
            self.butArr.append(cell.stopTimer)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if self.arr[indexPath.row] == "1"{
                
                cell.startTimer.setImage(UIImage(named: "传感器选择"), for: UIControlState())
                cell.stopTimer.setImage(UIImage(named: "传感器不选择"), for: UIControlState())
                
            }else if self.arr[indexPath.row] == "255"{
                
                cell.startTimer.setImage(UIImage(named: "传感器不选择"), for: UIControlState())
                cell.stopTimer.setImage(UIImage(named: "传感器选择"), for: UIControlState())
            }
            return cell
        }else if indexPath.row == 3{
           let cell = tableView.dequeueReusableCell(withIdentifier: "LockPasswordTableViewCell", for: indexPath) as! LockPasswordTableViewCell
            cell.passlabe.text = NSLocalizedString("临时密码:", comment: "")
            cell.passText.text = self.arr[indexPath.row]
            cell.passText.isSecureTextEntry = true
            cell.passText.delegate = self
            cell.passText.tag = 3
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LockPasswordTableViewCell", for: indexPath) as! LockPasswordTableViewCell
            cell.passText.delegate = self
            cell.passText.isSecureTextEntry=true
            cell.passText.tag = 4
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "locktiTableViewCell", for: indexPath) as! locktiTableViewCell
            cell.OKbutt.layer.cornerRadius = 10.0
            cell.OKbutt.backgroundColor = UIColor(red: 54/255, green: 176/255, blue: 202/255, alpha: 1.0)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.OKbutt.addTarget(self, action: #selector(LockTemViewController.SubmitButt(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }

        
    }
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        print(textField.tag)
        if textField.tag == 3{

            self.arr[textField.tag] = textField.text!
        }else if textField.tag == 4{

            self.arr[textField.tag] = textField.text!
        }
        datePicker!.isHidden = true
    }
    @objc func SubmitButt(_ butt:UIButton){
        self.view.endEditing(true)
        datePicker!.isHidden = true
        if self.arr[0] == "" || self.arr[1] == ""{
            let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
            popView.parentView = UIWindow.visibleViewController().view
            popView.setText(NSLocalizedString("请选择时间", comment: ""))
            popView.parentView.addSubview(popView)
            return
        }
        if self.arr[3] == "" || self.arr[4] == "" {
            let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
            popView.parentView = UIWindow.visibleViewController().view
            popView.setText(NSLocalizedString("请输入密码", comment: ""))
            popView.parentView.addSubview(popView)
            return
        }
        if self.arr[3].characters.count<4||self.arr[3].characters.count>16||self.arr[4].characters.count<4||self.arr[4].characters.count>16{
            let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
            popView.parentView = UIWindow.visibleViewController().view
            popView.setText(NSLocalizedString("密码格式不对,必须为大于4位小于16位数字", comment: ""))
            popView.parentView.addSubview(popView)
            return
        }
        if newDtae1 != (Date() as NSDate).laterDate(newDtae1){
            //错误时间
            
            let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
            popView.parentView = UIWindow.visibleViewController().view
            popView.setText(NSLocalizedString(NSLocalizedString("结束时间必须大于当前时间", comment: ""), comment: ""))
            popView.parentView.addSubview(popView)
            return
        }
        let dic = ["lockAddress":self.equip!.equipID,"lockPwd":self.arr[3],"lockType":"65535","adminPwd":self.arr[4],"startTime":self.arr[0],"endTime":self.arr[1],"lockOfTimes":self.arr[2]]
        print(dic)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        datePicker!.isHidden = true
    }
    

    
    @objc func cellstatButt(_ butt:UIButton){
        if butt.tag == 0{

            self.arr[2] = "1"
            self.butArr[0].setImage(UIImage(named: "传感器选择"), for: UIControlState())
            self.butArr[1].setImage(UIImage(named: "传感器不选择"), for: UIControlState())
            
        }else if butt.tag == 1{
            self.arr[2] = "255"
            self.butArr[0].setImage(UIImage(named: "传感器不选择"), for: UIControlState())
            self.butArr[1].setImage(UIImage(named: "传感器选择"), for: UIControlState())
  
        }
        datePicker!.isHidden = true
        print(2)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击")
        
        if indexPath.row == 0 {
//            datePicker = nil
//            datePicker = KMDatePicker.init(frame: rect, delegate: self, datePickerStyle: KMDatePickerStyle.YearMonthDayHourMinute)
            datePicker?.timerName = NSLocalizedString("起始时间", comment: "")
            datePicker?.minLimitedDate = Date()
         //   self.view.addSubview(datePicker!)
            datePicker!.isHidden = false
            self.view.endEditing(true)
            self.arrI = 0

        }else if indexPath.row == 1{
//            datePicker = nil
//            datePicker = KMDatePicker.init(frame: rect, delegate: self, datePickerStyle: KMDatePickerStyle.YearMonthDayHourMinute)
            datePicker?.timerName = NSLocalizedString("结束时间", comment: "")
            
          //  self.view.addSubview(datePicker!)
            datePicker!.isHidden = false
            self.view.endEditing(true)
            self.arrI = 1
        }else /*if indexPath.row == 2*/{
            datePicker!.isHidden = true
            self.view.endEditing(true)
        }

        
    }


    
    func datePicker(_ datePicker: KMDatePicker!, didSelectDate datePickerDate: KMDatePickerDateModel!) {
        let str = "\(datePickerDate.year)-\(datePickerDate.month)-\(datePickerDate.day) \(datePickerDate.hour):\(datePickerDate.minute)"
//        let str = datePickerDate.year + "-" + datePickerDate.month + "-" + datePickerDate.day + " " + datePickerDate.hour + ":" + datePickerDate.minute
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if arrI == 0{
            self.arr[self.arrI] = ""
            newDtae = dateFormatter.date(from: str)!
            if newDtae  != (Date() as NSDate).laterDate(newDtae){
                print("不对")
            }
            print(newDtae)
            self.tableView.reloadData()
            self.datePicker!.isHidden = true
            self.arr[self.arrI] = str
        }else{
            print(newDtae)
            self.arr[self.arrI] = ""
            newDtae1 = dateFormatter.date(from: str)!
            if newDtae1  != (newDtae as NSDate).laterDate(newDtae1){
                
                print("时间不对")
                let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
                popView.parentView = UIWindow.visibleViewController().view
                popView.setText("结束时间小于开始时间,请重新选择")
                popView.parentView.addSubview(popView)
                return
            }
            self.arr[self.arrI] = str
            self.tableView.reloadData()
            self.datePicker!.isHidden = true
        }
        
        
        print(str)
        print(self.arrI)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
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
