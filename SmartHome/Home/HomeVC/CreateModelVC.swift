//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

class CreateModelVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate{

    var isEdit = true
    var modelId = ""
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
    @IBOutlet var homeTableView: UITableView!
  
    var navTitle = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configView()
        registerCell()
       //let but = UIBarButtonItem(title:"", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("leftbut"))
      //  but.image = UIImage.init(imageLiteralResourceName: "矢量智能对象")
      //self.navigationItem.leftBarButtonItem = but
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateModelVC.leftbut))
        let bbi_r3=UIBarButtonItem(title: NSLocalizedString("保存", comment: ""), style:UIBarButtonItemStyle.plain, target:self ,action:#selector(CreateModelVC.submit));
        bbi_r3.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItems = [bbi_r3]
        self.navigationItem.title = navTitle
    }
    @objc func leftbut(){
        let alert = UIAlertView(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("是否保存", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("确定", comment: ""), otherButtonTitles: NSLocalizedString("取消", comment: ""))
        alert.show()

    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0{
        print(0)
            print("\(getJsonStrOfDeviceData())")
            BaseHttpService.sendRequestAccess(addmodelinfo, parameters: ["modelInfo":getJsonStrOfDeviceData(),"modelId":self.modelId], success: { [unowned self](back) -> () in
                print(back)
                app.modelEquipArr.removeAllObjects()
                //self.navigationController?.popViewControllerAnimated(true)
                for temp in self.navigationController!.viewControllers {
                    if temp.isKind(of: HomeVC.classForCoder()) {
                        self.navigationController?.popToViewController(temp , animated: true)
                    }
                }
                })
        }else{
        print(1)
            //self.navigationController?.popViewControllerAnimated(true)
            for temp in self.navigationController!.viewControllers {
                if temp.isKind(of: HomeVC.classForCoder()) {
                    self.navigationController?.popToViewController(temp , animated: true)
                }
            }
        }
    }
    func registerCell(){
    
        
        self.homeTableView.register(UINib(nibName: "ModulateCell", bundle: nil), forCellReuseIdentifier: "ModulateCell")
      
         self.homeTableView.register(UINib(nibName: "UnkownCell", bundle: nil), forCellReuseIdentifier: "UnkownCell")
         self.homeTableView.register(UINib(nibName: "NoDeviceCell", bundle: nil), forCellReuseIdentifier: "NoDeviceCell")
       self.homeTableView.register(UINib(nibName: "LightCell", bundle: nil), forCellReuseIdentifier: "LightCell")
        self.homeTableView.register(UINib(nibName: "InfraredCell", bundle: nil), forCellReuseIdentifier: "InfraredCell")
        self.homeTableView.register(UINib(nibName: "ShotLightCell", bundle: nil), forCellReuseIdentifier: "ShotLightCell")
        self.homeTableView.register(UINib(nibName: "ShotWindowCell", bundle: nil), forCellReuseIdentifier: "ShotWindowCell")
        self.homeTableView.register(UINib(nibName: "ShotLockCell", bundle: nil), forCellReuseIdentifier: "ShotLockCell")
        
        self.homeTableView.register(UINib(nibName: "Modulate2Cell", bundle: nil), forCellReuseIdentifier: "Modulate2Cell")
        
        self.homeTableView.register(UINib(nibName: "boxCell", bundle: nil), forCellReuseIdentifier: "boxCell")
        self.homeTableView.register(UINib(nibName: "DuYaInModelCell", bundle: nil), forCellReuseIdentifier:"DuYaInModelCell" )
        
        self.homeTableView.register(UINib(nibName: "lockCell", bundle: nil), forCellReuseIdentifier:"lockCell" )
        
        self.homeTableView.register(UINib(nibName: "DuYaCell", bundle: nil), forCellReuseIdentifier:"DuYaCell" )
        self.homeTableView.register(UINib(nibName: "SmartLockCell", bundle: nil), forCellReuseIdentifier:"SmartLockCell" )
        
    }
    func configView(){

        app.modelEquipArr.removeAllObjects()
        BaseHttpService.sendRequestAccess(Get_gainmodelinfo, parameters: ["modelId":modelId]) { (backJson) -> () in
            print(backJson)
            self.homeTableView.reloadData()
            if backJson.count != 0{
                var isAll = true
                for mo in (backJson as! Array<Dictionary<String,AnyObject>>){
                    print("----\(mo["deviceAddress"]!)")
                    let eq1:Equip? =  dataDeal.searchModel(type: .Equip, byCode: mo["deviceAddress"]! as! String) as! Equip?
                    if eq1 != nil
                    {
                        let eq = Equip(equipID: (eq1?.equipID)!)
                        eq.name = eq1!.name
                        eq.userCode = eq1!.userCode
                        eq.roomCode = eq1!.roomCode
                        eq.type = eq1!.type
                        eq.icon  = eq1!.icon
                        eq.num = eq1!.num
                        eq.status = eq1!.status
                        eq.hostDeviceCode = eq1!.hostDeviceCode
                        eq.delay = mo["delayValues"]!.stringValue
                        eq.status = mo["controlCommand"]! as!String
                        app.modelEquipArr.add(eq)
                    
                    }else
                    {
                        isAll = false
                    }
                    
                }
                if !isAll{
                    BaseHttpService.sendRequestAccess(addmodelinfo, parameters: ["modelInfo":self.getJsonStrOfDeviceData(),"modelId":self.modelId], success: {(back) -> () in
                        print(back)
                            app.modelEquipArr.removeAllObjects()
                        showMsg(msg: "失效设备已移除")
                        })

                   
                }
                self.homeTableView.reloadData()
            }
            
            
        }

        
    }

    @IBAction func left(_ sender: AnyObject) {
        print("left")
        self.homeTableView.setEditing(false, animated: true)
      
    }
   

    @IBAction func right(_ sender: AnyObject) {
        print("right")
          self.homeTableView.setEditing(true, animated: true)
    
    }
    
    @objc func submit(){
       
        print("\(getJsonStrOfDeviceData())")
            BaseHttpService.sendRequestAccess(addmodelinfo, parameters: ["modelInfo":getJsonStrOfDeviceData(),"modelId":self.modelId], success: { (back) -> () in
                print(back)
                    app.modelEquipArr.removeAllObjects()
                            for temp in self.navigationController!.viewControllers {
                                if temp.isKind(of: HomeVC.classForCoder()) {
                                    self.navigationController?.popToViewController(temp , animated: true)
                                }
                            }
                showMsg(msg: NSLocalizedString("保存成功了!", comment: ""))
            })
            

    }

    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden  = false
//        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
     self.homeTableView.reloadData()
}
    
//[{'modelId':'abcdefgh','deviceAddress':'56194','deviceType':'2','controlCommand':'50','delayValues':'10'}]
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
    
        // MARK: - Table view data source
    //返回节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
       
      
        return 1
    }
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       
        return app.modelEquipArr.count + 1

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        var cell:UITableViewCell?
     
            if app.modelEquipArr.count ==  indexPath.row
            {
            
             cell = tableView.dequeueReusableCell(withIdentifier: "NoDeviceCell")
                  (cell as! NoDeviceCell).showLabel.text = NSLocalizedString("点击为情景模式添加设备", comment: "")
               // cell?.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!

            }
            let equip = app.modelEquipArr[indexPath.row] as! Equip
            if equip.type == "1"
            {//开关设备
                 cell = tableView.dequeueReusableCell(withIdentifier: "LightCell")
                
                 cell?.backgroundColor = UIColor.white
               
                (cell as! LightCell).isMoni = true
                (cell as! LightCell).index = indexPath
                (cell as! LightCell).setModel(equip)
                if indexPath.row == 0{
                    (cell as!LightCell).delayBtn.isHidden = true
                }
            }
        else
        if equip.type == "999"
        {//门锁
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ShotLockCell")
            
            cell?.backgroundColor = UIColor.white
            
            (cell as! ShotLockCell).isMoni = true
            (cell as! ShotLockCell).index = indexPath
            (cell as! ShotLockCell).setModel(equip)
            if indexPath.row == 0{
                (cell as!ShotLockCell).delayBtn.isHidden = true
            }
        }
        else if Int(equip.type) >= 1000 && Int(equip.type)<2000{
                cell = tableView.dequeueReusableCell(withIdentifier: "ShotLightCell")
                
                cell?.backgroundColor = UIColor.white
            
                (cell as! ShotLightCell).isMoni = true
                (cell as! ShotLightCell).index = indexPath
                (cell as! ShotLightCell).setModel(equip)
                if indexPath.row == 0{
                    (cell as!ShotLightCell).delayBtn.isHidden = true
                }
            }
                
        else if Int(equip.type) >= 3000 && Int(equip.type)<4000 {
                //开关停 窗帘
                
                cell = tableView.dequeueReusableCell(withIdentifier: "ShotWindowCell")
                cell?.backgroundColor = UIColor.white
            
                (cell as! ShotWindowCell).isMoni = true
                (cell as! ShotWindowCell).index = indexPath
                (cell as! ShotWindowCell).setModel(equip)
                if indexPath.row == 0{
                    (cell as!ShotWindowCell).delayBtn.isHidden = true
                }
            }
//        else if equip.type == "998"
//        {
//            //传感器
//            
//        }
            else if equip.type == "2" || equip.type == "4"/*||judgeType(equip.type, type: "2")*/
            {//可调设备
             cell = tableView.dequeueReusableCell(withIdentifier: "ModulateCell")
                 cell?.backgroundColor = UIColor.white
          
                (cell as! ModulateCell).isMoni = true
                 (cell as! ModulateCell).index = indexPath
                 (cell as! ModulateCell).setModel(equip)
                if indexPath.row == 0{
                    (cell as!ModulateCell).delayBtn.isHidden = true
                }
            }
        else if Int(equip.type) >= 2000 && Int(equip.type)<3000
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Modulate2Cell")
            cell?.backgroundColor = UIColor.white
            
            (cell as! Modulate2Cell).isMoni = true
            (cell as! Modulate2Cell).index = indexPath
            (cell as! Modulate2Cell).setModel(equip)
            if indexPath.row == 0{
                (cell as!Modulate2Cell).delayBtn.isHidden = true
            }
            
        }
        else if equip.type == "99" || equip.type == "98" /*|| equip.type == "500" || equip.type == "501"*/
            {//红外学习设备
                cell = tableView.dequeueReusableCell(withIdentifier: "InfraredCell")
                cell?.backgroundColor = UIColor.white
              
                (cell as! InfraredCell).isMoni = true
                (cell as! InfraredCell).index = indexPath
                (cell as! InfraredCell).setModel(equip)
                if indexPath.row == 0{
                    (cell as!InfraredCell).delayBtn.isHidden = true
                }
        }
        else if equip.type == "8" || equip.type == "32"
        {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "boxCell")
            cell?.backgroundColor = UIColor.white
            (cell as! boxCell).isMoni = true
            (cell as! boxCell).index = indexPath
            print(equip.hostDeviceCode)
            (cell as! boxCell).setModel(equip)
            if indexPath.row == 0{
                (cell as!boxCell).delayBtn.isHidden = true
            }
        }
        else if Int(equip.type) >= 4000 && Int(equip.type)<5000
        {
            //杜亚电机
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "DuYaInModelCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! DuYaInModelCell).isMoni = true
            (cell as! DuYaInModelCell).index = indexPath
            (cell as! DuYaInModelCell).setModel(equip)
            if indexPath.row == 0{
                (cell as! DuYaInModelCell).delayBtn.isHidden = true
            }
        }
//        else if Int(equip.type) >= 4000 && Int(equip.type)<5000
//        {
//            //杜亚电机
//            cell = self.homeTableView.dequeueReusableCellWithIdentifier("DuYaCell", forIndexPath: indexPath)
//            cell?.backgroundColor = UIColor.whiteColor()
//            
//            (cell as! DuYaCell).setModel(equip)
//        }
            
        else if Int(equip.type) == 5314
        {
            //杜亚电机
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "SmartLockCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! SmartLockCell).isMoni = true
            (cell as! SmartLockCell).index = indexPath
            (cell as! SmartLockCell).setModel(equip)
            if indexPath.row == 0{
                (cell as! SmartLockCell).delayBtn.isHidden = true
            }
            
        }
        else{
            print("未知设备");
            print(equip.type);
                cell = tableView.dequeueReusableCell(withIdentifier: "UnkownCell")
                 cell?.backgroundColor = UIColor.white
            
                //(cell as! UnkownCell).setModel(equip)
            
            
            }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    
    func judgeType(_ str:String,type:String)->Bool
   {
    if str.trimString() == ""
    {
    return false
    }
    let str1 = str as NSString

    return  str1.substring(to: 1) == type && str1.length == 4
    }
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点着了吗？？\(indexPath.row) == \(app.modelEquipArr.count)");
        if indexPath.row == app.modelEquipArr.count{
         let vc = ChoseDeviceForModel(nibName: "ChoseDeviceForModel", bundle: nil)
        vc.modelId = self.modelId
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
       //高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            if app.modelEquipArr.count  == indexPath.row{
            return  50
            }
            let equip = app.modelEquipArr[indexPath.row] as! Equip
        

            
            if equip.type == "1" || judgeType(equip.type, type: "1")
                
            {
                return 65
            }
            else if equip.type == "8" || equip.type == "32" || equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "3")||judgeType(equip.type, type: "2")
                
            {
                return 65
            }
            else if equip.type == "99" || equip.type == "98"
            {
                
                return 65
            }
            else if Int(equip.type) == 5314{
                return 65
            }else if Int(equip.type) >= 4000 && Int(equip.type)<5000
            {
                return 65
        }
            return 50
      
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0{
//        return 0.001
//        }
//        return 30
//    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        return view
//    }
    //手势识别
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return app.modelEquipArr.count != indexPath.row;
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return app.modelEquipArr.count != indexPath.row;
    }
    
    //cell点击事件
    //单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if app.modelEquipArr.count != indexPath.row{
          return UITableViewCellEditingStyle.delete
          //   return UITableViewCellEditingStyle(rawValue:UITableViewCellEditingStyle.Delete.rawValue|UITableViewCellEditingStyle.Insert.rawValue)!
        }else{
             return UITableViewCellEditingStyle.none
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    
        
      if  app.modelEquipArr.count > 0
      {
        let fromRow = sourceIndexPath.row;
        //    获取移动某处的位置
        var toRow = destinationIndexPath.row
        if toRow == app.modelEquipArr.count
        {
             toRow =  fromRow
        }
        //    从数组中读取需要移动行的数据
        let object = app.modelEquipArr[fromRow];
        //    在数组中移动需要移动的行的数据
        app.modelEquipArr.removeObject(at: fromRow)
        app.modelEquipArr.insert(object, at: toRow)
        tableView.reloadData();
        } //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
        
    }
 
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return NSLocalizedString("删除", comment: "")
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   
        if editingStyle == UITableViewCellEditingStyle.delete && app.modelEquipArr.count > 0
        {
            let row = indexPath.row
            app.modelEquipArr.removeObject(at: row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            tableView.reloadData();
        }
   
     
    }
    
 
   

    
}


