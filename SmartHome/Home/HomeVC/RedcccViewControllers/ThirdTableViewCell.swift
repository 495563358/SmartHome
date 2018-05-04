//
//  ThirdTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/14.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ThirdTableViewCell: UITableViewCell,UIActionSheetDelegate,UIAlertViewDelegate{
    var index = 0
  
    var equip:Equip?
    var smallProgress:QLCycleProgressView? =  QLCycleProgressView(frame: CGRect(x: 0,y: 30,width: ScreenWidth/1.8 ,height: ScreenWidth/1.8))
    var leb = UIButton()
    var lbut:UIButton?
    var rbut:UIButton?
    var isMoni = false
    var dic = [String:String]();
    //判断学习还是控制
    var isBool = 1
    var indexqj:IndexPath?
    var btag = 0
    
    var OneBut:UIButton!
    var TwoBut:UIButton!
    var ThreeBut:UIButton!
    
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
        openBut.tag = (index)*500 + 100 + 6
        closBut.tag = (index)*500 + 100  + 7
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
        // self.smallProgress =
       //self.smallProgress?.frame = CGRectMake(0,0,ScreenWidth ,ScreenWidth*2/3)
        self.smallProgress!.center = CGPoint(x: ScreenWidth/2, y: ScreenWidth / 2.3)
        self.smallProgress!.backgroundColor = UIColor.clear
        self.smallProgress!.mainColor = mainColor//
        //控制
        self.smallProgress!.progress = 10 / 15.0;
        //度数
        self.leb = UIButton(frame: CGRect(x: ScreenWidth/2-72*scalew,y: ScreenHeight/4-50*scaleh,width: 150*scalew,height: 80*scaleh))
        self.leb.setTitle("25°", for: UIControlState())
        self.leb.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        self.leb.titleLabel?.font = UIFont.systemFont(ofSize: 45.0)
        self.leb.setTitleColor(systemColor, for: UIControlState())
        self.leb.tag = (index)*500 + 100 + 5
        self.leb.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        addLongPass(self.leb)
        
        
        //按钮view
         //加
        let sbut = UIButton(frame: CGRect(x: ScreenWidth - 60*scalew,y: self.smallProgress!.center.y,width: 40*scalew,height: 40*scalew))
        sbut.setImage(UIImage(named: "add_blue"), for: UIControlState())
        sbut.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        sbut.backgroundColor = UIColor.clear
        sbut.tag = (index)*500 + 100  + 1
        sbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
         //减
        
        let xbut = UIButton(frame: CGRect(x: 20*scalew,y: self.smallProgress!.center.y,width: 40*scalew,height: 40*scalew))
        xbut.setImage(UIImage(named: "jian_blue"), for: UIControlState())
        xbut.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        xbut.tag = (index)*500 + 100  + 2
        xbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        xbut.backgroundColor = UIColor.clear
        
        
        //按钮view
        let Tvc1 = UIView(frame: CGRect(x: ScreenWidth/2-75*scalew,y: ScreenHeight/2-20*scaleh-40,width: 150*scalew,height: 35*scaleh))
        Tvc1.backgroundColor = UIColor.clear
        //制冷
        lbut = UIButton(frame: CGRect(x: 0,y: 0,width: 75*scalew,height: Tvc1.frame.size.height))
        lbut!.setTitle(NSLocalizedString("制冷", comment: ""), for:  UIControlState())
        lbut?.setTitleColor(UIColor.black, for: UIControlState())
        lbut!.setTitleColor(UIColor.white, for: .selected)
        lbut!.backgroundColor = UIColor.clear
        lbut?.setBackgroundImage(UIImage(named: "zhileng_hui_zuo"), for: UIControlState())
        lbut?.setBackgroundImage(UIImage(named: "zhileng_lan_zuo"), for: .selected)
        lbut?.isSelected = true
        lbut!.tag = (index)*500 + 100  + 3
        lbut!.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        
        
        //制热
        rbut = UIButton(frame: CGRect(x: 75*scalew,y: 0,width: 75*scalew,height: Tvc1.frame.size.height))
        rbut!.setTitle(NSLocalizedString("制热", comment: ""), for:  UIControlState())
        rbut?.setTitleColor(UIColor.black, for: UIControlState())
        rbut!.setTitleColor(UIColor.white, for: .selected)
        rbut!.tag = (index)*500 + 100  + 4
        rbut!.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        rbut!.backgroundColor = UIColor.clear
        
        rbut?.setBackgroundImage(UIImage(named: "zhileng_hui_you"), for: UIControlState())
        rbut?.setBackgroundImage(UIImage(named: "zhileng_lan_you"), for: .selected)
        
        Tvc1.addSubview(lbut!)
        Tvc1.addSubview(rbut!)
        addLongPass(lbut!)
        addLongPass(rbut!)
       

        self.addSubview(leab)
        self.addSubview(leab1)
        self.addSubview(self.smallProgress!)
        self.addSubview(leb)
        self.addSubview(sbut)
        self.addSubview(xbut)
        self.addSubview(Tvc1)
        self.addSubview(openBut)
        self.addSubview(closBut)
        
        //添加下面个建
        OneBut = UIButton(frame: CGRect(x: (20*scalew),y: (Tvc1.y + Tvc1.size.height) + 30*scaleh,width: 80*scalew,height: 40*scaleh))
        OneBut!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        OneBut!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        OneBut!.setTitleColor(UIColor.white, for: UIControlState())
        OneBut!.setTitle(dic["\((index)*500 + 100 + 40)"], for: UIControlState())
        
        TwoBut = UIButton(frame: CGRect(x: ScreenWidth/2 - OneBut.frame.size.width/2 ,y: OneBut.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        TwoBut!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        TwoBut!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        TwoBut!.setTitleColor(UIColor.white, for: UIControlState())
        TwoBut!.setTitle(dic["\((index)*500 + 100 + 41)"], for: UIControlState())
        
        ThreeBut = UIButton(frame: CGRect(x: ScreenWidth - OneBut.frame.origin.x - OneBut.frame.size.width,y: OneBut.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        ThreeBut!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        ThreeBut!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        ThreeBut!.setTitleColor(UIColor.white, for: UIControlState())
        ThreeBut!.setTitle(dic["\((index)*500 + 100 + 42)"], for: UIControlState())
        
        
        OneBut.tag = (index)*500 + 100 + 40
        TwoBut.tag = (index)*500 + 100  + 41
        ThreeBut.tag = (index)*500 + 100  + 42
        OneBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        TwoBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        ThreeBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside )
        addLongPass(OneBut)
        addLongPass(TwoBut)
        addLongPass(ThreeBut)
        
        self.addSubview(OneBut)
        self.addSubview(TwoBut)
        self.addSubview(ThreeBut)
        
    }
    var temperature = 0 //红外的唯一表示
    //var current = 16 //当前温度
    var current = 10 //当前温度
    var bool = false //判断制冷制热 false 制冷
    
    typealias setJson = () -> ()
    
    func detajson(_ set:@escaping setJson){
        var dic = Dictionary<String,String>()
        dic["\((index)*500 + 100 + 7)"] = "关"
        dic["\((index)*500 + 100 + 6)"] = "开"
        dic["\((index)*500 + 100 + 40)"] = "功能"
        dic["\((index)*500 + 100 + 41)"] = "模式"
        dic["\((index)*500 + 100 + 42)"] = "定时"
        for var i in 10...39
        {
            if i<25{
                dic["\((index)*500 + 100 + i)"] = "制冷\(i+6)°"
            }else{
                dic["\((index)*500 + 100 + i)"] = "制热\(i-9)°"
            }
            
        }
        print("C"+String(index))
        print(dataDeal.toJSONString(jsonSource: dic as AnyObject))
        let jsonDic = ["classesInfo":"C"+String(self.index) ,
                       "infraredButtonsInfo":dataDeal.toJSONString(jsonSource: dic as AnyObject),
                    "deviceAddress":equip!.equipID,
                    "deviceCode":equip!.hostDeviceCode
        ]
        print(jsonDic)
        BaseHttpService.sendRequestAccess(createButton, parameters: jsonDic as NSDictionary) { (Arr) -> () in
            set()
        }
        
    }
    //var zhileng = 9
    //var zhire = 24
    var zhileng = 19
   // var zhire = 34  按钮点击事件
    @objc func butt(_ but:UIButton){
        print(zhileng)
        switch but.tag{
        case (index)*500 + 100  + 1:
            //加
            //如果是制热 调整视图 计算气温
            if bool{
                if zhileng+15 >= 39{
                    return
                }
                zhileng = zhileng+1
                temperature = (index)*500 + 100 + zhileng + 15
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng-9) / 15.0
                self.leb.setTitle("\(zhileng+15-9)°", for: UIControlState())
            }else{
                if zhileng >= 24{
                    return
                }
                zhileng = zhileng + 1
                temperature = (index)*500 + 100 + zhileng
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng+6 - 15) / 15.0
                self.leb.setTitle("\(zhileng+6)°", for: UIControlState())
            }
            print("点击的按钮tag值 = 1,气温 = \(temperature), 是否制热 = \(bool)")
            if self.isMoni
            {
                self.equip?.status = String(temperature)+","+(self.leb.titleLabel?.text)!
                app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
                
                self.parentController()?.navigationController!.popViewController(animated: true)
                return
            }
            print("气温----"+String(temperature));
            if isBool == 1{
                let parameters = ["deviceAddress":equip!.equipID,
                    "isStudy":String(isBool),
                    "infraredButtonsValuess":String(temperature)+","+"C"]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }else{
                let parameters = ["deviceAddress":equip!.equipID,
                    "isStudy":String(isBool),
                    "infraredButtonsValuess":String(temperature)]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }


            break
        case (index)*500 + 100  + 2:

            //减
            if bool{
                if zhileng+15 < 26{
                    return
                }
                zhileng = zhileng-1
                temperature = (index)*500 + 100 + zhileng + 15
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng-9) / 15.0
                self.leb.setTitle("\(zhileng+15-9)°", for: UIControlState())
            }else{
                if zhileng < 11{
                    return
                }
                zhileng = zhileng - 1
                temperature = (index)*500 + 100 + zhileng
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng+6 - 15) / 15.0
                self.leb.setTitle("\(zhileng+6)°", for: UIControlState())
            }
            
//            self.leb.setTitle("\(current)°", forState: UIControlState.Normal)
//            temperature = (index)!*500 + 100+25+( bool ? 1 : -1) * current
             print("2,\(temperature),\(bool)")
            if self.isMoni
            {
                self.equip?.status = String(temperature)+","+(self.leb.titleLabel?.text)!
                app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
                
                self.parentController()?.navigationController!.popViewController(animated: true)
                return
            }
            print("----"+String(temperature));
            

           
            break
        case (index)*500 + 100  + 3:
            //制冷
            bool = false
            lbut?.isSelected = true
            rbut?.isSelected = false
            break
        case (index)*500 + 100  + 4:
            //制热
            bool = true
            lbut?.isSelected = false
            rbut!.isSelected = true
            break
        case (index)*500 + 100  + 5:
            
            if self.isMoni
            {
                self.equip?.status = String(temperature)+","+(self.leb.titleLabel?.text)!+","+"C"
                app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
                print(self.equip?.status)
                self.parentController()?.navigationController!.popViewController(animated: true)
                return
            }
            
            break
        case (index)*500 + 100  + 6:
            if self.isMoni
            {
                self.equip?.status = String(but.tag)+","+("开")+","+"C"
                app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
                
                self.parentController()?.navigationController!.popViewController(animated: true)
                return
            }
            //temperature = (index?.row)!*100 + 1
            
            if isBool == 1
            {
                print("----"+String(but.tag));
                let parameters = ["deviceAddress":equip!.equipID,
                    "isStudy":String(isBool),
                    "infraredButtonsValuess":String(but.tag)+","+"C"]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }
            else
            {
                print("----"+String(but.tag));
                let parameters = ["deviceAddress":equip!.equipID,
                    "isStudy":String(isBool),
                    "infraredButtonsValuess":String(but.tag)]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }
            

            break
        case (index)*500 + 100 + 7:
            if self.isMoni
            {
                self.equip?.status = String(but.tag)+","+("关")+","+"C"
                app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
                
                self.parentController()?.navigationController!.popViewController(animated: true)
                return
            }
            //temperature = (index?.row)!*100 + 2
            
            if isBool == 1
            {
                print("----"+String(but.tag));
                let parameters = ["deviceAddress":equip!.equipID,
                    "isStudy":String(isBool),
                    "infraredButtonsValuess":String(but.tag)+","+"C"]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }
            else
            {
                print("----"+String(but.tag));
                let parameters = ["deviceAddress":equip!.equipID,
                    "isStudy":String(isBool),
                    "infraredButtonsValuess":String(but.tag)]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }
            
            break
        default :
            if isBool == 1
            {
                let parameters = ["deviceAddress":equip!.equipID,
                                  "isStudy":String(isBool),
                                  "infraredButtonsValuess":String(temperature)+","+"C"]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }
            else
            {
                let parameters = ["deviceAddress":equip!.equipID,
                                  "isStudy":String(isBool),
                                  "infraredButtonsValuess":String(temperature)]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }
            break
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
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(ThirdTableViewCell.longPress(_:)))
        
        longPressGR.minimumPressDuration = 0.5
        if BaseHttpService.GetAccountOperationType() == "2"{
        }else{
            but.addGestureRecognizer(longPressGR)
        }
       
    }
    //按钮长按事件
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        self.btag = (sender.view?.tag)!
        if sender.state == UIGestureRecognizerState.began{
            if self.btag < ((index)*500 + 100 + 40){
                let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: NSLocalizedString("学习", comment: ""), otherButtonTitles:NSLocalizedString("学习完成", comment: ""))
                actionSheet?.show(in: self.superview!)
            }else{
                let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("学习", comment: ""),NSLocalizedString("修改名称", comment: ""))
                actionSheet?.show(in: self.superview!)
            }
        }
    }
    //长按事件
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if self.btag < ((index)*500 + 100 + 40){
            switch buttonIndex{
            case 0:
                //取消
                self.isBool = 0
                zhileng = 9
                bool = false
                temperature = (index)*500 + 100 + zhileng
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng+6+1 - 15) / 15.0
                self.leb.setTitle("\(zhileng+6+1)°", for: UIControlState())
                lbut!.isSelected = true
                rbut!.isSelected = false
                
                print("0")
                break
            case 1:
                print("1111")
                break
            case 2:
                print("1")
                self.isBool = 1
                zhileng = 19
                bool = false
                temperature = (index)*500 + 100 + zhileng
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng+6 - 15) / 15.0
                self.leb.setTitle("\(zhileng+6)°", for: UIControlState())
                lbut!.isSelected = true
                rbut!.isSelected = false
                break
            default:
                break
            }
        }
        else{
            switch buttonIndex{
            case 0:
                //取消
                break
            case 1:
                print("----"+String(self.btag));
                let parameters = ["deviceAddress":equip!.equipID,
                    "isStudy":String(0),
                    "infraredButtonsValuess":String(self.btag)]
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
    }
    
    //修改
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        //self.but.setTitle(alertView.textFieldAtIndex(0)!.text, forState: UIControlState.Normal)
        if buttonIndex == 0{
            let a = alertView.textField(at: 0)!.text!
            print(a)
            switch self.btag{
            case (index)*500+140:
                OneBut.setTitle(a, for: UIControlState())
                let parameters = ["deviceAddress":equip!.equipID,
                    "deviceCode":equip!.hostDeviceCode,
                    "infraredButtonsValuess":String(self.btag),
                    "infraredButtonsName":a]
                print(parameters)
                BaseHttpService .sendRequestAccess(updatebutten, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
                break
            case (index)*500+141:
                TwoBut.setTitle(a, for: UIControlState())
                let parameters = ["deviceAddress":equip!.equipID,
                    "deviceCode":equip!.hostDeviceCode,
                    "infraredButtonsValuess":String(self.btag),
                    "infraredButtonsName":a]
                print(parameters)
                BaseHttpService .sendRequestAccess(updatebutten, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
                break
            case (index)*500+142:
                ThreeBut.setTitle(a, for: UIControlState())
                let parameters = ["deviceAddress":equip!.equipID,
                    "deviceCode":equip!.hostDeviceCode,
                    "infraredButtonsValuess":String(self.btag),
                    "infraredButtonsName":a]
                print(parameters)
                BaseHttpService .sendRequestAccess(updatebutten, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
                break
            default :
                break
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
