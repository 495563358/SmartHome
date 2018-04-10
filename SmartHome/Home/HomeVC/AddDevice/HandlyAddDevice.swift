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
    let _namesArr = ["灯光开关","智能门锁","摄像头","窗帘开关","窗帘电机","卷帘开关","排风扇","插座","空调","电视","热水器","调光开关","智能晾衣架","电动门窗","电动升降架","电动幕布","影音设备","空气净化器","净水机","水管阀门","燃气阀门","浇花灌溉"]
    let _imagesArr:[String] = ["普通灯泡","智能门锁","摄像头","窗帘","窗帘电机","卷帘","排风扇","插座","挂式空调","电视","热水器","调光灯泡","智能晾衣架","电动门窗","电动升降架","电动幕布","影音设备","空气净化器","净水机","阀门","电磁阀","浇花灌溉"]
    
//    ["0灯光开关","1智能门锁","2摄像头","3窗帘开关","4窗帘电机","5卷帘开关","6排风扇","7插座","8空调","9电视","10热水器","11调光开关","12智能晾衣架","13电动门窗","14电动升降架","15电动幕布","16影音设备","17空气净化器","18净水机","19水管阀门","20燃气阀门","21浇花灌溉"]
    
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
        case 8://电视 空调 影音设备
            let automatic = AutomaticDevice(nibName: "AutomaticDevice", bundle: nil)
            automatic.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(automatic, animated: true)
            break
        case 9:
            let automatic = AutomaticDevice(nibName: "AutomaticDevice", bundle: nil)
            automatic.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(automatic, animated: true)
            break
        case 16:
            let automatic = AutomaticDevice(nibName: "AutomaticDevice", bundle: nil)
            automatic.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(automatic, animated: true)
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
    
}
