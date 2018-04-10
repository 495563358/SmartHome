//
//  FourthTableViewCell.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/26.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class FourthTableViewCell: UITableViewCell,UIActionSheetDelegate,UIAlertViewDelegate{
    var index = 0
    var dic = [String:String]();
    var equip:Equip?
    var isMoni:Bool = false
    var indexqj:IndexPath?
    
    var SeveBut:UIButton!
    var EightBut:UIButton!
    var NightBut:UIButton!
    var TenBut:UIButton!
    
    
    var btn1:UIButton!
    var btn2:UIButton!
    var btn3:UIButton!
    var btn4:UIButton!
    var btn5:UIButton!
    var btn6:UIButton!
    var btn7:UIButton!
    var btn8:UIButton!
    var btn9:UIButton!
    
    func setup(){
        var scalew = ScreenWidth / 320
        var scaleh = ScreenHeight / 568
        
        if scalew >= 1{
            scalew = scalew/1.2
            scaleh = scaleh/1.2
        }
        
        //        self.backgroundColor = UIColor(patternImage: navBgImage!)
        
        self.backgroundColor = UIColor.white
        
        let openBut = UIButton(frame:CGRect(x: 20*scalew, y: 5*scaleh, width: 50*scalew, height: 50*scalew))
        let closBut = UIButton(frame:CGRect(x: ScreenWidth - openBut.frame.size.width - (20)*scalew, y: 5*scaleh, width: openBut.frame.size.width, height: openBut.frame.size.height))
        //开关
        openBut.setBackgroundImage(UIImage(named: "开电视"), for: UIControlState())
        //openBut.showBadgeWithStyle(WBadgeStyleRedDot, value: 22, animationType: WBadgeAnimTypeNone)
        closBut.setBackgroundImage(UIImage(named: "关电视"), for: UIControlState())
        openBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        closBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        openBut.tag = (index)*500+1+150
        closBut.tag = (index)*500+2+150
        self.addLongPass(openBut)
        self.addLongPass(closBut)
        
        //文字
        let leab = UILabel(frame: CGRect(x: 20*scalew,y: openBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        let leab1 = UILabel(frame: CGRect(x: ScreenWidth - openBut.frame.size.width-(20)*scalew,y: closBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        leab.text = NSLocalizedString("开", comment: "")
        //        if dic.count > 0
        //        {
        //            leab.text = dic[String((index?.row)!*100+1)];
        //        }
        leab1.text = NSLocalizedString("关", comment: "")
        leab.textColor = systemColor
        leab1.textColor = systemColor
        leab.textAlignment = NSTextAlignment.center;
        leab1.textAlignment = NSTextAlignment.center ;
        
        
        var tempw = scalew
        var temph = scaleh
        if scalew != 1{
            tempw = scalew*1.8
            temph = scaleh/1.1
        }
        //中部图片
        let middleView = UIView(frame:CGRect(x: (openBut.frame.size.width+35*tempw),y: openBut.frame.size.height+leab.frame.size.height+90*temph,width: ScreenWidth-((openBut.frame.size.width+35*tempw)*2),height: ScreenWidth-((openBut.frame.size.width+35*tempw)*2)))
        let Imaview = UIImageView(image:UIImage(named:"caidan_anniu"))
        Imaview.frame=middleView.bounds
        Imaview.autoresizingMask = UIViewAutoresizing.flexibleWidth
        middleView.addSubview(Imaview)
        //添加上下左右确定
        let Upbut = UIButton(frame: CGRect(x: middleView.frame.size.width/2-13*scalew,y: 15*scaleh,width: 27*scalew,height: 15*scaleh))
        Upbut.setBackgroundImage(UIImage(named: "hongwai_shang"), for: UIControlState())
        
        let lowerbut = UIButton(frame: CGRect(x: middleView.frame.size.width/2-13*scalew,y: middleView.frame.size.height - 15*scaleh-20*scaleh,width: 27*scalew,height: 15*scaleh))
        lowerbut.setBackgroundImage(UIImage(named: "hongwai_xia"), for: UIControlState())
        
        let Leftbut = UIButton(frame: CGRect(x: 15*scalew,y: middleView.frame.size.width/2 - 13*scaleh,width: 15*scalew,height: 27*scaleh))
        Leftbut.setBackgroundImage(UIImage(named: "hongwai_zuo"), for: UIControlState())
        
        let rightbut = UIButton(frame: CGRect(x: middleView.frame.size.width-15*scalew-20*scalew,y: middleView.frame.size.width/2 - 13*scaleh,width: 15*scalew,height: 27*scaleh))
        rightbut.setBackgroundImage(UIImage(named: "hongwai_you"), for: UIControlState())
        
        let middlebut = UIButton(frame: CGRect(x: middleView.frame.size.width/2-30*scalew,y: middleView.frame.size.height/2-30*scaleh,width: 60*scalew,height: 60*scaleh))
        //        middlebut.setBackgroundImage(UIImage(named: "中间确定"), forState: UIControlState.Normal)
        middlebut.setTitle(NSLocalizedString("确认", comment: ""), for: UIControlState())
        middlebut.setTitleColor(systemColor, for: UIControlState())
        // middlebut.titleLabel?.font = UIFont().fontWithSize(14.0)
        middlebut.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        middleView.addSubview(Upbut)
        middleView.addSubview(lowerbut)
        middleView.addSubview(Leftbut)
        middleView.addSubview(rightbut)
        middleView.addSubview(middlebut)
        Upbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        lowerbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        Leftbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        middlebut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        rightbut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        Upbut.tag = (index)*500+3+150
        lowerbut.tag = (index)*500+4+150
        Leftbut.tag = (index)*500+5+150
        rightbut.tag = (index)*500+6+150
        middlebut.tag = (index)*500+7+150
        
        self.addLongPass(Upbut)
        self.addLongPass(lowerbut)
        self.addLongPass(Leftbut)
        self.addLongPass(rightbut)
        self.addLongPass(middlebut)
        
        //middleView.insertSubview(Imaview, atIndex: 0)
        // middleView.backgroundColor = UIColor.blackColor()
        // middleView.backgroundColor = UIColor(patternImage: UIImage(named:"中部控件")!)
        //添加周围9个建
        btn1 = UIButton(frame: CGRect(x: (20*scalew),y: openBut.frame.size.height+leab.frame.size.height+20*scaleh,width: 80*scalew,height: 40*scaleh))
        btn1!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn1!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn1!.setTitleColor(UIColor.white, for: UIControlState())
        btn1!.setTitle(dic[String((index)*500+12+150)], for: UIControlState())
        
        btn2 = UIButton(frame: CGRect(x: ScreenWidth/2 - btn1.frame.size.width/2 ,y: btn1.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        btn2!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn2!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn2!.setTitleColor(UIColor.white, for: UIControlState())
        btn2!.setTitle(dic[String((index)*500+13+150)], for: UIControlState())
        
        btn3 = UIButton(frame: CGRect(x: ScreenWidth - btn1.frame.origin.x - btn1.frame.size.width,y: btn1.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        btn3!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn3!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn3!.setTitleColor(UIColor.white, for: UIControlState())
        btn3!.setTitle(dic[String((index)*500+14+150)], for: UIControlState())
        
        
        btn4 = UIButton(frame: CGRect(x: btn1.frame.origin.x , y: middleView.frame.origin.y+middleView.frame.size.height+20*scaleh ,width: 80*scalew,height: 40*scaleh))
        btn4!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn4!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn4!.setTitleColor(UIColor.white, for: UIControlState())
        btn4!.setTitle(dic[String((index)*500+15+150)], for: UIControlState())
        
        btn5 = UIButton(frame: CGRect(x: btn2.frame.origin.x ,y: btn4.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        btn5!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn5!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn5!.setTitleColor(UIColor.white, for: UIControlState())
        btn5!.setTitle(dic[String((index)*500+16+150)], for: UIControlState())
        
        btn6 = UIButton(frame: CGRect(x: btn3.frame.origin.x, y: btn4.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        btn6!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn6!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn6!.setTitleColor(UIColor.white, for: UIControlState())
        btn6!.setTitle(dic[String((index)*500+17+150)], for: UIControlState())
        
        btn7 = UIButton(frame: CGRect(x: btn1.frame.origin.x , y: btn4.frame.origin.y+btn4.frame.size.height+22*scaleh  ,width: 80*scalew,height: 40*scaleh))
        btn7!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn7!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn7!.setTitleColor(UIColor.white, for: UIControlState())
        btn7!.setTitle(dic[String((index)*500+18+150)], for: UIControlState())
        
        btn8 = UIButton(frame: CGRect(x: btn2.frame.origin.x ,y: btn7.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        btn8!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn8!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn8!.setTitleColor(UIColor.white, for: UIControlState())
        btn8!.setTitle(dic[String((index)*500+19+150)], for: UIControlState())
        
        btn9 = UIButton(frame: CGRect(x: btn3.frame.origin.x, y: btn7.frame.origin.y,width: 80*scalew,height: 40*scaleh))
        btn9!.setBackgroundImage(UIImage(named: "情景模式按钮"), for: UIControlState())
        btn9!.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn9!.setTitleColor(UIColor.white, for: UIControlState())
        btn9!.setTitle(dic[String((index)*500+20+150)], for: UIControlState())
        
        //音量加减 节目加减
        let volBackView = UIButton.init(frame: CGRect(x: btn1.frame.origin.x, y: btn1.frame.origin.y + 105*scaleh,width: 50*scalew,height: 110*scaleh))
        volBackView.backgroundColor = mainColor
        volBackView.layer.cornerRadius = 5.0
        volBackView.layer.masksToBounds = true
        volBackView.setTitle("音量", for: UIControlState())
        volBackView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        let newCenter = CGPoint(x: volBackView.center.x, y: middleView.center.y)
        volBackView.center = newCenter
        
        let tvBackView = UIButton.init(frame: CGRect(x: ScreenWidth-volBackView.frame.size.width - volBackView.frame.origin.x, y: volBackView.frame.origin.y,width: volBackView.frame.size.width,height: volBackView.frame.size.height))
        tvBackView.backgroundColor = mainColor
        tvBackView.layer.cornerRadius = 5.0
        tvBackView.layer.masksToBounds = true
        tvBackView.setTitle("曲目", for: UIControlState())
        tvBackView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        SeveBut = UIButton(frame: CGRect(x: 0, y: 0,width: 50*scalew,height: 55*scaleh))
        SeveBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        SeveBut!.setTitleColor(UIColor.white, for: UIControlState())
        SeveBut!.setTitle("+", for: UIControlState())
        
        EightBut = UIButton(frame: CGRect(x: 0, y: 55*scaleh,width: 50*scalew,height: 55*scaleh))
        EightBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        EightBut!.setTitleColor(UIColor.white, for: UIControlState())
        EightBut!.setTitle("-", for: UIControlState())
        
        NightBut = UIButton(frame: CGRect(x: 0, y: 0,width: 50*scalew,height: 55*scaleh))
        NightBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        NightBut!.setTitleColor(UIColor.white, for: UIControlState())
        NightBut!.setTitle("+", for: UIControlState())
        
        TenBut = UIButton(frame: CGRect(x: 0, y: 55*scaleh,width: 50*scalew,height: 55*scaleh))
        TenBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        TenBut!.setTitleColor(UIColor.white, for: UIControlState())
        TenBut!.setTitle("-", for: UIControlState())
        
        SeveBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        EightBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        NightBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        TenBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        
        SeveBut.tag = (index)*500+8+150
        EightBut.tag = (index)*500+9+150
        NightBut.tag = (index)*500+10+150
        TenBut.tag = (index)*500+11+150
        
        self.addLongPass(SeveBut)
        self.addLongPass(EightBut)
        self.addLongPass(NightBut)
        self.addLongPass(TenBut)
        
        volBackView.addSubview(SeveBut)
        volBackView.addSubview(EightBut)
        tvBackView.addSubview(NightBut)
        tvBackView.addSubview(TenBut)
        
        self.addSubview(openBut)
        self.addSubview(closBut)
        self.addSubview(leab)
        self.addSubview(leab1)
        self.addSubview(middleView)
        self.addSubview(btn1!)
        self.addSubview(btn2!)
        self.addSubview(btn3!)
        self.addSubview(btn4!)
        self.addSubview(btn5!)
        self.addSubview(btn6!)
        self.addSubview(btn7!)
        self.addSubview(btn8!)
        self.addSubview(btn9!)
        self.addSubview(volBackView)
        self.addSubview(tvBackView)
        
        
//        let viewww = UIView(frame:CGRectMake(0,0,ScreenWidth,ScreenHeight/1.5))
//        viewww.backgroundColor = UIColor.whiteColor()
//        self.addSubview(viewww)
        
        
        btn1.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn2.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn3.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn4.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn5.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn6.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn7.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn8.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        btn9.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        
        self.addLongPass(btn1)
        self.addLongPass(btn2)
        self.addLongPass(btn3)
        self.addLongPass(btn4)
        self.addLongPass(btn5)
        self.addLongPass(btn6)
        self.addLongPass(btn7)
        self.addLongPass(btn8)
        self.addLongPass(btn9)
        
        btn1.tag = (index)*500+12+150
        btn2.tag = (index)*500+13+150
        btn3.tag = (index)*500+14+150
        btn4.tag = (index)*500+15+150
        btn5.tag = (index)*500+16+150
        btn6.tag = (index)*500+17+150
        btn7.tag = (index)*500+18+150
        btn8.tag = (index)*500+19+150
        btn9.tag = (index)*500+20+150
        
        
        
    }
    typealias setJson = ()->()
    func detajson(_ set:@escaping setJson){
        var datajson = Dictionary<String, String>()
        datajson["\((index)*500+1+150)"] = NSLocalizedString("开", comment: "")
        datajson["\((index)*500+2+150)"] = NSLocalizedString("关", comment: "")
        datajson["\((index)*500+3+150)"] = NSLocalizedString("上", comment: "")
        datajson["\((index)*500+4+150)"] = NSLocalizedString("下", comment: "")
        datajson["\((index)*500+5+150)"] = NSLocalizedString("左", comment: "")
        datajson["\((index)*500+6+150)"] = NSLocalizedString("右", comment: "")
        datajson["\((index)*500+7+150)"] = NSLocalizedString("确定", comment: "")
        datajson["\((index)*500+8+150)"] = NSLocalizedString("+", comment: "")
        datajson["\((index)*500+9+150)"] = NSLocalizedString("-", comment: "")
        datajson["\((index)*500+10+150)"] = NSLocalizedString("+", comment: "")
        datajson["\((index)*500+11+150)"] = NSLocalizedString("-", comment: "")
        datajson["\((index)*500+12+150)"] = NSLocalizedString("静音", comment: "")
        datajson["\((index)*500+13+150)"] = NSLocalizedString("菜单", comment: "")
        datajson["\((index)*500+14+150)"] = NSLocalizedString("音乐", comment: "")
        datajson["\((index)*500+15+150)"] = NSLocalizedString("快进", comment: "")
        datajson["\((index)*500+16+150)"] = NSLocalizedString("播放", comment: "")
        datajson["\((index)*500+17+150)"] = NSLocalizedString("快退", comment: "")
        datajson["\((index)*500+18+150)"] = NSLocalizedString("设置", comment: "")
        datajson["\((index)*500+19+150)"] = NSLocalizedString("暂停", comment: "")
        datajson["\((index)*500+20+150)"] = NSLocalizedString("返回", comment: "")
        print(dataDeal.toJSONString(jsonSource: datajson as AnyObject))
        print("D"+String(index))
        print("完成添加A")
        let jsonDic = ["classesInfo":"D"+String(self.index) ,
                       "infraredButtonsInfo":dataDeal.toJSONString(jsonSource: datajson as AnyObject),
            "deviceAddress":equip!.equipID,
            "deviceCode":equip!.hostDeviceCode
        ]
        print(jsonDic)
        BaseHttpService.sendRequestAccess(createButton, parameters: jsonDic as NSDictionary) { (Arr) -> () in
            set()
        }
    }
    @objc func butt(_ but:UIButton){
        print("----"+String(but.tag));
        if self.isMoni
        {
            self.equip?.status = String(but.tag)+","+dic[String(but.tag)]!+","+"D"
            
            app.modelEquipArr[(indexqj?.row)!] = self.equip!
            
            self.parentController()?.navigationController!.popViewController(animated: true)
            return
        }
        let parameters = ["deviceAddress":equip!.equipID,
            "isStudy":String(1),
            "infraredButtonsValuess":String(but.tag)+","+"D"]
        print(parameters)
        BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
            print(response)
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
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(FourthTableViewCell.longPress(_:)))
        
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
            if self.dtag < (index)*500+150+12{
                let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("学习", comment: ""))
                actionSheet?.show(in: self.superview!)
            }else{
                let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("学习", comment: ""),NSLocalizedString("修改名称", comment: ""))
                actionSheet?.show(in: self.superview!)
            }
            
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
            print(a)
            switch self.dtag{
            case (index)*500+12:
                btn1.setTitle(a, for: UIControlState())
                break
            case (index)*500+13:
                btn2.setTitle(a, for: UIControlState())
                break
            case (index)*500+14:
                btn3.setTitle(a, for: UIControlState())
                break
            case (index)*500+15:
                btn4.setTitle(a, for: UIControlState())
                break
            case (index)*500+16:
                btn5.setTitle(a, for: UIControlState())
                break
            case (index)*500+17:
                btn6.setTitle(a, for: UIControlState())
                break
            case (index)*500+18:
                btn7.setTitle(a, for: UIControlState())
                break
            case (index)*500+19:
                btn8.setTitle(a, for: UIControlState())
                break
            case (index)*500+20:
                btn9.setTitle(a, for: UIControlState())
                break
            default :
                break
            }
            let parameters = ["deviceAddress":equip!.equipID,
                "deviceCode":equip!.hostDeviceCode,
                "infraredButtonsValuess":String(self.dtag),
                "infraredButtonsName":a]
            print(parameters)
            BaseHttpService .sendRequestAccess(updatebutten, parameters:parameters as NSDictionary) { (response) -> () in
                print(response)
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
