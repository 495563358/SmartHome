//
//  EquipSetVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class EquipSetVC: UITableViewController, UIGestureRecognizerDelegate {
    fileprivate var compeletBlock: ((Equip)->())?
    var equip: Equip?
    
    func configCompeletBlock(_ compeletBlock: @escaping (_ equip: Equip)->()) {
        self.compeletBlock = compeletBlock
        
    }
    
    //-------主机---------
    var shotArr = [String]()
    var arr = [String]()
    var deviceCodeIs = ""
    var deviceCodeName = ""
    //判断是从未分类过来的
    var ifshot = "0"
    
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
    
    //------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        navigationItem.title = NSLocalizedString("我的设备", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(EquipSetVC.handleBack(_:)))
        
        
        self.tableView.register(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        self.tableView.register(UINib(nibName: "EquipConfigCell", bundle: nil), forCellReuseIdentifier: "equipconfigcell")
        self.tableView.register(UINib(nibName: "EquipImageCell", bundle: nil), forCellReuseIdentifier: "equipimagecell")
//        self.tableView.registerNib(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        
        let nextStep = UIButton.init(frame: CGRect(x: ScreenWidth/4, y: 50, width: ScreenWidth/2, height: 45))
        nextStep.backgroundColor = systemColor
        nextStep.layer.cornerRadius = 10
        nextStep.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStep.setTitle("保存", for: UIControlState())
        nextStep.addTarget(self, action: #selector(EquipSetVC.handleRightItem(_:)), for: UIControlEvents.touchUpInside)
        
        let footerView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWidth,height:100))
        footerView.addSubview(nextStep)
        self.tableView.tableFooterView = footerView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EquipSetVC.handleTap(_:)))
        tap.delegate = self
        self.tableView.addGestureRecognizer(tap)
        
        print("-----\(self.equip?.hostDeviceCode)===")
        

        BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) { [unowned self](back) -> () in
            print(back)
            
            if(back.count <= 0)
            {return}
            for dic in back as![[String:String]]
            {
                print(dic )
                
                if dic["status"]! == "1"{
                    self.arr.append(NSLocalizedString("在线", comment: "") + "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.count)!-5, 5))))  "+dic["nickName"]! )
                }else{
                    self.arr.append(NSLocalizedString("离线", comment: "") +  "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.count)!-5, 5))))  "+dic["nickName"]! )
                }
                if self.equip?.hostDeviceCode == dic["deviceCode"]{
                    if dic["status"]! == "1"{
                        self.deviceCodeIs = NSLocalizedString("在线", comment: "") + "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.count)!-5, 5))))  "+dic["nickName"]!
                    }else{
                        self.deviceCodeIs = NSLocalizedString("离线", comment: "") +  "  " +  "(\((dic["deviceCode"]! as NSString).substring(with: NSMakeRange((dic["deviceCode"]?.count)!-5, 5))))  "+dic["nickName"]!
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
                self.equip?.hostDeviceCode  = "load"
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
    @objc func handleRightItem(_ barButton: UIBarButtonItem) {
        if equip?.name == ""{
            showMsg(msg: NSLocalizedString("请输入名称", comment: ""))
            return
        }
        
        if equip?.type == "100"||equip?.type == "101"{
            equip?.hostDeviceCode = "commonsxt"
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EquipNameCell
          equip!.name = (cell.equipName.text?.trimString())!
        print("--\(String(describing: equip?.name))-\(String(describing: equip?.icon))-\(String(describing: equip?.roomCode))-\(String(describing: equip?.hostDeviceCode))")
        compeletBlock?(equip!)
        
        //self.navigationController?.popViewControllerAnimated(true)
//        for temp in self.navigationController!.viewControllers {
//            if temp.isKindOfClass(HomeVC.classForCoder()) {
//                self.navigationController?.popToViewController(temp , animated: true)
//            }else if temp.isKindOfClass(MineVC.classForCoder()){
//                self.navigationController?.popToViewController(temp , animated: true)
//            }
//        }
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
        
        if self.equip?.type == "100"{
            return 4
        }
        
        if self.shotArr.count == 1 || ifshot == "1" || self.equip?.type == "101"||self.equip?.type == "8" || self.equip?.type == "32"||self.equip?.type == "98"{
            return 3
        }
        return 4
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
        case 1:
           let cell = tableView.dequeueReusableCell(withIdentifier: "equipimagecell", for: indexPath) as! EquipImageCell
           cell.cellTitleLabel.text = NSLocalizedString("设备图标:", comment: "")
           cell.cellIconImage.image = UIImage(named:(equip?.icon)!)
           
           return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
            cell.cellTitle.text = NSLocalizedString("所属房间:", comment: "")
            if equip?.roomCode != "" {
                let room = dataDeal.searchModel(type: .Room, byCode: (equip?.roomCode)!) as! Room
                cell.cellDetail.text = room.name
            } else {
                cell.cellDetail.text = ""
            }
            
            return cell
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipnamecell", for: indexPath) as! EquipNameCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.equipName.text = equip?.name
            cell.complete =  {[unowned self] (name)in
                print(name)
                
                
                self.equip?.name = name!
            }
            return cell
            
        case 3:
            
            if self.equip?.type == "100"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "equipnamecell", for: indexPath) as! EquipNameCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.equipName.text = equip?.num
                cell.leab.text = "设备密码"
                cell.equipName.isSecureTextEntry = true
                cell.complete =  {[unowned self] (name)in
                    print(name)
                    
                    self.equip?.num = name!
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
            cell.cellTitle.text = NSLocalizedString("选择主机:", comment: "")
            
            
//            if self.deviceCodeIs == "1"{
//                cell.cellDetail.text = NSLocalizedString("在线", comment: "") + "  " +  "(\((self.equip!.hostDeviceCode as NSString).substringWithRange(NSMakeRange((self.equip!.hostDeviceCode.characters.count)-5, 5))))  "+self.deviceCodeName
//            }else if self.deviceCodeIs == "0"{
//                cell.cellDetail.text = NSLocalizedString("离线", comment: "") + "  " +  "(\((self.equip!.hostDeviceCode as NSString).substringWithRange(NSMakeRange((self.equip!.hostDeviceCode.characters.count)-5, 5))))  "+self.deviceCodeName
//            }else{
//                cell.cellDetail.text = NSLocalizedString("请选择主机", comment: "")
//            }
            //cell.cellDetail.text = self.equip?.hostDeviceCode
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
            let cell = tableView.cellForRow(at: indexPath) as! EquipImageCell
            
            let choosIconVC = ChooseIconVC(nibName: "ChooseIconVC", bundle: nil)
            choosIconVC.chooseImageBlock({ [unowned cell] (imageStr) -> () in
                self.equip?.icon = imageStr
                cell.cellIconImage.image = UIImage(named: imageStr)
            })
            self.navigationController?.pushViewController(choosIconVC, animated: true)
        case 2:
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! EquipConfigCell
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
                default:
                    break
                }
            })
            chooseAlert.show()
            tableView.deselectRow(at: IndexPath(row: 0, section: 2), animated: true)
            break
        case 3:
            if self.equip?.type == "100"{
                return
            }
            
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
