//
//  SetSenViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/6/23.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SetSenViewControllerScene: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var  model:SensorModel?
    var tableView:UITableView?
    let sunData = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
    var modelArr:[SensorModel] = []
    let scalew = ScreenWidth / 320
    let scaleh = ScreenHeight / 568
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("情景面板", comment: "")
        // Do any additional setup after loading the view.
        let but = UIBarButtonItem(image: UIImage(named: "添加房间"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SetSenViewControllerScene.handleBack(_:)))
        
        self.navigationItem.rightBarButtonItem = but
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SetSenViewControllerScene.backClick))
        let swipeGes = UISwipeGestureRecognizer.init(target: self, action: #selector(SetSenViewControllerScene.backClick))
        swipeGes.direction = .right
        
        self.view = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height-64))
        tableView!.delegate = self
        tableView!.dataSource = self
        //tableView!.separatorStyle = .None;
        tableView!.tableFooterView=UIView()
        //self.tableView?.registerClass(SetSenCell.classForCoder(), forHeaderFooterViewReuseIdentifier: "SetSenCell")
        self.view.addSubview(tableView!)
        self.view.addGestureRecognizer(swipeGes)
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        analysis()
    }
    
    func analysis(){
        self.modelArr = []
        BaseHttpService.sendRequestAccess(gainSensor, parameters: ["patternType":"2"]) {[unowned self] (data) -> () in
            print(data)
            
            if data.count == 0{
                return
            }
            
            for var i in 0...data.count-1
            {
                let dataDict = (data as! NSArray)[i] as! NSDictionary
                self.model = SensorModel.init(deviceCode: dataDict["deviceCode"] as! String, deviceAddress: dataDict["deviceAddress"] as! String, nickName: dataDict["nickName"] as! String, start1: dataDict["No.1"] as! String, start2: dataDict["No.2"] as! String, start3: dataDict["No.3"] as! String, deviceType: dataDict["deviceType"] as! String, securityType: dataDict["securityType"] as! String,sensorstate:"")
                self.modelArr.append(self.model!)
                self.tableView?.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50*self.scaleh
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SetSenCelScene")
        if cell == nil {
            cell = SetSenCelScene.init(style: .default, reuseIdentifier: "SetSenCelScene")
        }
        (cell as! SetSenCelScene).model = modelArr[indexPath.row]
        (cell as! SetSenCelScene).setinit()
        cell!.selectionStyle =  UITableViewCellSelectionStyle.none
        return cell!
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("删除", comment: "")) { [unowned self](action, indexPath) -> Void in
            let dic = ["deviceCode":self.modelArr[indexPath.row].sensorhost,"deviceAddress":self.modelArr[indexPath.row].SensorID,"patternType":"2"]
            BaseHttpService.sendRequestAccess(deleteSensor, parameters: dic as NSDictionary) { (arr) -> () in
                self.modelArr.remove(at: indexPath.row)
                self.tableView?.reloadData()
            }
            print("删除")
        }
        let rowActionSec =   UITableViewRowAction(style: UITableViewRowActionStyle.default, title:  NSLocalizedString("修改", comment: "")) { (action, indexPath) -> Void in
            let sequipAddVC = SetsenAddVC()
            let dic = ["deviceCode":self.modelArr[indexPath.row].sensorhost,"deviceAddress":self.modelArr[indexPath.row].SensorID,"patternType":"2"]
            print(dic)
            BaseHttpService.sendRequestAccess(gainAloneSensors, parameters: dic as NSDictionary, success: { (arr) -> () in
                print(arr)
                BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) {(back) -> () in
                    print(back)
                    
                    if(back.count <= 0)
                    {
                        showMsg(msg: NSLocalizedString("请添加主机", comment: ""))
                        return
                    }else{
                        let equip = Equip.init(equipID: arr["deviceAddress"] as! String)
                        equip.name = arr["nickName"] as! String
                        equip.type = arr["deviceType"] as! String
                        equip.hostDeviceCode = arr["deviceCode"] as! String
                        equip.num = arr["modelId"] as! String
                        sequipAddVC.equip = equip
                        sequipAddVC.isget = 1
                        sequipAddVC.modelIdName = arr["modelName"] as! String
                        sequipAddVC.deviceCodeName = arr["deviceNickName"] as! String
                        sequipAddVC.deviceCodeIs = arr["status"] as! String
                        self.navigationController?.pushViewController(sequipAddVC, animated:true)
                    }
                }
  
            })
            
            
            print("修改")
        }
        rowActionSec.backgroundColor = UIColor.orange
        return [rowAction,rowActionSec]
        
    }

    

    @objc func handleBack(_ barButton: UIBarButtonItem) {
        BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) {(back) -> () in
            print(back)
            
            if(back.count <= 0)
            {
                showMsg(msg: NSLocalizedString("请添加主机", comment: ""))
                return
            }else{
                let sequipAddVC = SetsenAddVC()
                //sequipAddVC.equip = Equip(equipID: "\(arc4random_uniform(60000))") //"\(arc4random_uniform(60000))"
                sequipAddVC.equip = Equip(equipID: "")
                sequipAddVC.NameText = NSLocalizedString("添加设备", comment: "")
                sequipAddVC.equip?.type = "315"
                sequipAddVC.isget = 0
                self.navigationController?.pushViewController(sequipAddVC, animated:true)
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
