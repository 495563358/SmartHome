//
//  ChoseDeviceForModel.swift
//  SmartHome
//
//  Created by sunzl on 16/5/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
import MJRefresh

class ChoseDeviceForModel: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
   
    var tDataSource: [FloorOrRoomOrEquip] = []
    var tDic: [String : [Equip]] = [String : [Equip]]()
    var modelId = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRoomInfoFotClassify()
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
                let equips = dataDeal.getQJEquipsByRoomExceptSXT(room: room)
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
        
        
        navigationItem.title = NSLocalizedString("我的设备", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChoseDeviceForModel.handleBack(_:)))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        
        
     
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            print("刷新界面")
            self.getRoomInfoFotClassify()
            self.tableView.mj_header.endRefreshing()
        })
        
       
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "EquipTableRoomCell", bundle: nil), forCellReuseIdentifier: "equiptableroomcell")
        self.tableView.register(UINib(nibName: "EquipTableEquipCell", bundle: nil), forCellReuseIdentifier: "equiptableequipcell")
        self.tableView.register(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        self.tableView.register(UINib(nibName: "EquipTableFloorCell", bundle: nil), forCellReuseIdentifier: "equiptablefloorcell")
        
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 1))
        footerView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = footerView
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    func handleRightItem(_ barButton: UIBarButtonItem) {
     
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
                cell.unfoldImage.image = UIImage(named: "up_black")
            } else {
                cell.unfoldImage.image = UIImage(named: "down_black")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                tDataSource.removeSubrange(((indexPath.row + 1) ..< indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!))
                
                tableView.reloadData()
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
//                let add = FloorOrRoomOrEquip(floor:nil,room: nil, equip: nil)
//                add.addRoom = model.room
//                equips.append(add)
              tDataSource.insert(contentsOf: equips, at: indexPath.row + 1)
                tableView.reloadData()
            }
        }
        
        if model.type == .equip {
            let eq = Equip(equipID: model.equip!.equipID)
            eq.name = model.equip!.name
            eq.userCode = model.equip!.userCode
            eq.roomCode = model.equip!.roomCode
            eq.type = model.equip!.type
            eq.icon  = model.equip!.icon
            eq.num = model.equip!.num
            eq.status = model.equip!.status
            eq.hostDeviceCode = model.equip!.hostDeviceCode
            
            if eq.type == "5" || eq.type == "501"
            {
                showMsg(msg: "不支持情景模式")
                return
            }
            
            app.modelEquipArr.add(eq)
            print("\(getJsonStrOfDeviceData())")
//            BaseHttpService.sendRequestAccess(addmodelinfo, parameters: ["modelInfo":getJsonStrOfDeviceData(),"modelId":self.modelId], success: {[unowned self] (back) -> () in
//                print(back)
//                self.navigationController?.popViewControllerAnimated(true)
//                })
            showMsg(msg: "\(NSLocalizedString("添加成功", comment: ""))(\(app.modelEquipArr.count)\(NSLocalizedString("台", comment: "")))");
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = tDataSource[indexPath.row]
        if model.type == .floor  {
            return 55
        }
        return 50
    }
    //-----------添加数组
    func getJsonStrOfDeviceData()->String{
        
        let arr = NSMutableArray()
        for  e in app.modelEquipArr
        {
            let eq = e as! Equip
            let dict = ["deviceAddress":eq.equipID,"deviceType":eq.type,"controlCommand":eq.status,"delayValues":eq.delay]
            arr.add(dict)
        }
        
        return dataDeal.toJSONString(jsonSource: arr)
    }
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        let model = tDataSource[indexPath.row]
//        if model.type == .Floor || model.type == .Room || model.type == .Add {
//            return false
//        }
//        return true
//    }
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
//        return "选择"
//    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let model = tDataSource[indexPath.row]
//      
//     
//       
//       
//        
//        
//        
//    }
}
    

