//
//  EquipAddVC.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SetsenAddVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {
    var equip: Equip?
    var equipIndex :IndexPath?
    var NameText:String?//导航栏名
    
    var modelIdName = ""
    var deviceCodeIs = ""
    var deviceCodeName = ""
    var tableView:UITableView = UITableView.init(frame: UIScreen.main.bounds, style: .grouped)
    
    var isget = 0 //判断修改 还是添加 1:修改 0：添加

    var butArr = [UIButton]()
    
    var shotArr = [String]()

     var arr = [String]()
    fileprivate var compeletBlock: ((Equip,IndexPath)->())?
    
    func configCompeletBlock(_ compeletBlock: @escaping (_ equip: Equip,_ indexPath:IndexPath)->()) {
        self.compeletBlock = compeletBlock
    }
    
    
       var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        navigationItem.title = NameText
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SetsenAddVC.handleBack(_:)))
        
        self.tableView.register(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        self.tableView.register(UINib(nibName: "EquipConfigCell", bundle: nil), forCellReuseIdentifier: "equipconfigcell")
        self.tableView.register(UINib(nibName: "EquipImageCell", bundle: nil), forCellReuseIdentifier: "equipimagecell")
        self.tableView.register(UINib(nibName: "SenTimerTableViewCell", bundle: nil), forCellReuseIdentifier: "SenTimerTableViewCell")
        self.tableView.register(UINib(nibName: "SenChoiceTableViewCell", bundle: nil), forCellReuseIdentifier: "SenChoiceTableViewCell")
        
        let nextStep = UIButton.init(frame: CGRect(x: ScreenWidth/4, y: 50, width: ScreenWidth/2, height: 45))
        nextStep.backgroundColor = systemColor
        nextStep.layer.cornerRadius = 10
        nextStep.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStep.setTitle("保存", for: UIControlState())
        nextStep.addTarget(self, action: #selector(SetsenAddVC.handleRightItem(_:)), for: UIControlEvents.touchUpInside)
        
        let footerView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWidth,height:100))
        footerView.addSubview(nextStep)
        self.tableView.tableFooterView = footerView
        self.tableView.tableHeaderView = UIView(frame:CGRect(x:0,y:0,width:ScreenWidth,height:0.01))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionFooterHeight = 10
        self.tableView.sectionHeaderHeight = 0.1
        self.view.addSubview(self.tableView)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetsenAddVC.handleTap(_:)))
        tap.delegate = self
        self.tableView.addGestureRecognizer(tap)
        
        BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) { [unowned self](back) -> () in
              print(back)
           
            if(back.count <= 0)
            {return}
            for dic in back as![[String:String]]
            {
            print(dic )
                
                if dic["status"]! == "1"{
                    self.arr.append( NSLocalizedString("在线", comment: "") +  "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.characters.count)!-5, 5))))  "+dic["nickName"]! )
                }else{
                    self.arr.append(NSLocalizedString("离线", comment: "") + "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.characters.count)!-5, 5))))  "+dic["nickName"]! )
                }
                if self.equip?.hostDeviceCode == dic["deviceCode"]{
                    if dic["status"]! == "1"{
                        self.deviceCodeIs = NSLocalizedString("在线", comment: "") + "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.characters.count)!-5, 5))))  "+dic["nickName"]!
                    }else{
                        self.deviceCodeIs = NSLocalizedString("离线", comment: "") +  "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.characters.count)!-5, 5))))  "+dic["nickName"]!
                    }
                }
                
             self.shotArr.append(dic["deviceCode"]!)
            }
            print(self.arr)
            print(self.shotArr)
            if self.shotArr.count >= 1
            {
                if self.equip?.hostDeviceCode == "unload"{
                    self.equip?.hostDeviceCode = self.shotArr[0]
                    self.deviceCodeIs = self.arr[0]
                }
               
            }
            else
            {
               self.equip?.hostDeviceCode  = "load"
            }
            
            if self.arr.count >= 1
            {
                self.tableView.reloadData();
            }
       
        
          }
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        self.tableView.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleRightItem(_ barButton: UIBarButtonItem) {
       
  
    
        if self.equip!.name == ""
        {
            showMsg(msg: NSLocalizedString("名字不能为空", comment: ""))
            return
        }
        if self.equip!.num == ""
        {
            showMsg(msg: NSLocalizedString("情景不能为空", comment: ""))
            return
        }
        if self.equip!.hostDeviceCode == "load"
        {
            showMsg(msg: NSLocalizedString("请先扫描主机", comment: ""))
            return
        }
        if self.equip?.type == ""{
            showMsg(msg: "选择传感器")
            return 
        }

             //添加设备
        if self.isget == 0
        {
            let parameter = [
            // "roomCode":self.equip!.roomCode,//房间
            "deviceAddress":self.equip!.equipID,
            "nickName":self.equip!.name,//名称
            "ico":self.equip!.icon,//图片
            "deviceType":self.equip!.type,//433 315
            "deviceCode":self.equip!.hostDeviceCode,//主机
            "modelId":self.equip!.num,
            "patternType":"2",
            "pushContent":""]//绑定情景模式的ID
            print("\(parameter)")
            BaseHttpService.sendRequestAccess(addsensor, parameters:parameter as NSDictionary, success: { (data) -> () in
                //self.equip!.saveEquip()
                print("设备信息 \(data)")
                print(data["line"] as! String)
                self.equip?.equipID = data["line"] as! String
                self.equip!.saveEquip()
                
                BaseHttpService.sendRequestAccess(gainSensor, parameters: ["patternType":"2"]) {[unowned self] (data) -> () in
                    print(data)
                    
                    let i = data.count - 1
                    let dataDict = (data as! NSArray)[i] as! NSDictionary
                    let model = SensorModel.init(deviceCode: dataDict["deviceCode"] as! String, deviceAddress: dataDict["deviceAddress"] as! String, nickName: dataDict["nickName"] as! String, start1: dataDict["No.1"] as! String, start2: dataDict["No.2"] as! String, start3: dataDict["No.3"] as! String, deviceType: dataDict["deviceType"] as! String, securityType: dataDict["securityType"] as! String,sensorstate:"")
                    let secV = SensorVerification()
                    secV.model = model
                    self.navigationController?.pushViewController(secV, animated: true)
                }
            })
        }else {
           // updateSensorsPram
            let parameter = [
                "deviceAddress":self.equip!.equipID,
                "nickName":self.equip!.name,//名称
                "ico":self.equip!.icon,//图片
                "deviceType":self.equip!.type,//433 315
                "deviceCode":self.equip!.hostDeviceCode,//主机
                "modelId":self.equip!.num,
                "patternType":"2",
            "pushContent":""]//绑定情景模式的ID
            print("\(parameter)")
            BaseHttpService.sendRequestAccess(updateSensorsPram, parameters:parameter as NSDictionary, success: { (data) -> () in
                //self.equip!.saveEquip()
                print(data)
               
                self.equip!.saveEquip()
                //            for temp in self.navigationController!.viewControllers {
                //                print("-------");
                //                if temp.isKindOfClass(ClassifyHomeVC.classForCoder()) {
                //                    self.navigationController?.popToViewController(temp , animated: true)
                //                }/*else if temp.isKindOfClass(MineVC.classForCoder()){
                //                    self.navigationController?.popToViewController(temp , animated: true)
                //                }*/
                //            }
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      if  self.arr.count <= 1 || self.isget == 1
      {
        return 3
      }
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            switch indexPath.section {
//            case 0:
//                let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
//                cell.cellTitle.text = "设备类型"
//                return cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "equipnamecell", for: indexPath) as! EquipNameCell
                if self.equip?.name != ""{
                    cell.equipName.text = self.equip?.name
                }
                cell.complete = {[unowned self](name)in
                    print(name)

                    
                self.equip?.name = name!
                }
                cell.selectionStyle =  UITableViewCellSelectionStyle.none
                return cell
//            case 1:
//                let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
//                cell.cellTitleLabel.text = "设备图标"
//                cell.selectionStyle =  UITableViewCellSelectionStyle.None
//                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
                cell.cellTitle.text = NSLocalizedString("关联情景", comment: "")
                if self.modelIdName != ""{
                    cell.cellDetail.text = self.modelIdName
                    
                }
                else
                {
                    cell.cellDetail.text = NSLocalizedString("请选择需要触发的情景模式", comment: "")
                }
                
                cell.selectionStyle =  UITableViewCellSelectionStyle.none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
                cell.cellTitle.text = NSLocalizedString("选择主机:", comment: "")
                
//                if self.deviceCodeIs == "1"{
//                    cell.cellDetail.text = NSLocalizedString("在线", comment: "") + "  " +  "(\((self.equip!.hostDeviceCode as NSString).substringWithRange(NSMakeRange((self.equip!.hostDeviceCode.characters.count)-5, 5))))  "+self.deviceCodeName
//                }else if self.deviceCodeIs == "0"{
//                    cell.cellDetail.text = NSLocalizedString("离线", comment: "") + "  " +  "(\((self.equip!.hostDeviceCode as NSString).substringWithRange(NSMakeRange((self.equip!.hostDeviceCode.characters.count)-5, 5))))  "+self.deviceCodeName
//                }else{
//                    cell.cellDetail.text = NSLocalizedString("请选择主机", comment: "")
//                }
                cell.cellDetail.text = self.deviceCodeIs
                
                
                cell.selectionStyle =  UITableViewCellSelectionStyle.none
                return cell

            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenChoiceTableViewCell", for: indexPath) as! SenChoiceTableViewCell
                cell.startTimer.tag = 0
                cell.startTimer.addTarget(self, action: #selector(SetsenAddVC.CellTimerAdd(_:)), for: UIControlEvents.touchUpInside)
                self.butArr.append(cell.startTimer)
                
                cell.stopTimer.tag = 1
                cell.stopTimer.addTarget(self, action: #selector(SetsenAddVC.CellTimerAdd(_:)), for: UIControlEvents.touchUpInside)
                self.butArr.append(cell.stopTimer)
                
                if self.equip!.type == "315"
                {
                    cell.startTimer.setBackgroundImage(UIImage(named: "传感器选择"), for: UIControlState())
                    cell.stopTimer.setBackgroundImage(UIImage(named: "传感器不选择"), for: UIControlState())
                }
                else if self.equip!.type == "433"
                {
                    cell.stopTimer.setBackgroundImage(UIImage(named: "传感器选择"), for: UIControlState())
                    cell.startTimer.setBackgroundImage(UIImage(named: "传感器不选择"), for: UIControlState())
                }
                
                cell.selectionStyle =  UITableViewCellSelectionStyle.none
                return cell
//            case 5:
//                let cell = tableView.dequeueReusableCellWithIdentifier("SenChoiceTableViewCell", forIndexPath: indexPath) as! SenChoiceTableViewCell
//                cell.startTimer.tag = 4
//                cell.stopTimer.addTarget(self, action: Selector("CellTimerAdd:"), forControlEvents: UIControlEvents.TouchUpInside)
//                cell.stopTimer.tag = 5
//                return cell
            default:
                let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reusetableview")
                return cell
            }
        
        
    }
    @objc func CellTimerAdd(_ but:UIButton){
        if but.tag == 0 {
            print(433)
            self.equip!.type = "315"
            //let cell = tableView.cellForRowAtIndexPath(4)
            self.butArr[0].setBackgroundImage(UIImage(named: "传感器选择"), for: UIControlState())
            self.butArr[1].setBackgroundImage(UIImage(named: "传感器不选择"), for: UIControlState())
        }else if but.tag == 1{
            self.equip!.type = "433"
            self.butArr[0].setBackgroundImage(UIImage(named: "传感器不选择"), for: UIControlState())
            self.butArr[1].setBackgroundImage(UIImage(named: "传感器选择"), for: UIControlState())
            print(315)
        }
    }
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            switch indexPath.section {
            case 1:
                let cell = tableView.cellForRow(at: indexPath) as! EquipConfigCell
//                let choseDeviceType = ChoseDeviceTypeVC(nibName:"ChoseDeviceTypeVC",bundle: nil)
//                choseDeviceType.configCompeletBlock({  [unowned self,unowned cell] (equipType, v) -> () in
//                    print("\(equipType)+\(v)")
//                   
//                    cell.cellDetail.text = equipType
//                    self.equip!.type = String(v)
//                    self.tableView.reloadData()
//                    })
//                self.navigationController?.pushViewController(choseDeviceType, animated: true)
                let infraredVC = SensorViewController(nibName: "SensorViewController", bundle: nil)
                
                infraredVC.configCompeletBlock({  [unowned self,unowned cell] (equipType, v) -> () in
                    print("\(equipType)+\(v)")
                    
                    self.equip!.num = v //绑定的情景模式
                    cell.cellDetail.text = equipType
         //           self.tableView.reloadData()
                                    })
                
                print(self.equip?.equipID)
                infraredVC.Address = self.equip!.equipID
                self.navigationController?.pushViewController(infraredVC, animated: true)
                break
//            case 1:
//                let cell = tableView.cellForRowAtIndexPath(indexPath) as! EquipImageCell
//                
//                let choosIconVC = ChooseIconVC(nibName: "ChooseIconVC", bundle: nil)
//                choosIconVC.chooseImageBlock( { [unowned self,unowned cell] (imageName) -> () in
//                    
//                    cell.cellIconImage.image = UIImage(named: imageName)
//                    self.equip!.icon = imageName
//                    })
//                self.navigationController?.pushViewController(choosIconVC, animated: true)
            case 3:
                let cell = tableView.cellForRow(at: indexPath) as! EquipConfigCell
                self.sunData?.title.text = NSLocalizedString("选择主机:", comment: "")
                self.sunData?.setNumberOfComponents(1, set: self.arr, addTarget: self.navigationController!.view, completeIndex: { [unowned self](one, two, three) -> Void in
                    self.equip?.hostDeviceCode = self.shotArr[one.hashValue]
                    cell.cellTitle.text = NSLocalizedString("选择主机:", comment: "")
                    cell.cellDetail.text = self.arr[Int(one)]
                })
                
                break
            default:
                break
            }
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
