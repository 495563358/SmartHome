//
//  SensorViewController.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/13.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class SensorVerification: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var equip:Equip?
    var homeTableView:UITableView!
    var flagStr:String? = ""
    var  model:SensorModel?
    
    let scalew = ScreenWidth / 320
    let scaleh = ScreenHeight / 568
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "情景面板对码"
        
        self.homeTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50*self.scaleh), style: UITableViewStyle.plain)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        self.view.addSubview(homeTableView)
        
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    func initView(){
        let space = UIView.init(frame: CGRect(x: 0, y: 50*self.scaleh, width: ScreenWidth, height: 10))
        space.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        self.view.addSubview(space)
        
        let imgV = UIImageView.init(frame: CGRect(x: ScreenWidth/2-100, y: 75+10, width: 200, height: 200))
        imgV.image = UIImage(named: "qingjingDM")
        self.view.addSubview(imgV)
        imgV.contentMode = .scaleAspectFit
        
        let textL = UILabel.init(frame: CGRect(x: 10, y: 305, width: ScreenWidth - 20, height: ScreenHeight - 454))
        textL.font = UIFont.systemFont(ofSize: 14)
        textL.numberOfLines = 0
        
        textL.text = "    方法1：点击学习，主机会发出di一声然后用手指触动情景面板按键，指示灯亮一下，主机再di一声，对码成功。\n    方法2：按住接收信号面板按键（根据开关或窗帘对码说明书），点击情景面板按键发送信号，接受面板指示灯亮一下，对码成功。"
        self.view.addSubview(textL)
        
        
        
        let nextStep = UIButton.init(frame: CGRect(x: (ScreenWidth - 192)/2, y: ScreenHeight - 145, width: 192, height: 45))
        nextStep.backgroundColor = systemColor
        nextStep.layer.cornerRadius = 10
        nextStep.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStep.setTitle("完成", for: UIControlState())
        nextStep.addTarget(self, action: #selector(SensorVerification.handleRightItem), for: UIControlEvents.touchUpInside)
        self.view .addSubview(nextStep)
    }
    
    @objc func handleRightItem(){
//        self.navigationController?.popToRootViewControllerAnimated(true)
        
        for temp in self.navigationController!.viewControllers {
            print("-------");
            if temp.isKind(of: SetSenViewControllerScene.classForCoder()) {
                self.navigationController?.popToViewController(temp , animated: true)
            }/*else if temp.isKindOfClass(MineVC.classForCoder()){
            self.navigationController?.popToViewController(temp , animated: true)
            }*/
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50*self.scaleh
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SetSenCelScene")
        if cell == nil {
            cell = SetSenCelScene.init(style: .default, reuseIdentifier: "SetSenCelScene")
        }
        (cell as! SetSenCelScene).model = model
        (cell as! SetSenCelScene).setinit()
        cell!.selectionStyle =  UITableViewCellSelectionStyle.none
        return cell!
    }
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let rowAction =   UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: NSLocalizedString("删除", comment: "")) { [unowned self](action, indexPath) -> Void in
//            let dic = ["deviceCode":self.model!.sensorhost,"deviceAddress":self.model!.SensorID,"patternType":"2"]
//            BaseHttpService.sendRequestAccess(deleteSensor, parameters: dic) { (arr) -> () in
//                self.modelArr.removeAtIndex(indexPath.row)
//                self.homeTableView?.reloadData()
//            }
//            print("删除")
//        }
//        let rowActionSec =   UITableViewRowAction(style: UITableViewRowActionStyle.Default, title:  NSLocalizedString("修改", comment: "")) { (action, indexPath) -> Void in
//            let sequipAddVC = SetsenAddVC()
//            let dic = ["deviceCode":self.model!.sensorhost,"deviceAddress":self.model!.SensorID,"patternType":"2"]
//            print(dic)
//            BaseHttpService.sendRequestAccess(gainAloneSensors, parameters: dic, success: { (arr) -> () in
//                print(arr)
//                BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) {(back) -> () in
//                    print(back)
//                    
//                    if(back.count <= 0)
//                    {
//                        showMsg(NSLocalizedString("请添加主机", comment: ""))
//                        return
//                    }else{
//                        let equip = Equip.init(equipID: arr["deviceAddress"] as! String)
//                        equip.name = arr["nickName"] as! String
//                        equip.type = arr["deviceType"] as! String
//                        equip.hostDeviceCode = arr["deviceCode"] as! String
//                        equip.num = arr["modelId"] as! String
//                        sequipAddVC.equip = equip
//                        sequipAddVC.isget = 1
//                        sequipAddVC.modelIdName = arr["modelName"] as! String
//                        sequipAddVC.deviceCodeName = arr["deviceNickName"] as! String
//                        sequipAddVC.deviceCodeIs = arr["status"] as! String
//                        self.navigationController?.pushViewController(sequipAddVC, animated:true)
//                    }
//                }
//                
//            })
//            
//            
//            print("修改")
//        }
//        rowActionSec.backgroundColor = UIColor.orangeColor()
//        return [rowAction,rowActionSec]
//        
//    }

}
