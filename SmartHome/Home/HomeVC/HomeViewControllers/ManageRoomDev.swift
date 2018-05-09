//
//  ManageRoomDev.swift
//  SmartHome
//
//  Created by kincony on 15/12/25.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class FloorOrRoomOrEquip {
    enum ItemType {
        case floor,room, equip, add
    }
    var floor:Floor?
    var room: Room?
    var equip: Equip?
    var addRoom: Room?
    
    
    var type: ItemType {
        if floor != nil {
            return .floor
        }
        if equip != nil {
            return .equip
        }
        if room != nil {
            return .room
        }
        if equip != nil {
            return .equip
        }
        return .add
    }
    var isUnfold: Bool = false
    init(floor:Floor?,room: Room?, equip: Equip?) {
        self.floor = floor
        self.room = room
        self.equip = equip
    }
}

class ManageRoomDev: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    var isSimple = false
    @IBOutlet var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self

        }
    }
    @IBOutlet var addFloorBtn: UIButton! {
        didSet{
            addFloorBtn.layer.cornerRadius = 5
            addFloorBtn.layer.masksToBounds = true
            addFloorBtn.backgroundColor = themeColors
        }
    }
    
    var timer:Timer?
    var numtimer = 0
    func timerDown(){
        numtimer += 1
        
        if numtimer == 10
        {
            numtimer = 0
            timer?.invalidate()
        }
    }
    
    var flag:Int = 0
    
    var floorArr: [Building] = []
    var roomDic: [String : [Building]] = [String : [Building]]()
    var dataSource: [Building] = []
    
    //设备
    var cDataSource: [Equip] = []
    var tDataSource: [FloorOrRoomOrEquip] = []
    var tDic: [String : [Equip]] = [String : [Equip]]()
    
    var devtableView:UITableView!
    
    var deviceSegement: SHSegement! = SHSegement()
    
    //刷新设备数据
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
            DispatchQueue.global(qos: .default).async(execute: { () -> Void in
                self.getRoomInfoFotClassify()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.unfoldDevice()
                });
            })
            
            
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
        DispatchQueue.main.async(execute: { () -> Void in
            self.devtableView.reloadData()
        });
    }
    //楼层信息组装
    func assembleFloor() -> String {
        var subArr = [[String : String]]()
        for floor in floorArr {
            subArr.append(["floorName" : floor.buildName,"floorCode" : floor.buildCode])
           
        }
        
        return dataDeal.toJSONString(jsonSource: subArr as AnyObject)
    }
    
    //房间信息组装
    func assembleRoom()->String {
    
        var subArr: [[String : String]] = []
        for key in roomDic.keys {
            for value in roomDic[key]! {
                if value != roomDic[key]?.last {
                    var suDic = ["roomName" : value.buildName]
                    suDic["floorName"] = key
                    suDic["roomCode"] = value.buildCode
                    subArr.append(suDic)
                }
            }
        }
       
        return dataDeal.toJSONString(jsonSource: subArr as AnyObject)
    }
    
    
    
    @IBAction func handleTapTableView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBOutlet var tapTableView: UITapGestureRecognizer! {
        didSet {
            tapTableView.delegate = self
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationItem.title = NSLocalizedString("管理房间设备", comment: "")
        
        self.tableView.frame = CGRect(x: 0, y: 50, width: ScreenWidth, height: ScreenHeight - 120 - 64)
        self.addFloorBtn.frame = CGRect(x: 20,y: ScreenHeight - 64 - 60, width: ScreenWidth - 40, height: 40)
        self.addFloorBtn.removeFromSuperview()
        self.view.addSubview(addFloorBtn)
        
        self.addFloorBtn.setTitle("保存", for: UIControlState())
        self.addFloorBtn.backgroundColor = mainColor
        
        let footerView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 60))
        let addfloor = UIButton.init(frame: CGRect(x: ScreenWidth/4,y: 10,width: ScreenWidth/2,height: 35))
        addfloor.backgroundColor = mainColor
        addfloor.layer.cornerRadius = 5.0
        addfloor.layer.masksToBounds = true
        addfloor.setTitle("添加楼层", for: UIControlState())
        addfloor.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addfloor.addTarget(self, action: #selector(ManageRoomDev.handleRightItem(_:)), for: .touchUpInside)
        
        footerView.addSubview(addfloor)
        tableView.tableFooterView = footerView
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //楼层
        tableView.register(UINib(nibName: "FloorCell", bundle: nil), forCellReuseIdentifier: "floorcell")
        tableView.register(UINib(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "roomcell")
        tableView.register(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tipLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 30))
        tipLab.textAlignment = .center
        tipLab.textColor = UIColor.gray
        tipLab.text = "提示:点击可对名称进行修改,左滑可删除。"
        tipLab.backgroundColor = UIColor.groupTableViewBackground
        tipLab.font = UIFont.systemFont(ofSize: 14)
        
        tableView.tableHeaderView=tipLab
        
        //设备
        self.devtableView = UITableView.init(frame: CGRect(x: 0, y: 50, width: ScreenWidth, height: ScreenHeight - 50 - 64), style: UITableViewStyle.grouped)
        self.view.addSubview(self.devtableView)
        let tipLab2 = UILabel.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 30))
        tipLab2.textAlignment = .center
        tipLab2.textColor = UIColor.gray
        tipLab2.text = "提示:右滑可修改设备。"
        tipLab2.backgroundColor = UIColor.groupTableViewBackground
        tipLab2.font = UIFont.systemFont(ofSize: 14)
        self.devtableView.tableHeaderView=tipLab2
        
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(ManageRoomDev.MJRefreshHeaderReload))
        
        self.devtableView.mj_header = header
        
        self.devtableView.delegate = self
        self.devtableView.dataSource = self
        self.devtableView.register(UINib(nibName: "EquipTableRoomCell", bundle: nil), forCellReuseIdentifier: "equiptableroomcell")
        self.devtableView.register(UINib(nibName: "EquipTableEquipCell", bundle: nil), forCellReuseIdentifier: "equiptableequipcell")
        self.devtableView.register(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        self.devtableView.register(UINib(nibName: "EquipTableFloorCell", bundle: nil), forCellReuseIdentifier: "equiptablefloorcell")
        
        
        //管理房间还是管理设备
        self.view.addSubview(self.deviceSegement)
        deviceSegement.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 50)
        deviceSegement.backgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1)
        deviceSegement.leftLabel.font = UIFont.systemFont(ofSize: 16)
        deviceSegement.rightLabel.font = UIFont.systemFont(ofSize: 16)
        deviceSegement.leftLabel.text = NSLocalizedString("管理房间", comment: "")
        deviceSegement.rightLabel.text = NSLocalizedString("管理设备", comment: "")
        
        self.tableView.tag = 1
        self.devtableView.tag = 2
        
        self.view.bringSubview(toFront: self.tableView)
        self.view.bringSubview(toFront: self.addFloorBtn)
        self.devtableView.isHidden = true
        
        deviceSegement.selectAction(.left) { [unowned self] () -> () in
            self.view.bringSubview(toFront: self.tableView)
            self.view.bringSubview(toFront: self.addFloorBtn)
            self.devtableView.isHidden = true
        }
        
        deviceSegement.selectAction(.right) { [unowned self] () -> () in
            self.view.bringSubview(toFront: self.devtableView)
            self.unfoldDevice()
            print("设备数量 = \(self.tDataSource.count)")
            self.devtableView.isHidden = false
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManageRoomDev.handleBack(_:)))
    }
    
    /* 展开设备 */
    func unfoldDevice(){
        let countIndex:Int = self.tDataSource.count
        for i in 0...(countIndex - 1){
            let index = countIndex - 1 - i
            let model = self.tDataSource[index]
            if model.type == .room{
                if model.isUnfold == false{
                    model.isUnfold = true
                    var equips = [FloorOrRoomOrEquip]()
                    for i in 0..<(self.tDic[model.room!.roomCode]?.count)! {
                        equips.append(FloorOrRoomOrEquip(floor:nil,room: nil, equip: self.tDic[model.room!.roomCode]?[i]))
                    }
                    let add = FloorOrRoomOrEquip(floor:nil,room: nil, equip: nil)
                    add.addRoom = model.room
                    equips.append(add)
                    self.tDataSource.insert(contentsOf: equips, at: index + 1)
                }
            }
        }
        self.devtableView.reloadData()
    }
    
    
    @objc func MJRefreshHeaderReload(){
        print("刷新界面")
        self.reloadClassifyDataSource()
        self.devtableView.mj_header.endRefreshing()
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //刷新数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floorArr = []
        roomDic = [String : [Building]]()
        dataSource = []
        updateRoomInfo { () -> () in
            self.getRoomInfoForCreate()
            self.tableView.reloadData()
        }
        self.reloadClassifyDataSource()
    }
    
    
    func getRoomInfoForCreate(){
        
        //得到所有floor
        let floors = dataDeal.getModels(type: DataDeal.TableType.Floor) as! Array<Floor>
        for _floor in floors{
            let floor = Building(buildType: .buildFloor, buildName:  _floor.name, isAddCell: false)
            floor.buildCode = _floor.floorCode
            floorArr.append(floor)
            dataSource.append(floor)
            let rooms = dataDeal.getRoomsByFloor(floor: _floor)
           floor.isUnfold = true//打开
            
             var roomArr: [Building] = []
            for _room in rooms{
                let room = Building(buildType: .buildRoom, buildName: _room.name, isAddCell: false)
                room.buildCode = _room.roomCode
                print(room.buildName)
                room.floor = floor
                roomArr.append(room)
               dataSource.append(room)//添加房间
                
            }
            let add = Building(buildType: .buildRoom, buildName: NSLocalizedString("添加", comment: ""), isAddCell: true)
            add.floor = floor
            roomArr.append(add)
             dataSource.append(add)//添加房间
            roomDic[floor.buildName] = roomArr
           
        }
       
    }
    @IBAction func handleAddFloor(_ sender: UIButton) {
        self.tableView.isEditing = false
        
        var parameter: [String : AnyObject] = [:]
        parameter["roomInfo"] = assembleRoom() as AnyObject
        parameter["floorInfo"] = assembleFloor() as AnyObject
        print("------\(String(describing: parameter["roomInfo"]))")
        print("------\(String(describing: parameter["floorInfo"]))")
        BaseHttpService .sendRequestAccess(updatinfo, parameters: parameter as NSDictionary) { (back) -> () in
            // 更新一个版本号上传到服务器上面
            
            updateRoomInfo(complete: { () -> () in
                showMsg(msg: NSLocalizedString("保存成功", comment: ""));
                self.floorArr = []
                self.roomDic = [String : [Building]]()
                self.dataSource = []
                self.navigationController?.popViewController(animated: true)
                return
            })
        }
    }
    @objc func handleRightItem(_ barButton: UIBarButtonItem) {
        var floor:Building?
        if floorArr.count == 0{
            floor = Building(buildType: .buildFloor, buildName: NSLocalizedString("楼层", comment: ""), isAddCell: false)
        }else{
            floor = Building(buildType: .buildFloor, buildName: "\(floorArr[floorArr.count-1].buildName)_1", isAddCell: false)
        }
        floorArr.append(floor!)
        dataSource.append(floor!)
        let add = Building(buildType: .buildRoom, buildName: NSLocalizedString("添加", comment: ""), isAddCell: true)
        add.floor = floor
        roomDic[floor!.buildName] = [add]
        //        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: dataSource.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        tableView.reloadData()
    }
 
    
    func checkDuplicateName(_ text: String) -> Bool {
        for floor in floorArr {
            if text == floor.buildName {
                return false
            }
        }
        return true
    }
    func checkDuplicateRoomName(_ text: String,floorName:String) -> Bool {
        
        for room in roomDic[floorName]! {
            if text == room.buildName {
                return false
            }
        }
        return true
    }
    
    // MARK - tableView data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 2{
           return tDataSource.count
        }else{
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 2{
            print("section = \(indexPath.section) row = \(indexPath.row) \(tDataSource.count)")
            if(indexPath.row >= tDataSource.count){
                let whiteCell = UITableViewCell.init(style: .default, reuseIdentifier: "whitecell")
                return whiteCell
            }
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
                    cell.unfoldImage.image = UIImage(named: "down_black")
                } else {
                    cell.unfoldImage.image = UIImage(named: "up_black")
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
        else
        {
            let building = dataSource[indexPath.row]
            switch building.buildType {
            case .buildFloor:
                let cell = tableView.dequeueReusableCell(withIdentifier: "floorcell", for: indexPath) as! FloorCell
                cell.indexPath = indexPath
                cell.floorName.text = building.buildName
                cell.unfoldBtn.isSelected = building.isUnfold
                cell.configEndChange({ (text) -> () in
                    print("---原始信息为:\(self.roomDic)")
                    let oldName = building.buildName
                    if self.checkDuplicateName(text) && text.trimString() != "" {
                        print("\(text)")
                        let text1=text.replacingOccurrences(of: " ", with: "_")
                        self.roomDic[text1] = self.roomDic[oldName]
                        print("增加后楼层名为:\(text1)\n 信息为:\(self.roomDic)")
                        self.roomDic.removeValue(forKey: oldName)
                        print("最终后楼层名为:\(text1)\n 信息为:\(self.roomDic)")
                        building.buildName = text1
                    }
                    
                })
                
                cell.configEndEditing({ [unowned self, unowned cell] (text) -> () in
                    let oldName = building.buildName
                    if text.trimString() == "" {
                        print("oldName=\(oldName)")
                        //showMsg("不能为空")
                        cell.floorName.text = oldName
                        
                    }else if self.checkDuplicateName(text) {
                        building.buildName = text
                        self.roomDic[text] = self.roomDic[oldName]
                        self.roomDic.removeValue(forKey: oldName)
                        print("结束楼层编辑")
                    } else if text != oldName {
                        
                        cell.floorName.text = oldName
                        showMsg(msg: NSLocalizedString("楼层名已存在", comment: ""))
                        
                    }
                    })
                
                cell.configKeyboardAdpt({ [unowned self] (index: IndexPath) -> () in
                    let nowCell = self.tableView.cellForRow(at: index)
                    let rect = UIApplication.shared.keyWindow?.convert((nowCell?.frame)!, from: self.tableView)
                    let maxY = rect!.maxY
                    if ScreenHeight - maxY < 300 {
                        let offSet = tableView.contentOffset
                        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            tableView.contentOffset = CGPoint(x: offSet.x, y: offSet.y + 300 - ScreenHeight + maxY)
                        })
                    }
                    })
                
                
                cell.configUnfoldBlock({ [unowned self] (isUnfold: Bool) -> () in
                    let building = self.dataSource[indexPath.row]
                    print(building.buildName)
                    let rooms = self.roomDic[building.buildName]
                    print(rooms)
                    if !isUnfold {
                        var indexPaths = [IndexPath]()
                        for i in 0..<rooms!.count {
                            indexPaths.append(IndexPath(row: indexPath.row + 1 + i, section: 0))
                            self.dataSource.remove(at: indexPath.row + 1)
                        }
                        //                    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                        building.isUnfold = false
                        self.tableView.reloadData()
                        
                    } else {
                        var indexPaths = [IndexPath]()
                        for i in 0..<rooms!.count {
                            indexPaths.append(IndexPath(row: indexPath.row + 1 + i, section: 0))
                            self.dataSource.insert(rooms![i], at: indexPath.row + 1 + i)
                        }
                        //                    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                        building.isUnfold = true
                        self.tableView.reloadData()
                    }
                    })
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            case .buildRoom:
                if building.isAddCell {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addroomcell", for: indexPath) as! AddRoomCell
                    cell.building = building
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "roomcell", for: indexPath) as! RoomCell
//                    cell.lastText = building.buildName
                    cell.roomName.text = building.buildName
                    cell.indexPath = indexPath
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.configEndChange({ (text) -> () in
                        building.buildName = text
                        
                    })
                    
                    
                    cell.configEndEditing({ (text) -> () in
                        let oldName = building.buildName
                        if text.trimString() == "" {
                            showMsg(msg: NSLocalizedString("不能为空", comment: ""))
                            cell.roomName.text = oldName
                        }else if self.checkDuplicateRoomName(text,floorName: (building.floor?.buildName)!) {
                            building.buildName = text
                            
                        } else if text != oldName {
                            
                            cell.roomName.text = oldName
                            showMsg(msg: NSLocalizedString("房间名已存在", comment: ""))
                            
                        }
                        
                        
                    })
                    cell.configKeyboardAdpt({ [unowned self] (index: IndexPath) -> () in
                        let nowCell = self.tableView.cellForRow(at: index)
                        let rect = UIApplication.shared.keyWindow?.convert((nowCell?.frame)!, from: self.tableView)
                        let maxY = rect!.maxY
                        if ScreenHeight - maxY < 300 {
                            let offSet = tableView.contentOffset
                            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                                tableView.contentOffset = CGPoint(x: offSet.x, y: offSet.y + 300 - ScreenHeight + maxY)
                            })
                            
                        }
                        
                        })
                    return cell
                }
            }
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 2{
            if(indexPath.row >= tDataSource.count){
                return
            }
            let model = tDataSource[indexPath.row]
            if model.type == .room {
                let cell = tableView.cellForRow(at: indexPath) as! EquipTableRoomCell
                if model.isUnfold {
                    model.isUnfold = false
                    cell.unfoldImage.image = UIImage(named: "楼层未按下")
                    var indexPaths = [IndexPath]()
                    for i in 0..<(tDic[model.room!.roomCode]?.count)! {
                        let subIndexPath = IndexPath(row: indexPath.row + 1 + i, section: 0)
                        indexPaths.append(subIndexPath)
                    }
                    indexPaths.append(IndexPath(row: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!, section: 0))
                    tDataSource.removeSubrange(((indexPath.row + 1) ..< indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)! + 1))
                    
                    devtableView.reloadData()
                } else {
                    
                    model.isUnfold = true
                    cell.unfoldImage.image = UIImage(named: "楼层按下")
                    var indexPaths = [IndexPath]()
                    var equips = [FloorOrRoomOrEquip]()
                    for i in 0..<(tDic[model.room!.roomCode]?.count)! {
                        let subIndexPath = IndexPath(row: indexPath.row + 1 + i, section: 0)
                        indexPaths.append(subIndexPath)
                        equips.append(FloorOrRoomOrEquip(floor:nil,room: nil, equip: tDic[model.room!.roomCode]?[i]))
                    }
                    
                    indexPaths.append(IndexPath(row: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!, section: 0))
                    let add = FloorOrRoomOrEquip(floor:nil,room: nil, equip: nil)
                    add.addRoom = model.room
                    equips.append(add)
                    tDataSource.insert(contentsOf: equips, at: indexPath.row + 1)
                    devtableView.reloadData()
                }
            }
            
            if model.type == .add {
                if BaseHttpService.GetAccountOperationType() == "2"{
                    showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                    return
                }
                let handly = HandlyAddDevice()
                handly.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(handly, animated: true)
            }
            
        }
        //管理房间
        else{
            if(indexPath.row >= dataSource.count){
                return
            }
            let building = dataSource[indexPath.row]
            if building.isAddCell {
                let roomArr = roomDic[building.floor!.buildName]
                var build:Building?
                if roomArr!.count == 1{
                    build = Building(buildType: .buildRoom, buildName: NSLocalizedString("房间", comment: ""), isAddCell: false)
                }else {
                    build = Building(buildType: .buildRoom, buildName: "\(roomArr![roomArr!.count-2].buildName)_1", isAddCell: false)
                }
                dump(build)
                dump(roomArr)
                
                build!.floor = building.floor
                
                let num = (roomDic[building.floor!.buildName]?.endIndex)! - 1
                roomDic[building.floor!.buildName]?.insert(build!, at: num)
                dataSource.insert(build!, at: indexPath.row)
                //            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 2{
            if (indexPath.row >= tDataSource.count){
                return 0.01
            }
            let model = tDataSource[indexPath.row]
            if model.type == .floor  {
                return 55
            }
            return 50
        }
        
        let building = dataSource[indexPath.row]
        if building.buildType == BuildType.buildRoom
        {
            return 50
        }else{
            return 55
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 2{
            if (indexPath.row >= tDataSource.count){
                return false
            }
            let model = tDataSource[indexPath.row]
            
            if model.type == .floor || model.type == .room || model.type == .add{
                return false
            }
            return true
        }
        print("-----------\(indexPath.row)")
        if dataSource.count == 0{
            return false
        }
        let building = dataSource[indexPath.row]
        if building.isAddCell{
        return false
        }
        return true
       
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
//        if tableView == self.tableView{
//            return NSLocalizedString("删除", comment: "")
//        }
//        return ""
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if(tableView.tag == 2){
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
                        self.devtableView.reloadData()
                        
                    }
                }
                
                
                print("删除")
            }
            let rowActionSec =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("修改", comment: "")) { (action, indexPath) -> Void in
                let model = self.tDataSource[indexPath.row]
                
                
                
                let equipSetVC = EquipSetVC(nibName: "EquipSetVC", bundle: nil)
                if model.equip?.type == "100"{
                    
                    let string:NSString = (model.equip?.num)! as NSString
                    
                    print(string)
                    
                    let sub = string.substring(with: NSRange(location: 9,length:string.length-10))
                    model.equip?.num = sub
                }
                
                equipSetVC.equip = model.equip
                equipSetVC.configCompeletBlock({ [unowned self] (equip) -> () in
                    
                    
                    
                    
                    //智能屋摄像头修改房间
                    if equip.type == "100"{
                        let model = self.tDataSource[indexPath.row]
                        
                        print("设备密码 = \(equip.num)")
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
                                
                                //重新添加
                                let parameter = [
                                    "roomCode":equip.roomCode,
                                    "deviceAddress":equip.equipID,
                                    "nickName":equip.name,
                                    "ico":equip.icon,
                                    "validationCode":equip.num,
                                    "deviceType":"100",
                                    "deviceCode":"commonsxt"]
                                
                                BaseHttpService.sendRequestAccess("http://120.77.250.17:8080/smarthome.IMCPlatform/xingUser/setDeviceInfo.action", parameters: parameter as NSDictionary, success: { (AnyObject) -> () in
                                    equip.saveEquip()
                                    showMsg(msg: "修改成功")
                                    
                                    equipSetVC.navigationController?.popViewController(animated: true)
                                    self.devtableView.reloadData()
                                })
                                
                            }
                        }
                        
                        
                    }
                    else{
                        let e = FloorOrRoomOrEquip(floor: nil,room: nil, equip: equip)
                        self.tDataSource[indexPath.row] = e
                        self.devtableView.reloadData()
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
                    }
                })
                self.navigationController?.pushViewController(equipSetVC, animated: true)
                
                
                print("标记")
                
            }
            rowActionSec.backgroundColor = UIColor.gray
            return [rowAction,rowActionSec]
            
        }
        let rowAction =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title:NSLocalizedString("删除", comment: "")) { (action, indexPath) -> Void in
            
            
                if self.dataSource.count == 0{
                    return
                }
                let building = self.dataSource[indexPath.row]
                //如果是房间
                if building.buildType == BuildType.buildRoom
                {
                    
                    let alertController = UIAlertController(title: NSLocalizedString("提示", comment: ""),
                        message: NSLocalizedString("确定删除楼层", comment: ""), preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: NSLocalizedString("好的",comment:""), style: .default,
                        handler: {
                            action in
                            print("点击了确定")
                            
                            //----
                            if building.buildCode != ""{
                                //如果添加的房间已提交
                                let parameter = ["roomCode" :building.buildCode]
                                BaseHttpService .sendRequestAccess(deleteroom_do, parameters: parameter as NSDictionary) { [unowned self](back) -> () in
                                    
                                    
                                    Room( roomCode:building.buildCode).delete()
                                    
                                    showMsg(msg: NSLocalizedString("删除成功", comment: ""));
                                    let correctArray = getRemoveIndex(value: building,array: (self.roomDic[building.floor!.buildName])!)
                                    //从原数组中删除指定元素
                                    
                                    for index in correctArray{
                                        self.roomDic[building.floor!.buildName]?.remove(at: index)
                                    }
                                    self.dataSource.remove(at: indexPath.row)
                                    self.tableView.reloadData()
                                }
                            }else{
                                //如果添加的房间未提交
                                let correctArray = getRemoveIndex(value: building,array: (self.roomDic[building.floor!.buildName])!)
                                //从原数组中删除指定元素
                                
                                for index in correctArray{
                                    self.roomDic[building.floor!.buildName]?.remove(at: index)
                                }
                                self.dataSource.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                            }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    //
                }else
                {
                    let alertController = UIAlertController(title: NSLocalizedString("提示", comment: ""),
                        message: NSLocalizedString("确定删除楼层", comment: ""), preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: NSLocalizedString("好的",comment:""), style: .default,
                        handler: {
                            action in
                            print("点击了确定")
                            
                            //删除的是楼层
                            if(building.isUnfold){
                                
                                print("楼层已打开");
                                let correctArray = getRemoveIndex(value: building,array:self.floorArr)
                                //从原数组中删除指定元素
                                
                                if self.roomDic.keys.contains(building.buildName)
                                {
                                    //var indexPaths = [NSIndexPath]()
                                    let arr = self.roomDic[building.buildName]
                                    
                                    for _ in 0 ..< arr!.count+1
                                    {
                                        self.dataSource.remove(at: indexPath.row)
                                    }
                                    self.roomDic.removeValue(forKey: building.buildName)
                                    print("shanchu1====")
                                }
                                for index in correctArray{
                                    self.floorArr.remove(at: index)
                                }
                                self.tableView.reloadData()
                                
                            }else{
                                print("楼层未打开");
                                let correctArray = getRemoveIndex(value: building,array:self.floorArr)
                                //从原数组中删除指定元素
                                if self.roomDic.keys.contains(building.buildName)
                                {
                                    self.roomDic.removeValue(forKey: building.buildName)
                                    print("shanchu====")
                                }
                                for index in correctArray{
                                    self.floorArr.remove(at: index)
                                }
                                self.dataSource.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                            }
                            
                            //已提交
                            if building.buildCode != ""{
                                
                                let parameter = ["floorCode" :building.buildCode]
                                BaseHttpService .sendRequestAccess(deletefloor_do, parameters: parameter as NSDictionary) {[unowned self](back) -> () in
                                    
                                    Floor( floorCode:building.buildCode).delete()
                                    
                                    showMsg(msg: NSLocalizedString("删除成功", comment: ""));
                                    
                                    
                                }
                            }
                            //---
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                //            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
            
            print("删除")
        }
        return [rowAction]
    }

    //获取正确的删除索引
      /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
