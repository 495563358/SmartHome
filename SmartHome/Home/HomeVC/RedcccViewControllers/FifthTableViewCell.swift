//
//  FourthTableViewCell.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/26.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class FifthTableViewCell: UITableViewCell,UIActionSheetDelegate {
    var index = 0
    var dic = [String:String]();
    var equip:Equip?
    
    var isMoni:Bool = false
    var indexqj:IndexPath?
    
    func setup(){
        var scalew = ScreenWidth / 320
        var scaleh = ScreenHeight / 568
        
        if scalew >= 1{
            scalew = scalew/1.2
            scaleh = scaleh/1.3
        }
        
        
        self.backgroundColor = UIColor.white
        
        let openBut = UIButton(frame:CGRect(x: 20*scalew, y: 5*scaleh, width: 50*scalew, height: 50*scalew))
        let closBut = UIButton(frame:CGRect(x: ScreenWidth - openBut.frame.size.width - (20)*scalew, y: 5*scaleh, width: openBut.frame.size.width, height: openBut.frame.size.height))
        //开关
        openBut.setBackgroundImage(UIImage(named: "开电视"), for: UIControlState())
        closBut.setBackgroundImage(UIImage(named: "关电视"), for: UIControlState())
        openBut.tag = (index)*500 + 200 + 1
        closBut.tag = (index)*500 + 200 + 4
        openBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        closBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        addLongPass(openBut)
        addLongPass(closBut)
        //文字
        let leab = UILabel(frame: CGRect(x: 20*scalew,y: openBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        let leab1 = UILabel(frame: CGRect(x: ScreenWidth - openBut.frame.size.width-(20)*scalew,y: closBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        leab.text = NSLocalizedString("开", comment: "")
        leab1.text = NSLocalizedString("关", comment: "")
        leab.textColor = systemColor
        leab1.textColor = systemColor
        leab.textAlignment = NSTextAlignment.center
        leab1.textAlignment = NSTextAlignment.center
        
        
        let space = (ScreenWidth - 240*scalew)/3 + 50*scalew
        //亮度
        let lightUp = UIButton(frame:CGRect(x: 20*scalew + space, y: 5*scaleh, width: 50*scalew, height: 50*scalew))
        let lightDown = UIButton(frame:CGRect(x: (20)*scalew + 2*space, y: 5*scaleh, width: openBut.frame.size.width, height: openBut.frame.size.height))
        lightUp.setBackgroundImage(UIImage(named: "变色灯亮度Up"), for: UIControlState())
        //openBut.showBadgeWithStyle(WBadgeStyleRedDot, value: 22, animationType: WBadgeAnimTypeNone)
        lightDown.setBackgroundImage(UIImage(named: "变色灯亮度Down"), for: UIControlState())
        lightUp.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        lightDown.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        lightUp.tag = (index)*500+2
        lightDown.tag = (index)*500+3
        self.addLongPass(lightUp)
        self.addLongPass(lightDown)
        
        self.addSubview(openBut)
        self.addSubview(closBut)
        self.addSubview(leab)
        self.addSubview(leab1)
        self.addSubview(lightUp)
        self.addSubview(lightDown)
        
        var names:[String] = ["R","G","B"]
        var btag = 1
        for var i in 0...4
        {
            //创建15个变色灯
            for var j in 0...2
            {
                let but = UIButton(frame: CGRect(x: CGFloat(Float(j))*space + 20*scalew,y: CGFloat(Float(i))*60*scalew + 60*scaleh + 50*scalew,width: 50*scalew,height: 50*scalew))
                but.backgroundColor = UIColor.white
                but.tag = (index)*500 + 200 + btag + 4
                if i==0{
                    but.setTitle(names[j], for: UIControlState())
                }
                but.setBackgroundImage(UIImage(named: "变色灯\(btag)"), for: UIControlState())
                self.addSubview(but)
                but.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
                but.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
                self.addLongPass(but)
                btag += 1;
                j += 1
            }
            //创建5个灰色灯
            let btn = UIButton(frame: CGRect(x: 3*space + 20*scalew,y: CGFloat(Float(i))*60*scalew + 60*scaleh + 50*scalew,width: 50*scalew,height: 50*scalew))
            btn.tag = (index)*500 + 200 + i + 19
            btn.setBackgroundImage(UIImage(named: "变色灯灰色"), for: UIControlState())
            btn.setTitle(dic[String((index)*500 + 200 + i + 20)], for: UIControlState())
            self.addSubview(btn)
            btn.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
            self.addLongPass(btn)
            
            i += 1
        }
        
        
    }
    
    @objc func butt(_ but:UIButton){
        print("----"+String(but.tag));
        if self.isMoni
        {
            self.equip?.status = String(but.tag)+","+dic[String(but.tag)]!+","+"E"
            
            app.modelEquipArr[(indexqj?.row)!] = self.equip!
            
            self.parentController()?.navigationController!.popViewController(animated: true)
            return
        }
        let parameters = ["deviceAddress":equip!.equipID,
            "isStudy":String(1),
            "infraredButtonsValuess":String(but.tag)+","+"E"]
        print(parameters)
        BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
            print(response)
        }
    }
    
    
    typealias setJson = ()->()
    func detajson(_ set:@escaping setJson){
        var datajson = Dictionary<String, String>()
        datajson["\((index)*500+200+1)"] = NSLocalizedString("开", comment: "")
        datajson["\((index)*500+200+2)"] = NSLocalizedString("上", comment: "")
        datajson["\((index)*500+200+3)"] = NSLocalizedString("下", comment: "")
        datajson["\((index)*500+200+4)"] = NSLocalizedString("关", comment: "")
        
        for var i in 5...19{
            datajson["\((index)*500+200+i)"] = "\(i-4)"
        }
        datajson["\((index)*500+200+20)"] = "W"
        datajson["\((index)*500+200+21)"] = "PLASH"
        datajson["\((index)*500+200+22)"] = "STROBE"
        datajson["\((index)*500+200+23)"] = "FADE"
        datajson["\((index)*500+200+24)"] = "SMOOTH"
        print(dataDeal.toJSONString(jsonSource: datajson as AnyObject))
        print("E"+String(index))
        print("完成添加E")
        let jsonDic = ["classesInfo":"E"+String(self.index) ,
                       "infraredButtonsInfo":dataDeal.toJSONString(jsonSource: datajson as AnyObject),
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
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(FifthTableViewCell.longPress(_:)))
        
        longPressGR.minimumPressDuration = 0.5
        if BaseHttpService.GetAccountOperationType() == "2"{
        }else{
            but.addGestureRecognizer(longPressGR)
        }
        
        
    }
    var dtag = 0
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        self.dtag = (sender.view?.tag)!
        if sender.state == UIGestureRecognizerState.began{
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("学习", comment: ""))
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
        default:
            break
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
