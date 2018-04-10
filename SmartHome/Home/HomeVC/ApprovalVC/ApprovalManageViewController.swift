//
//  ApprovalManageViewController.swift
//  SmartHome
//
//  Created by Smart house on 2018/3/6.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class ApprovalManageViewController: UITableViewController, UIGestureRecognizerDelegate{
    //房间数据
    var floorArr: [Building] = []
    var roomDic: [String : [Building]] = [String : [Building]]()
    var dataSource: [Building] = []
    
    //设备数据
    var cDataSource: [Equip] = []
    var tDic: [String : [Equip]] = [String : [Equip]]()
    var tDataSource: [FloorOrRoomOrEquip] = []
    
    var approvalUserData:[String] = []
    
    //情景数据
    var modelData = [EditChainModel]()
    
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
            })
            
            
        }
        
    }
    func getRoomInfoFotClassify(){
        print("移除")
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
                print("roomCode = \(room.roomCode)\t equip = \(equips)")
            }
        }
        
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
    
    //刷新数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floorArr = []
        roomDic = [String : [Building]]()
        dataSource = []
        updateRoomInfo { () -> () in
            
            self.getRoomInfoForCreate()
        }
        self.reloadClassifyDataSource()
        gainAuthorizeList()
        //刷新情景模式
        modelData.removeAll()
        for var temp in app.models{
            let model = EditChainModel()
            model.modelIcon = temp.modelIcon
            model.modelId = temp.modelId
            model.modelName = temp.modelName
            modelData.append(model)
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
            roomDic[floor.buildName] = roomArr
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "授权用户"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 1))
        footerView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = footerView
        
        let backBtn = UIButton.init(frame: CGRect(x: 0, y: 35, width: 40, height: 40))
        backBtn.setImage(UIImage(named: "fanhui(b)"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(ApprovalManageViewController.backClick), for: UIControlEvents.touchUpInside)
        
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
    }
    
    func gainAuthorizeList(){
        
        BaseHttpService.sendRequestAccess("\(baseUrl)gainAuthorizeList.action", parameters: [:]) {[unowned self] (any) -> () in
            print("获取授权列表 = \(any)")
            self.approvalUserData.removeAll()
            if any.count == 0{
                return
            }
            for var i in 0...any.count-1{
                self.approvalUserData.append(((any as! NSArray)[i] as! NSDictionary)["userPhone"] as! String)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        return approvalUserData.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if indexPath.section == 0{
            cell.textLabel?.textColor = systemColor
            cell.textLabel?.text = "添加授权"
        }else{
            if indexPath.row == 0{
                cell.textLabel?.textColor = systemColor
                cell.textLabel?.text = "已授权用户"
            }else{
                cell.textLabel?.text = self.approvalUserData[indexPath.row - 1]
//                cell.textLabel?.textColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1.0)
            }
        }
        
        if (indexPath.section != 1 || indexPath.row != 0){
            cell.accessoryType = .disclosureIndicator
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //添加授权
            let vc = ApprovalNewuserViewController()
            vc.isNewuser = true
            vc.tDataSource = tDataSource
            vc.dataSource = dataSource
            vc.tDic = tDic
            vc.modelData = modelData
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        //编辑已授权的用户
        else if(indexPath.row > 0 && indexPath.section > 0){
            
            let dic = ["userPhone":self.approvalUserData[indexPath.row - 1]]
            
            BaseHttpService.sendRequestAccessAndBackall(authorizeDevice, parameters: dic as NSDictionary) { (backInfo) -> () in
                
                print("房间数据\(self.dataSource)")
                let data = backInfo["data"]
                
                var modeldataArr = [String]()
                
                //如果不为空 添加授权过的情景模式
                if (backInfo["modelIds"]! as AnyObject).isEqual(NSNull()) == false{
                    modeldataArr = backInfo["modelIds"] as! [String]
                }
                
                var accountOperationType:Int = 2
                if ((backInfo as! [String:Any])["accountOperationType"] != nil){
                    accountOperationType = Int((backInfo["accountOperationType"] as! NSString).intValue)
                }
                
                for var model in self.modelData{
                    for var modelId in modeldataArr{
                        if model.modelId == modelId{
                            model.isApproval = true
                        }
                    }
                }
                
                
                //处理房间数据
                var tempArr = [String]()
                for var equipInfo in(data as! [Dictionary<String, Any>]){
                    if (equipInfo["roomCode"] != nil){
                        tempArr.append(equipInfo["roomCode"] as! String)
                    }
                }
                
                //如果是普通用户就处理房间信息 管理员直接跳过
                if accountOperationType == 2{
                    //去掉重复的房间
                    let set = NSSet.init(array: tempArr)
                    //修改房间权限
                    var flag:Bool = false
                    for var building in self.dataSource{
                        if building.buildType == .buildRoom{
                            flag = false
                            for var temp in set{
                                if (temp as! String) == building.buildCode{
                                    flag = true
                                }
                            }
                            building.isApproval = flag
                            print("房间名 = \(building.buildName) = \(building.isApproval)")
                        }
                    }
//                    print(self.tDic)
                    //修改设备权限
                    for var temp in set{
                        print(temp as! String)
                        //获取字典中的设备数据
                        if (self.tDic[temp as! String] != nil){
                            var equips = self.tDic[temp as! String]
                            print(equips as Any)
                            for var equip in equips!{
                                equip.isApproval = false
                            }
                            //遍历网络请求的所有设备
                            for var equipInfo in (data as! [Dictionary<String, Any>]){
                                
                                if equipInfo["roomCode"] as! String == temp as! String{
                                    if equipInfo["isAuthorited"] as! String == "1"{
                                        
                                        for var equip in equips!{
                                            //将字典中的对应设备授权更改
                                            dump(equip)
                                            print("\n\n\(equipInfo["deviceAddress"]!) --- \(equip.equipID)\n\n")
                                            if equip.equipID == equipInfo["deviceAddress"] as! String{
                                                equip.isApproval = true
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                }
                
                //管理已经授权的用户
                let vc = ApprovalNewuserViewController()
                vc.isNewuser = false
                vc.tDataSource = self.tDataSource
                vc.dataSource = self.dataSource
                vc.tDic = self.tDic
                vc.accountOperationType = accountOperationType
                vc.userNum = self.approvalUserData[indexPath.row - 1] as NSString
                vc.modelData = self.modelData
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 5
        }
        return 0.01
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
