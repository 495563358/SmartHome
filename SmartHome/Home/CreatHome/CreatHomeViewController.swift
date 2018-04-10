//
//  CreatHomeViewController.swift
//  SmartHome
//
//  Created by kincony on 15/12/25.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire


enum BuildType {
    case buildFloor, buildRoom
}

func ==(lhs: Building, rhs: Building) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Building : Hashable {
    var buildType = BuildType.buildRoom
    var buildName: String = ""
    var buildCode: String = ""
    var isAddCell = false
    var floor: Building?
    var isUnfold: Bool = false
    var isApproval: Bool = true
    
    init(buildType: BuildType, buildName: String, isAddCell: Bool) {
        self.buildType = buildType
        self.buildName = buildName
        self.isAddCell = isAddCell
    }
    
    var hashValue: Int {
        return "\(buildType),\(buildName),\(isAddCell),\(floor),\(isUnfold)".hashValue
    }
    
}

class CreatHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

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
    
    var floorArr: [Building] = []
    var roomDic: [String : [Building]] = [String : [Building]]()
    var dataSource: [Building] = []
    
    
    
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
        navigationItem.title = NSLocalizedString("管理我的家", comment: "")
        self.addFloorBtn.setTitle("保存", for: UIControlState())
        self.addFloorBtn.backgroundColor = mainColor
        //navigationController?.navigationBar.setBackgroundImage(UIImage(named: "导航栏L"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.register(UINib(nibName: "FloorCell", bundle: nil), forCellReuseIdentifier: "floorcell")
        tableView.register(UINib(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "roomcell")
        tableView.register(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let footerView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 60))
        let addfloor = UIButton.init(frame: CGRect(x: ScreenWidth/4,y: 10,width: ScreenWidth/2,height: 35))
        addfloor.backgroundColor = mainColor
        addfloor.layer.cornerRadius = 5.0
        addfloor.layer.masksToBounds = true
        addfloor.setTitle("添加楼层", for: UIControlState())
        addfloor.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addfloor.addTarget(self, action: #selector(CreatHomeViewController.handleRightItem(_:)), for: .touchUpInside)
        
        footerView.addSubview(addfloor)
        tableView.tableFooterView = footerView
        
        //提示
        let tipLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 30))
        tipLab.textAlignment = .center
        tipLab.textColor = UIColor.gray
        tipLab.text = "提示:点击可对名称进行修改,左滑可删除。"
        tipLab.backgroundColor = UIColor.groupTableViewBackground
        tipLab.font = UIFont.systemFont(ofSize: 14)
        
        tableView.tableHeaderView = tipLab
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreatHomeViewController.handleBack(_:)))
        
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floorArr = []
        roomDic = [String : [Building]]()
        dataSource = []
        updateRoomInfo { () -> () in
            
            self.getRoomInfoForCreate()
            self.tableView.reloadData()
        }
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
        print("------\(parameter["roomInfo"])")
        print("------\(parameter["floorInfo"])")
        BaseHttpService .sendRequestAccess(updatinfo, parameters: parameter as NSDictionary) { (back) -> () in
            // 更新一个版本号上传到服务器上面
            
            
            updateRoomInfo(complete: { () -> () in
                showMsg(msg: NSLocalizedString("保存成功", comment: ""));
                self.floorArr = []
                self.roomDic = [String : [Building]]()
                self.dataSource = []
                
                //老用户 普通添加
                if self.isSimple {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
                
                //新用户
                let addDeviceVC: AddDeviceViewController = AddDeviceViewController(nibName: "AddDeviceViewController", bundle: nil)
                addDeviceVC.setCompeletBlock { () -> () in
                    
                    
                    let indvc:WifiVC=WifiVC(nibName: "WifiVC", bundle: nil)
                    indvc.isFirst = true
                    indvc.hidesBottomBarWhenPushed=true
                    self.navigationController!.pushViewController(indvc, animated:true)
                    
//                    app.window!.rootViewController = TabbarC()
                }
                self.navigationController?.pushViewController(addDeviceVC, animated: true)
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let building = dataSource[indexPath.row]
        if building.isAddCell {
            let roomArr = roomDic[building.floor!.buildName]
            var build:Building?
            if roomArr!.count == 1{
                 build = Building(buildType: .buildRoom, buildName: NSLocalizedString("房间", comment: ""), isAddCell: false)
            }else {
                 build = Building(buildType: .buildRoom, buildName: "\(roomArr![roomArr!.count-2].buildName)_1", isAddCell: false)
            }
          
            build!.floor = building.floor
            roomDic[building.floor!.buildName]?.insert(build!, at: (roomDic[building.floor!.buildName]?.endIndex)! - 1)
            dataSource.insert(build!, at: indexPath.row)
//            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let building = dataSource[indexPath.row]
        if building.buildType == BuildType.buildRoom
        {
            return 45
        }else{
            return 56
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return NSLocalizedString("删除", comment: "")
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if dataSource.count == 0{
            return
        }
        let building = dataSource[indexPath.row]
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
