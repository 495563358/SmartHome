//
//  MainDeviceManager.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MainDeviceManager: UITableViewController {
    var roomCode:String?
    var arr1 = [String]()
    var arr2 = [String]()
    var arr3 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = NSLocalizedString("主机管理", comment: "")
        self.navigationItem.title=NSLocalizedString("主机管理", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = UIView()
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainDeviceManager.handleBack(_:)))
        
    }
    
    //退到首页
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        BaseHttpService .sendRequestAccess(getallhost_do, parameters:[:]) { (response) -> () in
            print(response)
            if response.count == 0{
                let alert = UIAlertView(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("您还没添加主机", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("我知道了", comment: ""))
                alert.tag = 2
                alert.show()
            }else{
               
               self.arr1.removeAll()
               self.arr2.removeAll()
                self.arr3.removeAll()
                for dic in (response as![[String:String]])
                {
                    print(dic)
                    self.arr2.append(dic["deviceCode"]!)
                    let ns1 = dic["deviceCode"]!.index(dic["deviceCode"]!.startIndex, offsetBy: 18)
                    let s1:String=dic["deviceCode"]!.substring(from: ns1)
                    print(s1)
                    if dic["status"]! == "1"{
                        self.arr1.append( dic["nickName"]!)
                        
                        self.arr3.append("(" + s1 +  ") \t " + NSLocalizedString("在线", comment: ""))
                    }else{
                        self.arr1.append(dic["nickName"]!)
                        self.arr3.append("(" + s1 +  ") \t " + NSLocalizedString("离线", comment: ""))
                     
                    }
                    
                }
                self.tableView.reloadData()
            }
        }

    }
    
    @objc func addDevice(){
        let addDeviceVC: AddDeviceViewController = AddDeviceViewController(nibName: "AddDeviceViewController", bundle: nil)
        addDeviceVC.tiaoint = 1
        addDeviceVC.setCompeletBlock { [unowned self]() -> () in
            
//            self.navigationController?.popToRootViewControllerAnimated(true)
            let indvc:WifiVC=WifiVC(nibName: "WifiVC", bundle: nil)
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
        }
        self.navigationController?.pushViewController(addDeviceVC, animated: true)
    
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
            return 2
        }
        return arr1.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section==0{
            return 10
        }
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuseIdentifier")
        }
        
        if indexPath.section == 0{
            let names:[String] = ["添加主机","配置WIFI"]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.text = names[indexPath.row]
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell!
        }
        
        cell?.textLabel?.text = self.arr1[indexPath.row]
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.detailTextLabel?.text = self.arr3[indexPath.row]
         cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section>0{
            return
        }
        if BaseHttpService.GetAccountOperationType() == "2"{
            showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
            return
        }
        switch(indexPath.row){
        case 0:
            self.addDevice()
            break
        case 1:
            let indvc:WifiVC=WifiVC(nibName: "WifiVC", bundle: nil)
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        

        let rowAction =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("删除", comment: "")) { (action, indexPath) -> Void in
            let alertController = UIAlertController(title: NSLocalizedString("提示", comment: ""),
                message: NSLocalizedString("确定删除主机", comment: ""), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: NSLocalizedString("好的",comment:""), style: .default,
                handler: {
                    action in
                    print("点击了确定")
            
            let parameters=["deviceCode":self.arr2[indexPath.row]]
                    BaseHttpService.sendRequestAccess(Dele_tallhost, parameters:parameters as NSDictionary) { [unowned dataDeal] (response) -> () in
                //
                dataDeal.clearEquipTable()
                print("----0.0----")
                self.refreshEquipData()
                self.arr1.remove(at: indexPath.row)
                self.arr2.remove(at: indexPath.row)
                self.tableView.reloadData()
                //
            }
            print("删除")
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
                
        let rowActionSec =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("修改", comment: "")) { (action, indexPath) -> Void in
            let HosetView = HostSetViewController()
            HosetView.shotID = self.arr2[indexPath.row]
            HosetView.hostName = self.arr1[indexPath.row]
            self.navigationController?.pushViewController(HosetView, animated: true)
            // to do here
            print("修改")
        }
        rowActionSec.backgroundColor = UIColor.orange

        
        return [rowAction,rowActionSec]
        
    }
    

    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
    }
    func  refreshEquipData(){
        
        BaseHttpService.sendRequestAccess(classifyEquip_do, parameters: ["userPhone":BaseHttpService.getUserPhoneType()]) { (data) -> () in
            print(data)
            
            if data.count != 0{
                let arr = data as! [[String : AnyObject]]
                for e in arr {
                    let equip = Equip(equipID: e["deviceAddress"] as! String)
                    equip.name = e["nickName"] as! String
                    equip.roomCode = e["roomCode"] as! String
                    equip.userCode = e["userCode"] as! String
                    equip.type = e["deviceType"] as! String
                    equip.num  = e["deviceNum"] as! String
                    equip.icon  = e["icon"] as! String
                    equip.hostDeviceCode = e["deviceCode"] == nil ? "" : e["deviceCode"] as!String
                    equip.num  =  e["validationCode"] == nil ? "" : e["validationCode"]as!String
                    if equip.icon == ""{
                        equip.icon = getIconByType(type: equip.type)
                    }
                    equip.saveEquip()
                    
                }
            }
            
            
        }
    }
}

