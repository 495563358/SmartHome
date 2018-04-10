//
//  SafesetTypeVC.swift
//  SmartHome
//
//  Created by Smart house on 2017/9/29.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class SafeTypeTVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //安防总开关
    var _btnSecurity:UIButton?
    var _labelSecurity:UIButton?
    var _SecuritySwift = "1"
    var tableView = UITableView.init(frame: CGRect(x: 0, y: -20, width: ScreenWidth, height: ScreenHeight + 20), style: UITableViewStyle.plain)
    
    let dataSource = [NSLocalizedString("安防设置", comment: ""),NSLocalizedString("情景面板", comment: ""),NSLocalizedString("摄像头管理", comment: "")]
    var roomCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("安防设备", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SafeTypeTVC.handleBack(_:)))
        let swipeGes = UISwipeGestureRecognizer.init(target: self, action: #selector(SafeTypeTVC.handleBack(_:)))
        swipeGes.direction = .right;
        self.view.addGestureRecognizer(swipeGes)
        
        addheaderView()
        self.view.addSubview(self.tableView)
        
        let backBtn = UIButton.init(frame: CGRect(x: 0, y: 25, width: 40, height: 40))
        backBtn.setImage(UIImage(named: "fanhui(b)"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(SafeTypeTVC.handleBack(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backBtn)
        
    }
    @objc func handleBack(_ barButton: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addheaderView(){
        let percent = ScreenWidth/375
        let backView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 208*percent+30))
        let blueBack = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 208*percent+20))
        backView.backgroundColor = UIColor.groupTableViewBackground
        blueBack.backgroundColor = systemColor
        backView.addSubview(blueBack)
        
        _btnSecurity = UIButton.init(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        _btnSecurity!.center = blueBack.center
        _btnSecurity!.setImage(UIImage(named: "bufang"), for:UIControlState())
        _btnSecurity!.setImage(UIImage(named: "chefang"), for:.selected)
        _btnSecurity!.addTarget(self, action: #selector(SafeTypeTVC.SecurityButtSwitch(_:)), for: .touchUpInside)
        backView.addSubview(_btnSecurity!)
        
        _labelSecurity = UIButton.init(frame: CGRect(x: 50, y: _btnSecurity!.y + 140, width: ScreenWidth - 100, height: 20))
        _labelSecurity?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _labelSecurity?.setTitle("已布防", for: UIControlState())
        _labelSecurity?.setTitle("已撤防", for: .selected)
        backView.addSubview(_labelSecurity!)
        
        self.tableView.tableHeaderView = backView
    }
    
    @objc func SecurityButtSwitch(_ but:UIButton){
        //securityTotalSwitch gainSecurityTotalSwitch
        
        if self._SecuritySwift == "1"
        {
            self._SecuritySwift = "0"
            self._btnSecurity!.isSelected = true
            self._labelSecurity!.isSelected = true
        }else
        {
            self._SecuritySwift = "1"
            self._btnSecurity!.isSelected = false
            self._labelSecurity!.isSelected = false
        }
        
        BaseHttpService.sendRequestAccess(securityTotalSwitch, parameters: ["securityType":self._SecuritySwift]) { (arr) -> () in
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        BaseHttpService.sendRequestAccess(gainSecurityTotalSwitch, parameters: [:]) {[unowned self] (arr) -> () in
            print(arr)
            self._SecuritySwift = arr["securityTotalSwitch"] as! String
            if self._SecuritySwift == "1"
            {
                self._btnSecurity!.isSelected = false
                self._labelSecurity!.isSelected = false
            }else
            {
                self._btnSecurity!.isSelected = true
                self._labelSecurity!.isSelected = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (dataSource.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if BaseHttpService.GetAccountOperationType() == "2"{
            showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
            return
        }
        switch(indexPath.row){
        case 0:
            let setVC = SetSenViewController()
            self.navigationController?.pushViewController(setVC, animated: true)
            break
        case 1:
            let qjsetVC = SetSenViewControllerScene()
            self.navigationController?.pushViewController(qjsetVC, animated: true)
            break
        case 2:
            let camera = CameraManagerVC()

            var roomDict:NSMutableDictionary = NSMutableDictionary()
            let floorArr = dataDeal.getModels(type: .Floor) as! [Floor]
            for floor in floorArr {
                let roomArr = dataDeal.getRoomsByFloor(floor: floor)
                for room in roomArr {
                    roomDict.setValue(room.name, forKey: room.roomCode)
                }
            }

            let cameras:[Equip] = DataDeal.sharedDataDeal.searchAllSXTModel()

            camera.cameras = cameras
            camera.roomDict = roomDict

            self.navigationController?.pushViewController(camera, animated: true)
            break
        default:
            break
        }
    }
}


class ZnhomeHostTypeTVC: UITableViewController {
    
    let dataSource = [NSLocalizedString("主机管理", comment: ""),NSLocalizedString("配置WiFi", comment: "")]
    var roomCode:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("智能屋主机", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SafeTypeTVC.handleBack(_:)))
    }
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        //        for temp in self.navigationController!.viewControllers {
        //            if temp.isKindOfClass(HomeVC.classForCoder()) {
        //                self.navigationController?.popToViewController(temp , animated: true)
        //            }else if temp.isKindOfClass(MineVC.classForCoder()){
        //                self.navigationController?.popToViewController(temp , animated: true)
        //            }
        //        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (dataSource.count)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        }
        //            if indexPath.row == 2{
        //                cell?.textLabel?.text = "一键配置摄像头"
        //                cell?.textLabel?.font = UIFont.systemFontOfSize(14)
        //                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        //                return cell!
        //            }
        cell?.textLabel?.text = dataSource[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 1:
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
            //                let avView = AVsViewController()
            //                avView.hidesBottomBarWhenPushed = true
            //
            //                self.navigationController?.pushViewController(avView, animated: true)
            
            
            //---
            //                UIAlertController(title: "提示", message: "缓存大小为\(String(format: "%.2f", num) )M确定要清理吗?", preferredStyle: UIAlertControllerStyle.Alert)
            //
            //                let defaultAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default , handler: { (aa) -> Void in
            //                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            //                        let cachPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
            //
            //                        let files = NSFileManager.defaultManager().subpathsAtPath(cachPath )
            //                        for p in files!{
            //
            //                            let path = (cachPath as NSString).stringByAppendingPathComponent(p)
            //                            if NSFileManager.defaultManager().fileExistsAtPath(path){
            //                                do{
            //                                    try NSFileManager.defaultManager().removeItemAtPath(path)
            //                                }catch let error as NSError {
            //                                    print(error.localizedDescription)
            //                                }
            //                            }
            //                        }
            //                    })
            //                })
            //                alert.addAction(defaultAction)
            //                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (aaa) -> Void in
            //
            //                })
            //                alert.addAction(cancelAction)
            //                self.presentViewController(alert, animated: true, completion: nil)
            let indvc:WifiVC=WifiVC(nibName: "WifiVC", bundle: nil)
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
            break;
            //解绑主机
        case 0:
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
//            let indvc = DeviceManagerVC()
//            indvc.hidesBottomBarWhenPushed=true
//            self.navigationController!.pushViewController(indvc, animated:true)
            break
        default:
            break
        }
    }
}
