//
//  HandlyAddDevice.swift
//  SmartHome
//
//  Created by Smart house on 2017/11/27.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class HandlyAddDevice: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let _tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), style: UITableViewStyle.plain)
    let _namesArr = ["灯光开关","智能门锁","摄像头","窗帘开关","窗帘电机","卷帘开关","排风扇","插座","空调","电视","热水器","调光开关","变色灯","智能晾衣架","电动门窗","电动升降架","电动幕布","影音设备","空气净化器","净水机","水管阀门","燃气阀门","浇花灌溉"]
    let _imagesArr:[String] = ["普通灯泡","智能门锁","摄像头","窗帘","窗帘电机","卷帘","排风扇","插座","挂式空调","电视","热水器","调光灯泡","变色灯","智能晾衣架","电动门窗","电动升降架","电动幕布","影音设备","空气净化器","净水机","阀门","电磁阀","浇花灌溉"]
    
//    ["0灯光开关","1智能门锁","2摄像头","3窗帘开关","4窗帘电机","5卷帘开关","6排风扇","7插座","8空调","9电视","10热水器","11调光开关","12智能晾衣架","13电动门窗","14电动升降架","15电动幕布","16影音设备","17空气净化器","18净水机","19水管阀门","20燃气阀门","21浇花灌溉"]
    
    var infraredEquip:Equip = Equip(equipID: "infrared")
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "添加设备"
        _tableview.delegate = self
        _tableview.dataSource = self
        self.view .addSubview(_tableview)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HandlyAddDevice.backClick))
        
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _namesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "pool")
        if (cell == nil){
            cell = DeveiceCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "pool")
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        let devcell = cell as! DeveiceCell
        
        devcell.titleLab.text = _namesArr[indexPath.row]
        devcell.centerImg = UIImageView.init(image:UIImage(named: _imagesArr[indexPath.row]))
        devcell.centerImg.center = devcell.imageV.center
        
        devcell.imageV.frame = devcell.centerImg.frame
        devcell.imageV.image = devcell.centerImg.image
        
        return devcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 2://摄像头
            let cameraType = CameraTypeTVC();
            cameraType.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(cameraType, animated: true)
            break
        case 8://空调 电视 变色灯 影音设备
            self.searchInfraredDevice(type: 8)
            break
        case 9:
            self.searchInfraredDevice(type: 9)
            break
        case 12:
            self.searchInfraredDevice(type: 12)
            break
        case 17:
            self.searchInfraredDevice(type: 17)
            break
        default:
            let vc = DeviceTypechoose()
            vc.index = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // 搜索红外设备
    func searchInfraredDevice(type:NSInteger){
        
        if numtimer == 0{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HandlyAddDevice.timerDown), userInfo: nil, repeats: true)
            BaseHttpService.sendRequestAccess(quickscanhost, parameters: [:]) { (data) -> () in
                
            }
            print("查询了。。。。。。")
        }
        
        BaseHttpService.sendRequestAccess(unclassifyEquip_do, parameters: [:]) { (data) -> () in
            if data.count <= 0{
                //                self.infraredEquip = nil
                return
            }
            
            let arr = data as! [[String : AnyObject]]
            print(arr)
            print("aaaaaa---\(arr.count)")
            for e in arr {
                let deviceAddress = e["deviceAddress"] as! String as NSString
                if (deviceAddress.range(of: "65535,").location != NSNotFound){
                    let equip = Equip(equipID: e["deviceAddress"] as! String)
                    equip.userCode = e["userCode"] as! String
                    equip.type = e["deviceType"] as! String
                    equip.num  = e["deviceNum"] as! String
                    equip.hostDeviceCode = e["deviceCode"] as! String
                    equip.icon  = self._imagesArr[type]
                    
                    if equip.icon == ""{
                        equip.icon = getIconByType(type: equip.type)
                    }
                    self.infraredEquip = equip
                    
                    var typeName = "空调"
                    switch type{
                    case 9:
                        typeName = "电视"
                        break
                    case 12:
                        typeName = "变色灯"
                        break
                    case 17:
                        typeName = "背景音乐"
                    default:
                        break
                    }
                    
                    self.addInfraredDevice(type: typeName)
                    
                    return
                }
                
            }
            showMsg(msg: "没有搜索到可供添加的设备")
        }
        
    }
    
    func addInfraredDevice(type:String){
        let equipSetVC = EquipSetVC(nibName: "EquipSetVC", bundle: nil)
        equipSetVC.ifshot = "1"
        equipSetVC.equip = self.infraredEquip
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
                
                if type == "电视"{
                    let cell = NormalTVTableViewCell()
                    cell.index = 0
                    cell.equip = self.infraredEquip
                    cell.detajson({[unowned self] () -> () in
                        showMsg(msg: "添加成功了")
                        equipSetVC.navigationController?.popViewController(animated: true)
                    })
                }else if type == "空调"{
                    let cell = NormalACTableViewCell()
                    cell.index = 0
                    cell.equip = self.infraredEquip
                    cell.detajson({[unowned self] () -> () in
                        showMsg(msg: "添加成功了")
                        equipSetVC.navigationController?.popViewController(animated: true)
                    })
                }else if type == "变色灯"{
                    let cell = NormalColorLampTableViewCell()
                    cell.index = 0
                    cell.equip = self.infraredEquip
                    cell.detajson({[unowned self] () -> () in
                        showMsg(msg: "添加成功了")
                        equipSetVC.navigationController?.popViewController(animated: true)
                    })
                }
                else if type == "背景音乐"{
                    let cell = NormalBMTableViewCell()
                    cell.index = 0
                    cell.equip = self.infraredEquip
                    cell.detajson({[unowned self] () -> () in
                        showMsg(msg: "添加成功了")
                        equipSetVC.navigationController?.popViewController(animated: true)
                    })
                }
            })
        })
        self.navigationController?.pushViewController(equipSetVC, animated: true)
    }
    
}
