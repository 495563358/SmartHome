//
//  ClassifyHomeVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
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




class AutomaticDevice: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate ,UIActionSheetDelegate{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    var test = true
    var sender:UITapGestureRecognizer?
    
    var cDataSource: [Equip] = []
    var tDataSource: [FloorOrRoomOrEquip] = []
    var tDic: [String : [Equip]] = [String : [Equip]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUnClassifyDataSource()
        self.reloadClassifyDataSource()
        // self.navigationItem.setHidesBackButton(true, animated: false)
    }
    var timer:Timer?
    var numtimer = 0
    @objc func timerDown(){
        numtimer += 1
        
        if numtimer == 10
        {
            numtimer = 0
            timer?.invalidate()
        }
    }
    
    func reloadUnClassifyDataSource() {
        
        if numtimer == 0{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AutomaticDevice.timerDown), userInfo: nil, repeats: true)
            BaseHttpService.sendRequestAccess(quickscanhost, parameters: [:]) { (data) -> () in
                
            }
            print("查询了。。。。。。")
        }
        

        
        BaseHttpService.sendRequestAccess(unclassifyEquip_do, parameters: [:]) { (data) -> () in
            if data.count <= 0{
                self.cDataSource = []
                return
            }
            
            let arr = data as! [[String : AnyObject]]
            print(arr)
            self.cDataSource = []
            print("aaaaaa---\(arr.count)")
            for e in arr {
                let equip = Equip(equipID: e["deviceAddress"] as! String)
                equip.userCode = e["userCode"] as! String
                equip.type = e["deviceType"] as! String
                equip.num  = e["deviceNum"] as! String
                equip.icon  = e["icon"] as! String
                equip.hostDeviceCode = e["deviceCode"] as! String
                
                if equip.icon == ""{
                    equip.icon = getIconByType(type: equip.type)
                }
                
                self.cDataSource.append(equip)
            }
            self.collectionView.reloadData()
        }
        
    }
    
    
    func reloadClassifyDataSource() {
        
        self.getRoomInfoFotClassify()
        

        
        BaseHttpService.sendRequestAccess(classifyEquip_do, parameters: ["userPhone":BaseHttpService.getUserPhoneType()]) { (data) -> () in
            print(data)
            dataDeal.clearEquipTable()
            if data.count != 0{
                
                let arr = data as! [[String : AnyObject]]
                for e in arr {
                    print("更新数据库设备")
                    let equip = Equip(equipID: e["deviceAddress"] as! String)
                    equip.name = e["nickName"] as! String
                    equip.roomCode = e["roomCode"] as! String
                    equip.userCode = e["userCode"] as! String
                    equip.type = e["deviceType"] as! String
                    equip.num  = String( describing: e["validationCode"])
                    print(String( describing: e["validationCode"]))
                    equip.icon  = e["icon"] as! String
                    equip.hostDeviceCode = e["deviceCode"] == nil ? "" : e["deviceCode"] as!String
                   // equip.num  =  e["validationCode"] == nil ? "" : e["validationCode"]as!String
                    if equip.icon == ""{
                        equip.icon = getIconByType(type: equip.type)
                    }
                    equip.saveEquip()
                    
                }
                
            }
            //先去更新数据库 再从数据库中解析
            self.getRoomInfoFotClassify()
            
        }
        
    }
    func getRoomInfoFotClassify(){
        self.tDic.removeAll()
        self.tDataSource.removeAll()
        //先去更新数据库 再从数据库中解析
        let floors = dataDeal.getModels(type: .Floor) as! [Floor]
        for floor in floors
        {
            let f = FloorOrRoomOrEquip(floor: floor,room: nil, equip: nil)
            self.tDataSource.append(f)
            let rooms = dataDeal.getRoomsByFloor(floor: floor)
            for room in rooms {
                let r = FloorOrRoomOrEquip(floor: nil,room: room, equip: nil)
                self.tDataSource.append(r)
                let equips = dataDeal.getEquipsByRoom(room: room)
                self.tDic[room.roomCode] = equips
            }
            
            
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        
        
        navigationItem.title = NSLocalizedString("搜索附近设备", comment: "")
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(AutomaticDevice.MJRefreshHeaderReload))
        self.collectionView.mj_header = header

        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ScreenWidth / 3 - 1, height: ScreenWidth / 3 - 1)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.register(UINib(nibName: "EquipCollectionCell", bundle: nil), forCellWithReuseIdentifier: "equipcollectioncell")
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellReuse")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "EquipTableRoomCell", bundle: nil), forCellReuseIdentifier: "equiptableroomcell")
        self.tableView.register(UINib(nibName: "EquipTableEquipCell", bundle: nil), forCellReuseIdentifier: "equiptableequipcell")
        self.tableView.register(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        self.tableView.register(UINib(nibName: "EquipTableFloorCell", bundle: nil), forCellReuseIdentifier: "equiptablefloorcell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AutomaticDevice.handleBack(_:)))
        
    }
    
    @objc func MJRefreshHeaderReload(){
        print("刷新界面")
        
        self.reloadUnClassifyDataSource()
        self.collectionView.mj_header.endRefreshing()
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleRightItem(_ barButton: UIBarButtonItem) {
        
        
        UIApplication.shared.keyWindow?.rootViewController = TabbarC()
    }
    
    
    
    // MARK: - UICollectionView data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cDataSource.count < 15 {
            return 15
        }
        let temp = cDataSource.count % 3
        return cDataSource.count + (3-temp)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= cDataSource.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellReuse", for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell
        }
        let equip = cDataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "equipcollectioncell", for: indexPath) as! EquipCollectionCell
      
        cell.equipName.text = NSLocalizedString(equip.icon, comment: "")
        cell.equip.text = equip.equipID
   
        
        cell.equipImage.image = UIImage(named: equip.icon)
        cell.tag = indexPath.row
        let longPressGR = UITapGestureRecognizer(target: self, action: #selector(AutomaticDevice.tapPress(_:)))
        cell.addGestureRecognizer(longPressGR)
        return cell
    }
    
    
    
    
    
    //按钮长按事件
    @objc func tapPress(_ sender:UITapGestureRecognizer){
        if sender.view?.tag < cDataSource.count {
            self.sender = sender
            let actionsheet = UIActionSheet()
            actionsheet.addButton(withTitle: NSLocalizedString("取   消", comment: ""))
            actionsheet.addButton(withTitle: NSLocalizedString("删   除", comment: ""))
            actionsheet.addButton(withTitle: NSLocalizedString("选择房间", comment: ""))
            actionsheet.cancelButtonIndex=0
            actionsheet.delegate=self
            actionsheet.show(in: self.view);
            
        }
        
    }

    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        print("点击了："+actionSheet.buttonTitle(at: buttonIndex)!)
        if buttonIndex == 2{

            
            let equipSetVC = EquipSetVC(nibName: "EquipSetVC", bundle: nil)
            equipSetVC.ifshot = "1"
            equipSetVC.equip = cDataSource[(self.sender!.view?.tag)!]
            equipSetVC.configCompeletBlock({ [unowned self,unowned equipSetVC] (equip) -> () in
                if equip.name == ""{
                    showMsg(msg: NSLocalizedString("请填入名称", comment: ""))
                    return
                }
                
                if equip.roomCode == ""{
                    showMsg(msg: NSLocalizedString("请选择房间", comment: ""))
                    return
                }
               
                //添加设备
                let parameter = [
                    "roomCode":equip.roomCode,
                    "deviceAddress":equip.equipID,
                    "nickName":equip.name,
                    "ico":equip.icon,
                "deviceCode":equip.hostDeviceCode]
                print(parameter)
                BaseHttpService.sendRequestAccess(addEq_do, parameters:  parameter as NSDictionary, success: {(data) -> () in
                    print(data)
                    self.cDataSource.remove(at: (self.sender!.view?.tag)!)
                    self.collectionView.reloadData()
                    equipSetVC.navigationController?.popViewController(animated: true)
                })
                })
            self.navigationController?.pushViewController(equipSetVC, animated: true)
        }else if buttonIndex == 1{
        let parameter = ["deviceAddress":(self.cDataSource[(self.sender!.view?.tag)!] as Equip).equipID]
            BaseHttpService.sendRequestAccess(Dele_wei, parameters: parameter as NSDictionary, success: {(data) -> () in
                print(data)
                self.cDataSource.remove(at: (self.sender!.view?.tag)!)
                self.collectionView.reloadData()
            })
            
        }
    }

    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if indexPath.row >= cDataSource.count
      {
        return
        
        }
        if cDataSource[indexPath.row].type == "1"
        {// 开关类设备
           let commad = self.test ? 100 : 0
              self.test = !self.test
            let address = cDataSource[indexPath.row].equipID
            let dic = ["deviceAddress":address,"command":commad] as [String : Any]
            BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { [unowned self](back) -> () in
                
              
                print(back)
            }
        }
        else if cDataSource[indexPath.row].type == "2"||cDataSource[indexPath.row].type == "4"
        {// 调节类设备
            print("99999999999999999999")
            let commad = self.test ? 99 : 0
            self.test = !self.test
            let address = cDataSource[indexPath.row].equipID
            let dic = ["deviceAddress":address,"command":commad] as [String : Any]
            BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { [unowned self](back) -> () in
                print(back)
            }
            
        }
        else if cDataSource[indexPath.row].type == "98" || cDataSource[indexPath.row].type == "99" || cDataSource[indexPath.row].type == "8192" 
        {// 红外设备
            let parameters = ["deviceAddress":cDataSource[indexPath.row].equipID,
                "isStudy":"1",
                "infraredButtonsValuess":"0,A"]
            print(parameters)
            BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                print(response)
            }
            
        }
        else if cDataSource[indexPath.row].type == "8" || cDataSource[indexPath.row].type == "32"{
            //8路32路控制盒
            self.test = !self.test
            BaseHttpService.sendRequestAccess(control_ControlEnclosure, parameters: ["deviceCode":cDataSource[indexPath.row].hostDeviceCode,"deviceAddress":cDataSource[indexPath.row].equipID,"controlAction":self.test ? "1" : "0"]) { (arr) -> () in
                
            }

        
        }
        else if cDataSource[indexPath.row].type == "500" || cDataSource[indexPath.row].type == "501"
        {   // 空调设备
            let commad = self.test ? 100 : 0
            self.test = !self.test
            let address = cDataSource[indexPath.row].equipID
            let dic = ["deviceAddress":address,"command":commad] as [String : Any]
            BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { [unowned self](back) -> () in
                
                
                print(back)
            }
        }
        //
        
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tDataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tDataSource[indexPath.row]
        switch model.type {
        case .floor:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equiptablefloorcell", for: indexPath) as! EquipTableFloorCell
            let floor = dataDeal.searchModel(type: .Floor, byCode: (model.floor?.floorCode)!) as! Floor
            let floorName = floor.name
            cell.roomName.text = "\(floorName)"
            return cell
        case .room:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equiptableroomcell", for: indexPath) as! EquipTableRoomCell
            
            
            cell.roomName.text = "\(model.room!.name)"
            if model.isUnfold {
                cell.unfoldImage.image = UIImage(named: "hua1")
            } else {
                cell.unfoldImage.image = UIImage(named: "hua2")
            }
            return cell
        case .equip:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equiptableequipcell", for: indexPath) as! EquipTableEquipCell
            cell.nameLabel.text = model.equip!.name
            cell.iconImage.image = UIImage(named: model.equip!.icon)
            return cell
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addroomcell", for: indexPath) as! AddRoomCell
            return cell
        }
        
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = tDataSource[indexPath.row]
        if model.type == .floor  {
            return 30
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = tDataSource[indexPath.row]
        if model.type == .floor || model.type == .room || model.type == .add{
            return false
        }
        return true
    }
    

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title:NSLocalizedString("删除", comment: "")) { (action, indexPath) -> Void in
            let model = self.tDataSource[indexPath.row]
            //从数据库删除该设备
            
            if model.equip?.equipID != ""{
                let parameter = ["deviceAddress" :model.equip!.equipID]
                BaseHttpService.sendRequestAccess(deletedevice_do, parameters: parameter as NSDictionary) { [unowned self](back) -> () in
                    
                    model.equip?.delete()
                    let arr:[Equip] = self.tDic[(model.equip?.roomCode)!]!
                    print(arr)
                    let correctArray = getRemoveIndex(value: model.equip!,array:arr)
                    //从原数组中删除指定元素
                    
                    for index in correctArray{
                        self.tDic[model.equip!.roomCode]!.remove(at: index)
                    }
                    self.tDataSource.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                }
            }
            
            
            print("删除")
        }
        let rowActionSec =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("修改", comment: "")) { (action, indexPath) -> Void in
            let model = self.tDataSource[indexPath.row]

            let equipSetVC = EquipSetVC(nibName: "EquipSetVC", bundle: nil)
            equipSetVC.equip = model.equip
            equipSetVC.configCompeletBlock({ [unowned self] (equip) -> () in
                let e = FloorOrRoomOrEquip(floor: nil,room: nil, equip: equip)
                self.tDataSource[indexPath.row] = e
                self.tableView.reloadData()
                //添加设备
                print(equip.hostDeviceCode)
                let parameter = [
                    "roomCode":equip.roomCode,
                    "deviceAddress":equip.equipID,
                    "nickName":equip.name,
                    "ico":equip.icon,
                    "deviceCode":equip.hostDeviceCode]
                print(parameter)
                BaseHttpService.sendRequestAccess(addEq_do, parameters:  parameter as NSDictionary, success: {(data) -> () in
                    print(data)
                 equipSetVC.navigationController?.popViewController(animated: true)
        
                })
                })
            self.navigationController?.pushViewController(equipSetVC, animated: true)

            
            print("标记")
        }
        rowActionSec.backgroundColor = UIColor.black
        return [rowAction,rowActionSec]
        
    }
    
    
    
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
//        return "删除"
//    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        
    }

    
}
