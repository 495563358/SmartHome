//
//  NormalCorolLampTableViewCell.swift
//  SmartHome
//
//  Created by Smart house on 2018/4/20.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class NormalColorLampTableViewCell: UITableViewCell,UIActionSheetDelegate {
    var index = 0
    var dic = [String:String]();
    var equip:Equip?
    
    var isMoni:Bool = false
    var indexqj:IndexPath?
    
    func setup(){
        var scalew = ScreenWidth / 320
        var scaleh = ScreenHeight / 568
        
        if scalew >= 1 && scalew < 1.8{
            scalew = scalew/1.1
            scaleh = scaleh/1.3
        }else{
            scalew = scalew/1.5
        }
        
        let backgroundImg = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64))
        backgroundImg.image = UIImage(named: "hongwai_beijing")
        self.addSubview(backgroundImg)
        
        let openBut = UIButton(frame:CGRect(x: 64*scalew, y: 42 * scalew, width: 50*scalew, height: 50*scalew))
        let closBut = UIButton(frame:CGRect(x: ScreenWidth - openBut.frame.size.width - openBut.mj_x, y: openBut.mj_y, width: openBut.frame.size.width, height: openBut.frame.size.height))
        //开关
        openBut.setBackgroundImage(UIImage(named: "cl_open"), for: UIControlState())
        closBut.setBackgroundImage(UIImage(named: "cl_close"), for: UIControlState())
        openBut.tag = (index)*500 + 400 + 1
        closBut.tag = (index)*500 + 400 + 4
        openBut.addTarget(self, action: #selector(NormalColorLampTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside )
        closBut.addTarget(self, action: #selector(NormalColorLampTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside )
        addLongPass(openBut)
        addLongPass(closBut)
        
        
        //亮度
        let lightUp = UIButton(frame:CGRect(x: (ScreenWidth - 50 * scalew)/2, y: 15*scalew, width: 50*scalew, height: 50*scalew))
        let lightDown = UIButton(frame:CGRect(x: lightUp.mj_x, y: lightUp.mj_y + lightUp.mj_h + 18*scalew, width: openBut.frame.size.width, height: openBut.frame.size.height))
        lightUp.setBackgroundImage(UIImage(named: "cl_liangdu-jia"), for: UIControlState())
        //openBut.showBadgeWithStyle(WBadgeStyleRedDot, value: 22, animationType: WBadgeAnimTypeNone)
        lightDown.setBackgroundImage(UIImage(named: "cl_liangdu-jian"), for: UIControlState())
        lightUp.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        lightDown.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        lightUp.tag = (index)*500+2
        lightDown.tag = (index)*500+3
        self.addLongPass(lightUp)
        self.addLongPass(lightDown)
        
        self.addSubview(openBut)
        self.addSubview(closBut)
        self.addSubview(lightUp)
        self.addSubview(lightDown)
        
        let rgbView = UIButton(frame: CGRect(x: (ScreenWidth-165*scalew)/2, y: lightDown.mj_y + lightDown.mj_h + 22 * scalew, width: 165 * scalew, height: 165 * scalew))
        rgbView.setBackgroundImage(UIImage(named: "cl_circle_small"), for: .normal)
        
        let centerWhite = UIView(frame: CGRect(x: 0, y: 0, width: 42*scalew, height: 42*scalew))
        centerWhite.center = CGPoint(x: 165/2 * scalew, y:  165/2 * scalew)
        centerWhite.backgroundColor = UIColor.white
        centerWhite.layer.cornerRadius = 21 * scalew
        centerWhite.layer.masksToBounds = true
        
        let rbut = UIButton(frame: CGRect(x: 10*scalew,y: (165 - 42)/2 * scalew,width: 42*scalew,height: 42*scalew))
        rbut.setBackgroundImage(UIImage(named: "cl_r"), for: .normal)
        rbut.tag = (index)*500 + 400 + 5
        rbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        self.addLongPass(rbut)
        
        let gbut = UIButton(frame: CGRect(x: (165 - 42)/2 * scalew,y: 10 * scalew,width: 42*scalew,height: 42*scalew))
        gbut.setBackgroundImage(UIImage(named: "cl_g"), for: .normal)
        gbut.tag = (index)*500 + 400 + 6
        gbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        self.addLongPass(gbut)
        
        let bbut = UIButton(frame: CGRect(x: (165 - 42 - 10)*scalew,y: (165 - 42)/2 * scalew,width: 42*scalew,height: 42*scalew))
        bbut.setBackgroundImage(UIImage(named: "cl_b"), for: .normal)
        bbut.tag = (index)*500 + 400 + 7
        bbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        self.addLongPass(bbut)
        
        let wbut = UIButton(frame: CGRect(x: (165 - 42)/2 * scalew,y: (165 - 42 - 10) * scalew,width: 42*scalew,height: 42*scalew))
        wbut.setBackgroundImage(UIImage(named: "cl_w"), for: .normal)
        wbut.tag = (index)*500 + 400 + 21
        wbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        self.addLongPass(wbut)
        
        rgbView.addSubview(centerWhite)
        rgbView.addSubview(rbut)
        rgbView.addSubview(gbut)
        rgbView.addSubview(bbut)
        rgbView.addSubview(wbut)
        self.addSubview(rgbView)
        
        let startY = rgbView.mj_y + rgbView.mj_h + 21*scalew
        let space = (ScreenWidth - 54*scalew - 4 * 42*scalew)/3 + 42*scalew
        let imgArr = ["cl_PLASH","cl_STROBE","cl_FADE","cl_SMOOTH"]
        var btag = 4
        for i in 0...3
        {
            //创建15个变色灯
            for j in 0...2
            {
                let but = UIButton(frame: CGRect(x: CGFloat(Float(j))*space + 27*scalew,y: CGFloat(Float(i))*50*scalew + startY,width: 42*scalew,height: 42*scalew))
                but.tag = (index)*500 + 400 + btag + 4
                but.setBackgroundImage(UIImage(named: "变色灯\(btag)"), for: UIControlState())
                but.layer.cornerRadius = 21*scalew
                but.layer.masksToBounds = true
                but.layer.borderColor = UIColor.white.cgColor
                but.layer.borderWidth = 2
                self.addSubview(but)
                but.addTarget(self, action: #selector(NormalColorLampTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
                self.addLongPass(but)
                btag += 1
            }
            //创建5个灰色灯
            let btn = UIButton(frame: CGRect(x: 3*space + 27*scalew,y: CGFloat(Float(i))*50*scalew + startY,width: 42*scalew,height: 42*scalew))
            btn.tag = (index)*500 + 400 + i + 21
            btn.setBackgroundImage(UIImage(named: imgArr[i]), for: UIControlState())
            self.addSubview(btn)
            btn.addTarget(self, action: #selector(NormalColorLampTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
            self.addLongPass(btn)
            
        }
        
    }
    
    @objc func butt(_ but:UIButton){
        print("----"+String(but.tag));
        if self.isMoni
        {
            self.equip?.status = String(but.tag)+","+dic[String(but.tag)]!+","+"I"
            
            app.modelEquipArr[(indexqj?.row)!] = self.equip!
            
            self.parentController()?.navigationController!.popViewController(animated: true)
            return
        }
        let parameters = ["deviceAddress":equip!.equipID,
                          "isStudy":String(1),
                          "infraredButtonsValuess":String(but.tag)+","+"I"]
        print(parameters)
        BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
            print(response)
        }
    }
    
    
    typealias setJson = ()->()
    func detajson(_ set:@escaping setJson){
        var datajson = Dictionary<String, String>()
        datajson["\((index)*500+400+1)"] = NSLocalizedString("开", comment: "")
        datajson["\((index)*500+400+2)"] = NSLocalizedString("上", comment: "")
        datajson["\((index)*500+400+3)"] = NSLocalizedString("下", comment: "")
        datajson["\((index)*500+400+4)"] = NSLocalizedString("关", comment: "")
        
        for i in 5...19{
            datajson["\((index)*500+400+i)"] = "\(i-4)"
        }
        datajson["\((index)*500+400+20)"] = "W"
        datajson["\((index)*500+400+21)"] = "PLASH"
        datajson["\((index)*500+400+22)"] = "STROBE"
        datajson["\((index)*500+400+23)"] = "FADE"
        datajson["\((index)*500+400+24)"] = "SMOOTH"
        print(dataDeal.toJSONString(jsonSource: datajson as AnyObject))
        print("I"+String(index))
        print("完成添加I")
        let jsonDic = ["classesInfo":"I"+String(self.index) ,
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
