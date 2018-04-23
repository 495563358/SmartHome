//
//  DeviceTypechoose.swift
//  SmartHome
//
//  Created by Smart house on 2017/11/27.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class DeviceTypechoose: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var index:Int = 0
    
    lazy var namesMarr : NSArray = {
        
        let name1 = ["315智能开关","433智能开关","ZigBee智能开关"]
        let name2 = ["智能屋智能门锁","ZigBee智能门锁"]
        let name3 = ["摄像头"]
        let name4 = ["315窗帘开关","433窗帘开关","315双轨窗帘开关","433双轨窗帘开关"]
        let name5 = ["窗帘电机","ZigBee窗帘电机"]
        let name6 = ["315卷帘开关","433卷帘开关"]
        let name7 = ["315排风扇开关","433排风扇开关"]
        let name8 = ["315智能插座","433智能插座","315智能插排","433智能插排"]
        let name9 = ["空调"]
        let name10 = ["电视"]
        let name11 = ["315热水器开关","433热水器开关"]
        let name12 = ["315调光开关","433调光开关","ZigBee调光开关"]
        let name13 = ["变色灯"]
        let name14 = ["315智能晾衣架","433智能晾衣架"]
        let name15 = ["315电动门窗","433电动门窗"]
        let name16 = ["315电动升降架","433电动升降架"]
        let name17 = ["315电动幕布","电动幕布"]
        let name18 = ["影音设备"]
        let name19 = ["315空气净化器","433空气净化器"]
        let name20 = ["315净水机","433净水机"]
        
        let name21 = ["315水管阀门","433水管阀门"]
        let name22 = ["315燃气阀门","433燃气阀门"]
        
        //9 电视 10 空调
        let name23 = ["315浇花灌溉开关","433浇花灌溉开关"]
        
        var namesMarr = [name1,name2,name3,name4,name5,name6,name7,name8,name9,name10,name11,name12,name13,name14,name15,name16,name17,name18,name19,name20,name21,name22,name23]
        
        return namesMarr as NSArray
    }()
    
    
    let _tableview = UITableView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), style: UITableViewStyle.grouped)
    
    var _namesArr:[String] = []
    let _imagesArr:[String] = ["普通灯泡","智能门锁","摄像头","窗帘","窗帘电机","卷帘","排风扇","插座","挂式空调","电视","热水器","调光灯泡","变色灯","智能晾衣架","电动门窗","电动升降架","电动幕布","影音设备","空气净化器","净水机","阀门","电磁阀","浇花灌溉"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _namesArr = namesMarr[index] as! [String]
        self.navigationItem.title = ["灯光开关","智能门锁","摄像头","窗帘开关","窗帘电机","卷帘开关","排风扇","插座","空调","电视","热水器","调光开关","变色灯","智能晾衣架","电动门窗","电动升降架","电动幕布","影音设备","空气净化器","净水机","水管阀门","燃气阀门","浇花灌溉"][index]
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
        self.view .addSubview(_tableview)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (namesMarr[index] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.imageView?.image = UIImage(named: _imagesArr[index])
        cell?.textLabel?.text = _namesArr[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let equipAddVC = AddDevicetoRoom()
        equipAddVC.equip = Equip(equipID: randomCode())
        equipAddVC.equip?.num = "1"
        equipAddVC.equip?.icon = _imagesArr[index]
        equipAddVC.NameText = NSLocalizedString("添加设备", comment: "")
        equipAddVC.indexNum = self.index
        
        var typeNum:Int = index
        switch index{
        case 0://灯光开关
            typeNum = 1
            break
        case 3://窗帘开关
            typeNum = 3
            break
        case 5://卷帘开关
            typeNum = 3
            break
        case 6://排风扇
            typeNum = 1
            break
        case 7://插座
            typeNum = 1
            break
        case 8://空调 ---------
            typeNum = 1
            break
        case 9://电视 ---------
            typeNum = 1
            break
        case 10://热水器
            typeNum = 1
            break
        case 11://调光
            typeNum = 2
            break
        case 12://变色灯
            typeNum = 1
            break
        case 13://智能晾衣架
            typeNum = 3
            break
        case 14://门窗
            typeNum = 3
            break
        case 15://升降架
            typeNum = 3
            break
        case 16://电动幕布
            typeNum = 3
            break
        case 18://空气净化器
            typeNum = 1
            break
        case 19://净水机
            typeNum = 1
            break
        case 20://水管
            typeNum = 1
            break
        case 21://燃气
            typeNum = 1
            break
        default:
            typeNum = 1
            break
        }
        
        equipAddVC.EquType = typeNum + 1
        
        //智能门锁
        if index == 1{
            if indexPath.row == 0{
                equipAddVC.equip?.type = "5314"
                self.navigationController?.pushViewController(equipAddVC, animated:true)
            }else{
                let equipAddVC = AddZigbeeDevice()
                equipAddVC.equip = Equip(equipID: randomCode())
                equipAddVC.NameText = NSLocalizedString("添加设备", comment: "")
                equipAddVC.EquType = indexPath.row
                equipAddVC.equip?.type = "5"
                equipAddVC.equip?.icon = _imagesArr[index]
                self.navigationController?.pushViewController(equipAddVC, animated:true)
            }
        }
        //窗帘电机
        else if index == 4{
            if indexPath.row == 0{
                equipAddVC.equip?.type = "4304"
                self.navigationController?.pushViewController(equipAddVC, animated:true)
            }else{
                let equipAddVC = AddZigbeeDevice()
                equipAddVC.equip = Equip(equipID: randomCode())
                equipAddVC.NameText = NSLocalizedString("添加设备", comment: "")
                equipAddVC.EquType = indexPath.row
                equipAddVC.equip?.type = "3"
                equipAddVC.equip?.icon = _imagesArr[index]
                self.navigationController?.pushViewController(equipAddVC, animated:true)
            }
        }
        
        //插座
        else if index == 7{
            if (indexPath.row == 0||indexPath.row == 2){
                equipAddVC.equip?.type = "\(typeNum)114"
            }else{
                equipAddVC.equip?.type = "\(typeNum)124"
            }
            if indexPath.row > 1{
                equipAddVC.flagStr = "插排"
            }
            
            self.navigationController?.pushViewController(equipAddVC, animated:true)
        }
        
        //窗帘
        else if index == 3{
            if (indexPath.row == 0||indexPath.row == 2){
                equipAddVC.equip?.type = "\(typeNum)114"
            }else{
                equipAddVC.equip?.type = "\(typeNum)124"
            }
            if indexPath.row > 1{
                equipAddVC.flagStr = "双轨窗帘"
            }
            
            self.navigationController?.pushViewController(equipAddVC, animated:true)
        }
        //其他类型  1 2多一个ZigBee
        else{
            
            switch indexPath.row{
            case 0:
                equipAddVC.equip?.type = "\(typeNum)114"
                self.navigationController?.pushViewController(equipAddVC, animated:true)
                break
            case 1:
                equipAddVC.equip?.type = "\(typeNum)124"
                self.navigationController?.pushViewController(equipAddVC, animated:true)
                break
            default:
                let equipAddVC = AddZigbeeDevice()
                equipAddVC.equip = Equip(equipID: randomCode())
                equipAddVC.NameText = NSLocalizedString("添加设备", comment: "")
                equipAddVC.EquType = indexPath.row
                equipAddVC.equip?.type = "\(typeNum)"
                equipAddVC.equip?.icon = _imagesArr[index]
                self.navigationController?.pushViewController(equipAddVC, animated:true)
                break
            }
        }
        print("设备型号 = \(equipAddVC.equip?.type)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
