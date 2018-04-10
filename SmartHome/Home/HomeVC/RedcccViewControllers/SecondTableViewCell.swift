//
//  SecondTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/14.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell,UIActionSheetDelegate,UIAlertViewDelegate{
    var index = 0
    var equip:Equip?
    var butNum:NSMutableArray?
    var isMoni = false
    var dic = [String:String]();
    var indexqj:IndexPath?
    func setups(){
        butNum = NSMutableArray(capacity: 30)
        self.backgroundColor = UIColor.white
        var btag = 1
                for var i in 0...3
                {
                    for var j in 0...4
                    {
                        let but = UIButton(frame: CGRect(x: CGFloat(Float(j))*(ScreenWidth/5),y: CGFloat(Float(i))*(ScreenHeight/2/4),width: ScreenWidth/5,height: ScreenHeight/2/4))
                        but.backgroundColor = UIColor.white
                        but.layer.borderWidth = 1.0
                        but.layer.borderColor = UIColor(red: 241.0/255, green: 241.0/255, blue: 241.0/255, alpha: 1.0).cgColor
                        but.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: UIControlState())
                        but.tag = (index)*500 + 50 + btag
                        but.setTitle(dic[String((index)*500 + 50 + btag)], for: UIControlState())
                        self.addSubview(but)
                        but.addTarget(self, action: #selector(SecondTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
                        but.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
                        self.addLongPass(but)
                        butNum?.add(but)
                        btag += 1;
                    }
                }
    }
    
    func setup(){
        
        var scalew = ScreenWidth / 320
        var scaleh = ScreenHeight / 568
        
        if scalew >= 1{
            scalew = scalew/1.2
            scaleh = scaleh/1.2
        }
        
        var tempw = scalew
        var temph = scaleh
        if scalew != 0{
            tempw = scalew*1.2
            temph = scaleh*1.2
        }
        
        butNum = NSMutableArray(capacity: 30)
        self.backgroundColor = UIColor.white
        var btag = 1
        for var i in 0...3
        {
            
            for var j in 0...2
            {
                let but = UIButton(frame: CGRect(x: CGFloat(Float(j))*(110*tempw) + 10*tempw + 10,y: CGFloat(Float(i))*50*scaleh + 20*scaleh,width: 80*scalew,height: 40*scaleh))
                but.backgroundColor = UIColor.white
                but.tag = (index)*500 + 50 + btag
                but.setTitle(dic[String((index)*500 + 50 + btag)], for: UIControlState())
                but.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
                self.addSubview(but)
                but.addTarget(self, action: #selector(SecondTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
                but.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
                self.addLongPass(but)
                butNum?.add(but)
                btag += 1;
                j += 1
            }
            i += 1
        }
    }
    
    
    @objc func butt(_ but:UIButton){
        print("----"+String(but.tag));
        if self.isMoni
        {
            self.equip?.status = String(but.tag)+","+dic[String(but.tag)]!+","+"B"
            app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
            print(self.equip?.status)
            self.parentController()?.navigationController!.popViewController(animated: true)
            return
        }
        let parameters = ["deviceAddress":equip!.equipID,
            "isStudy":String(1),
            "infraredButtonsValuess":String(but.tag)+","+"B"]
        print(parameters)
        BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
            print(response)
        }
    }
    
    typealias setJson = ()->()
    
    func detajson(_ set:@escaping setJson){
        var dic = Dictionary<String, String>()
        for var i in 0...20
        {
            dic["\((index)*500 + 50 + i)"] = "\(i)"
            
            if i == 10{
                dic["\((index)*500 + 50 + i)"] = "-/--"
            }else if i == 11{
                dic["\((index)*500 + 50 + i)"] = "0"
            }else if i == 12{
                dic["\((index)*500 + 50 + i)"] = "回看"
            }
            
        }
        print(dataDeal.toJSONString(jsonSource: dic as AnyObject))
        print("B"+String(index))
        let jsonDic = ["classesInfo":"B"+String(self.index) ,
                       "infraredButtonsInfo":dataDeal.toJSONString(jsonSource: dic as AnyObject),
            "deviceAddress":equip!.equipID,
            "deviceCode":equip!.hostDeviceCode
        ]
        print(jsonDic)
        BaseHttpService.sendRequestAccess(createButton, parameters: jsonDic as NSDictionary) { (Arr) -> () in
            set()
        }
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
    func addLongPass(_ but:UIButton)
    {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(SecondTableViewCell.longPress(_:)))
        
        longPressGR.minimumPressDuration = 0.5
        
        if BaseHttpService.GetAccountOperationType() == "2"{
        }else{
            but.addGestureRecognizer(longPressGR)
        }
        
    }
    var dtag = 0
    //按钮长按事件
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        self.dtag = (sender.view?.tag)!
        if sender.state == UIGestureRecognizerState.began{
            
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("学习", comment: ""),NSLocalizedString("修改名称", comment: ""))
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
            print("----"+String(self.dtag));
            let parameters = ["deviceAddress":equip!.equipID,
                "isStudy":String(0),
                "infraredButtonsValuess":String(self.dtag)]
            print(parameters)
            BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                print(response)
            }
            break
        case 2:
            let alert = UIAlertView(title:NSLocalizedString("提示", comment: ""),message:NSLocalizedString("请输入名字", comment: ""),delegate:self,cancelButtonTitle:NSLocalizedString("确定", comment: ""),otherButtonTitles:NSLocalizedString("取消", comment: ""))
            alert.alertViewStyle = UIAlertViewStyle.plainTextInput
            
            alert.show()
            //修改
            break
        default:
            break
        }
        
    }
    //修改
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        //self.but.setTitle(alertView.textFieldAtIndex(0)!.text, forState: UIControlState.Normal)
        if buttonIndex == 0{
            let a = alertView.textField(at: 0)!.text!
            print(a+" -- \(self.dtag)")
            
            let parameters = ["deviceAddress":equip!.equipID,
                "deviceCode":equip!.hostDeviceCode,
                "infraredButtonsValuess":String(self.dtag),
                "infraredButtonsName":a]
            print(parameters)
            BaseHttpService .sendRequestAccess(updatebutten, parameters:parameters as NSDictionary) { (response) -> () in
                print(response)
                (self.butNum?.object(at: (self.dtag - ((self.index)*500 + 50 + 1))) as AnyObject).setTitle(a, for: UIControlState())
            }
        } 
        
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//        for var i = 0;i < 5; ++i{
//            for var j = 0;j < 4; ++j{
//                let but = UIButton(frame: CGRectMake(CGFloat(Float(i))*(scalew/5),CGFloat(Float(j))*(ScreenHeight/4/2),scalew/5,ScreenHeight/4/2))
//                but.setTitle("/(i)/(j)", forState: UIControlState.Normal)
//                self.addSubview(but)
//            }
//        }
