//
//  InfraredCell.swift
//  SmartHome
//
//  Created by sunzl on 16/5/9.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class lockCell: UITableViewCell,UIActionSheetDelegate,UIAlertViewDelegate {
    
    @IBOutlet weak var txtLabel: UIButton!
    @IBOutlet var name: UILabel!
    @IBOutlet var icon: UIImageView!
      @IBOutlet var delayBtn: UIButton!
    var index:IndexPath?
    var equip:Equip?
    var isMoni:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.icon.contentMode = UIViewContentMode.scaleAspectFit
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(lockCell.longPress(_:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1.0
        //self.contentView.addGestureRecognizer(longPress)
        txtLabel.setTitle(NSLocalizedString("点击进入控制界面", comment: ""), for: UIControlState())
    }
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("重建红外模块", comment: ""))
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
                self.txtLabel.setTitle(arrayStr[1], for: UIControlState()) 
            }

        }else{
        //控制界面
        //1
        self.delayBtn.isHidden = true
        }
        
    }
    @IBAction func controlTap(_ sender: AnyObject) {
        
        //----------
       /*   let infraredVC = InfraredViewController(nibName: "InfraredViewController", bundle: nil)
        infraredVC.swif = 0
        BaseHttpService .sendRequestAccess(Get_gaininfraredbuttonses, parameters:["deviceAddress":self.equip!.equipID]) { (response) -> () in
            print(response)
            if response.count != 0{
                infraredVC.cellArr = response as! NSArray
            }
            //print(infraredVC.cellArr)
            infraredVC.WillAppear()
        }
        infraredVC.Address = self.equip!.equipID
        infraredVC.equip = self.equip
        infraredVC.index = self.index
        infraredVC.isMoni = self.isMoni
        infraredVC.swif = 1
        self.parentController()!.navigationController?.pushViewController(infraredVC, animated: true)
        
        */
        

        if isMoni{
            let dic = ["deviceCode":self.equip!.hostDeviceCode,"deviceAddress":self.equip!.equipID]
            BaseHttpService.sendRequestAccess(gaininfraredvalue, parameters: dic as NSDictionary, success: { (response) -> () in
                print(response)
                if response.count == 0{
                    (UIApplication.shared.delegate as! AppDelegate).infArr = []
                    let vc = RedViewController()
                    vc.equip = self.equip
                    vc.hidesBottomBarWhenPushed=true
                    vc.isMoni = self.isMoni
                    vc.indexqj = self.index
                    self.parentController()? .navigationController?.pushViewController(vc, animated: true)
                }else{
                    var  shunxu = (response["shunxu"]as!NSArray) [0] as! String
                    shunxu = (shunxu as NSString).substring(with: NSMakeRange(0, shunxu.count-1))
                    let kv = response["button-value"];
                    print("\(shunxu)---\(kv)");
                    let arr = shunxu.components(separatedBy: ",")
                    
                    let VC = RedViewController()
                    VC.equip = self.equip
                    VC.indexqj = self.index
                    VC.hidesBottomBarWhenPushed=true
                    VC.isMoni = self.isMoni
                    VC.dic = kv as! [String:String]
                    app.infArr = arr
                    self.parentController()? .navigationController?.pushViewController(VC, animated: true)
                }
                
            }) 
        }else{
            let alertView = UIAlertView()
            alertView.alertViewStyle =  UIAlertViewStyle.secureTextInput
            alertView.delegate = self
            alertView.title = NSLocalizedString("密码", comment: "")
            alertView.message = NSLocalizedString("请输入登录密码", comment: "")
            alertView.addButton(withTitle: NSLocalizedString("取消", comment: ""))
            alertView.addButton(withTitle: NSLocalizedString("好的",comment:""))
            alertView.show()
//            let vc = LockViewController()
//            vc.equip = self.equip
//            vc.hidesBottomBarWhenPushed=true
//            self.parentController()?.navigationController?.pushViewController(vc, animated: true)
            
        }

       
 
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1{
            print(alertView.textField(at: 0)?.text)
            let dic = ["userPhone":BaseHttpService.getUserPhoneType(),"userPwd":alertView.textField(at: 0)!.text!]
            BaseHttpService.sendRequestAccess(initLockLogin, parameters: dic as NSDictionary) { (arr) -> () in
                let vc = LockViewController()
                vc.equip = self.equip
                vc.hidesBottomBarWhenPushed=true
                self.parentController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            print("取消")
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

             app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
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
