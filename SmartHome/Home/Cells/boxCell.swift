//
//  InfraredCell.swift
//  SmartHome
//
//  Created by sunzl on 16/5/9.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class boxCell: UITableViewCell,UIActionSheetDelegate {
    
    @IBOutlet weak var txtLabel: UIButton!
    @IBOutlet var name: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var delayBtn: UIButton!
    var index:IndexPath?
    var equip:Equip?
    var box:boxx?
    var isMoni:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.icon.contentMode = UIViewContentMode.scaleAspectFit
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(boxCell.longPress(_:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1.0
       // self.contentView.addGestureRecognizer(longPress)
        txtLabel.setTitle(NSLocalizedString("点击进入控制界面", comment: ""), for: UIControlState())
        
    }
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("删除", comment: ""))
            actionSheet?.show(in: self.superview!)
        }
    }
    
    //长按事件
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //取消
            break
        case 1:
            //删除
            let dic = ["deviceAddress":self.equip!.equipID,
                "deviceCode":self.equip!.hostDeviceCode]
            print(dic)
            BaseHttpService.sendRequestAccess(Dele_deleteinfraredbuttonses, parameters:dic as NSDictionary) { (response) -> () in
                print(response)

                
            }
            break
            
        default:
            break
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //闭包获取姓名

    func setModel(_ e:Equip){
        self.equip = e
        self.name.text = e.name
        self.icon.image = UIImage(named: e.icon)
        if isMoni
        {
        //情景界面
        self.delayBtn.isHidden = false
            var str = ""
            switch(self.equip!.delay){
            case "300":str = NSLocalizedString("立即执行", comment: "")//ms
                break
            case "600":str = "\(NSLocalizedString("延迟", comment: ""))0.5\(NSLocalizedString("秒", comment: ""))"
                break
            case "1000":str =  "\(NSLocalizedString("延迟", comment: ""))1\(NSLocalizedString("秒", comment: ""))"
                break
            case "2000":str =  "\(NSLocalizedString("延迟", comment: ""))2\(NSLocalizedString("秒", comment: ""))"
                break
            case "3000":str =  "\(NSLocalizedString("延迟", comment: ""))3\(NSLocalizedString("秒", comment: ""))"
                break
            case "4000":str =  "\(NSLocalizedString("延迟", comment: ""))4\(NSLocalizedString("秒", comment: ""))"
                break
            case "5000":str =  "\(NSLocalizedString("延迟", comment: ""))5\(NSLocalizedString("秒", comment: ""))"
                break
            case "10000":str =  "\(NSLocalizedString("延迟", comment: ""))10\(NSLocalizedString("秒", comment: ""))"
                break
            case "15000":str =  "\(NSLocalizedString("延迟", comment: ""))15\(NSLocalizedString("秒", comment: ""))"
                break
            case "30000":str =  "\(NSLocalizedString("延迟", comment: ""))30\(NSLocalizedString("秒", comment: ""))"
                break
            default:break
            }
            self.delayBtn.setTitle(str, for: UIControlState())
        //1 txtLabel显示的文字
            if e.status != ""{
                //e.status "1,name"
                
                let arrayStr = e.status.components(separatedBy: ",")
               let str = (arrayStr[2] == "1" ? NSLocalizedString("开", comment: "") : NSLocalizedString("关", comment: ""))
                self.txtLabel.setTitle(arrayStr[1]+","+str, for: UIControlState())
            }

        }else{
        //控制界面
        //1
        self.delayBtn.isHidden = true
        }
        
    }
    @IBAction func controlTap(_ sender: AnyObject) {
        
        if isMoni{
         print(["deviceCode":self.equip!.equipID,"deviceAddress":self.equip!.hostDeviceCode])   
         BaseHttpService.sendRequestAccess(gainControlEnclosure, parameters: ["deviceCode":self.equip!.hostDeviceCode,"deviceAddress":self.equip!.equipID], success: { (arr) -> () in
                let vc = BoxViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.isMoni = self.isMoni
                vc.equip = self.equip
                vc.indexqj = self.index
                for var i in 0...arr.count-1
                {
                    self.box = boxx()
                    self.box?.setvale(name: ((arr as! NSArray)[i] as! NSDictionary)["nickName"] as! String, stat: ((arr as! NSArray)[i] as! NSDictionary)["state"] as! String, id: ((arr as! NSArray)[i] as! NSDictionary)["deviceAddress"] as! String,deviceCode: self.equip!.hostDeviceCode)
                   vc.cDataSource.append(self.box!)
                }
                self.parentController()?.navigationController?.pushViewController(vc, animated: true)
            })
            

        }else{
            print(["deviceCode":self.equip!.equipID,"deviceAddress":self.equip!.hostDeviceCode])
            BaseHttpService.sendRequestAccess(gainControlEnclosure, parameters: ["deviceCode":self.equip!.hostDeviceCode,"deviceAddress":self.equip!.equipID], success: { (arr) -> () in
                let vc = BoxViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.isMoni = self.isMoni
                vc.equip = self.equip
                
                for var i in 0...arr.count-1
                {
                    self.box = boxx()
                    let boxDict = (arr as! NSArray)[i] as! NSDictionary
                    self.box?.setvale(name: boxDict["nickName"] as! String, stat: boxDict["state"] as! String, id: boxDict["deviceAddress"] as! String,deviceCode: self.equip!.hostDeviceCode)
                    vc.cDataSource.append(self.box!)
                }
                self.parentController()?.navigationController?.pushViewController(vc, animated: true)
            })
        }

       
 
    }
    @IBAction func delayChoseTap(_ sender: AnyObject) {
        let parent =  self.parentController() as! CreateModelVC
        parent.sunData?.setNumberOfComponents(1, set:[NSLocalizedString("立即执行", comment: ""),"\(NSLocalizedString("延迟", comment: ""))0.5\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))1\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))2\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))3\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))4\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))5\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))10\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))15\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))30\(NSLocalizedString("秒", comment: ""))"], addTarget:parent.navigationController!.view , complete: { [unowned self](one, two, three) -> Void in
            let a = one!
            self.delayBtn.setTitle(a, for: UIControlState())
            switch(a){
            case NSLocalizedString("立即执行", comment: ""):self.equip?.delay = "300"//ms
                break
            case "\(NSLocalizedString("延迟", comment: ""))0.5\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "600"
                break
            case "\(NSLocalizedString("延迟", comment: ""))1\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "1000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))2\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "2000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))3\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "3000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))4\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "4000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))5\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "5000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))10\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "10000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))15\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "15000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))30\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "30000"
                break
            default:break

            }
            print(self.index?.row)
                  app.modelEquipArr[(self.index?.row)!] = self.equip!

            print(a)
        })
    }
    
    func parentController()->UIViewController?
    {
        var next = self.superview
        while next != nil {
            let nextr = next?.next
            if nextr!.isKind(of: UIViewController.classForCoder()){
                return (nextr as! UIViewController)
            }
            next = next?.superview
        }
        return nil
    }
 
    


}
