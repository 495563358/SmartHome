//
//  AddDevicetoRoom.swift
//  SmartHome
//
//  Created by Smart house on 2017/11/27.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class AddDevicetoRoom:UITableViewController, UIGestureRecognizerDelegate {
    var equip: Equip?
    var equipIndex :IndexPath?
    var NameText:String?//导航栏名
    var EquType:Int?//类型
    
    var shotArr = [String]()
    var arr = [String]()
    var deviceCodeIs = ""
    var deviceCodeName = ""
    
    var indexNum:Int?//位置
    var flagStr:String? = ""
    
    fileprivate var compeletBlock: ((Equip,IndexPath)->())?
    
    func configCompeletBlock(_ compeletBlock: @escaping (_ equip: Equip,_ indexPath:IndexPath)->()) {
        self.compeletBlock = compeletBlock
    }
    
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
    
    //------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("添加设备", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddDevicetoRoom.handleBack(_:)))
        
        self.tableView = UITableView.init(frame: UIScreen.main.bounds, style: .grouped)
        var height:CGFloat = 168
        
        height = 168 * 1.5
        
        let nextStep = UIButton.init(frame: CGRect(x: (ScreenWidth - 192)/2, y: height, width: 192, height: 45))
        nextStep.backgroundColor = systemColor
        nextStep.layer.cornerRadius = 10
        nextStep.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStep.setTitle("下一步", for: UIControlState())
        nextStep.addTarget(self, action: #selector(AddDevicetoRoom.handleRightItem(_:)), for: UIControlEvents.touchUpInside)
        self.view .addSubview(nextStep)
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.tableHeaderView = UIView(frame:CGRect(x:0,y:0,width:ScreenWidth,height:0.01))
        
        self.tableView.register(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        self.tableView.register(UINib(nibName: "EquipConfigCell", bundle: nil), forCellReuseIdentifier: "equipconfigcell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddDevicetoRoom.handleTap(_:)))
        tap.delegate = self
        self.tableView.addGestureRecognizer(tap)
        
        print("-----\(self.equip?.hostDeviceCode)===")
        
        print("房间号2 = \(self.equip?.roomCode)")
        
        BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) { [unowned self](back) -> () in
            print(back)
            
            if(back.count <= 0)
            {return}
            for dic in back as![[String:String]]
            {
                print(dic )
                
                if dic["status"]! == "1"{
                    self.arr.append(NSLocalizedString("在线", comment: "") + "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.characters.count)!-5, 5))))  "+dic["nickName"]! )
                }else{
                    self.arr.append(NSLocalizedString("离线", comment: "") +  "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.characters.count)!-5, 5))))  "+dic["nickName"]! )
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
            if self.arr.count >= 1
            {
                if self.equip?.hostDeviceCode == "unload"{
                    self.equip?.hostDeviceCode = self.shotArr[0]
                    self.deviceCodeIs = self.arr[0]
                }
            }
            else
            {
                self.equip?.hostDeviceCode = "load"
            }
            if self.arr.count >= 1
            {
                self.tableView.reloadData();
            }
            
        }
        
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRightItem(_ barButton: UIButton) {
        
        if self.equip!.name == ""
        {
            showMsg(msg: NSLocalizedString("名字不能为空", comment: ""))
            return
        }
        if self.equip!.roomCode == ""
        {
            showMsg(msg: NSLocalizedString("房间不能为空", comment: ""))
            return
        }
        if self.equip!.hostDeviceCode == "load"
        {
            showMsg(msg: NSLocalizedString("请先扫描主机", comment: ""))
            return
        }
        if self.deviceCodeIs == ""{
            showMsg(msg: NSLocalizedString("请选择主机", comment: ""))
            return
        }
        //添加设备
        let parameter = [
            "roomCode":self.equip!.roomCode,
            "deviceAddress":self.equip!.equipID,
            "nickName":self.equip!.name,
            "ico":self.equip!.icon,
            "deviceType":self.equip!.type,
            "deviceCode":self.equip!.hostDeviceCode]
            
            
        print("提交参数 = \(parameter)")
        
        BaseHttpService.sendRequestAccess(addEq_do, parameters:parameter as NSDictionary, success: { (data) -> () in
            self.equip!.saveEquip()
            print("服务器反馈 = \(data)")
            
            let ver = VerificationDevice()
            ver.equip = self.equip
            ver.indexNum = self.indexNum
            ver.flagStr = self.flagStr
            self.navigationController?.pushViewController(ver, animated: true)
            
        })
        
    }
    //键盘消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if  self.arr.count <= 1
        {
            return 2
        }
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipnamecell", for: indexPath) as! EquipNameCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.equipName.text = equip?.name
            cell.complete =  {[unowned self] (name)in
                print(name)
                self.equip?.name = name!
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
            cell.cellTitle.text = NSLocalizedString("所属房间:", comment: "")
            if equip?.roomCode != "" {
                let room = dataDeal.searchModel(type: .Room, byCode: (equip?.roomCode)!) as! Room
                cell.cellDetail.text = room.name
                
                print(" 设备房间")
                
            } else {
                cell.cellDetail.text = ""
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
            cell.cellTitle.text = NSLocalizedString("选择主机:", comment: "")
            cell.cellDetail.text = self.deviceCodeIs
            cell.selectionStyle =  UITableViewCellSelectionStyle.none
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
            cell.cellTitle.text = NSLocalizedString("选择主机:", comment: "")
            
            if self.deviceCodeIs == "1"{
                cell.cellDetail.text = NSLocalizedString("在线", comment: "")+"  " +  "(\((self.equip!.hostDeviceCode as NSString).substring(with: NSMakeRange((self.equip!.hostDeviceCode.characters.count)-5, 5))))  "+self.deviceCodeName
            }else if self.deviceCodeIs == "0"{
                cell.cellDetail.text = NSLocalizedString("离线", comment: "")+"  " +  "(\((self.equip!.hostDeviceCode as NSString).substring(with: NSMakeRange((self.equip!.hostDeviceCode.characters.count)-5, 5))))  "+self.deviceCodeName
            }else{
                cell.cellDetail.text = NSLocalizedString("请选择主机", comment: "")
            }
            cell.selectionStyle =  UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! EquipConfigCell
            let floorArr = dataDeal.getModels(type: .Floor) as! [Floor]
            var codeArr = [String]()
            var nameArr = [String]()
            for floor in floorArr {
                let roomArr = dataDeal.getRoomsByFloor(floor: floor)
                for room in roomArr {
                    codeArr.append(room.roomCode)
                    nameArr.append("\(floor.name)   \(room.name)")
                }
            }
            
            let chooseAlert = SHChooseAlertView(title:  NSLocalizedString("所属房间:", comment: ""), dataSource: nameArr, cancleButtonTitle: NSLocalizedString("取消", comment: ""), confirmButtonTitle: NSLocalizedString("确定", comment: ""))
            chooseAlert.alertAction({ [unowned cell, unowned self] (alert, buttonIndex) -> () in
                switch buttonIndex {
                case 0:
                    break
                case 1:
                    if codeArr.count == 0{
                        return
                    }
                    cell.cellDetail.text = alert.selectItem
                    self.equip?.roomCode = codeArr[alert.selectRow]
                    print("房间代码 = \(self.equip?.roomCode)")
                    print(codeArr)
                    print(alert.selectRow)
                    
                    
                default:
                    break
                }
                })
            chooseAlert.show()
            tableView.deselectRow(at: IndexPath(row: 0, section: 1), animated: true)
            break
        case 2:
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
    
}

