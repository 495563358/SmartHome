//
//  NormalBMTableViewCell.swift
//  SmartHome
//
//  Created by Smart house on 2018/4/19.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class NormalBMTableViewCell: UITableViewCell,UIActionSheetDelegate,UIAlertViewDelegate {
    var index = 0
    var dic = [String:String]();
    var equip:Equip?
    var OneBut:UIButton!
    var TwoBut:UIButton!
    var ThreeBut:UIButton!
    var isMoni:Bool = false
    var indexqj:IndexPath?
    
    var SeveBut:UIButton!
    var EightBut:UIButton!
    var NightBut:UIButton!
    var TenBut:UIButton!
    
    //数字键盘
    var butNum:NSMutableArray?
    
    func setup(){
        var scalew = ScreenWidth / 320
        var scaleh = ScreenHeight / 568
        
        if scalew >= 1{
            scalew = scalew/1.2
            scaleh = scaleh/1.2
        }
        
        let backgroundImg = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64))
        backgroundImg.image = UIImage(named: "hongwai_beijing")
        self.addSubview(backgroundImg)
        
        let openBut = UIButton(frame:CGRect(x: 30*scalew, y: 5*scaleh, width: 50*scalew, height: 50*scalew))
        let closBut = UIButton(frame:CGRect(x: ScreenWidth - openBut.frame.size.width - (30)*scalew, y: 5*scaleh, width: openBut.frame.size.width, height: openBut.frame.size.height))
        //开关
        openBut.setBackgroundImage(UIImage(named: "开电视"), for: UIControlState())
        //openBut.showBadgeWithStyle(WBadgeStyleRedDot, value: 22, animationType: WBadgeAnimTypeNone)
        closBut.setBackgroundImage(UIImage(named: "关电视"), for: UIControlState())
        openBut.addTarget(self, action: #selector(FirstTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
        closBut.addTarget(self, action: #selector(FirstTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
        openBut.tag = (index)*500+1+350
        closBut.tag = (index)*500+2+350
        self.addLongPass(openBut)
        self.addLongPass(closBut)
        
        //文字
        let leab = UILabel(frame: CGRect(x: 30*scalew,y: openBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        let leab1 = UILabel(frame: CGRect(x: ScreenWidth - openBut.frame.size.width-(30)*scalew,y: closBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        leab.text = NSLocalizedString("开", comment: "")
        //        if dic.count > 0
        //        {
        //            leab.text = dic[String((index?.row)!*100+1)];
        //        }
        leab1.text = NSLocalizedString("关", comment: "")
        leab.textColor = UIColor.white
        leab1.textColor = UIColor.white
        leab.textAlignment = NSTextAlignment.center;
        leab1.textAlignment = NSTextAlignment.center ;
        
        
        var tempw = scalew
        var temph = scaleh
        if scalew != 1{
            tempw = scalew*1.8
            temph = scaleh/1.1
        }
        //中部图片
        let middleView = UIView(frame:CGRect(x: (openBut.frame.size.width+35*tempw),y: openBut.frame.size.height+leab.frame.size.height+120*temph,width: ScreenWidth-((openBut.frame.size.width+35*tempw)*2),height: ScreenWidth-((openBut.frame.size.width+35*tempw)*2)))
        let Imaview = UIImageView(image:UIImage(named:"dians_caidan"))
        Imaview.frame=middleView.bounds
        Imaview.autoresizingMask = UIViewAutoresizing.flexibleWidth
        middleView.addSubview(Imaview)
        //添加上下左右确定
        let Upbut = UIButton(frame: CGRect(x: middleView.frame.size.width/2-13*scalew,y: 15*scaleh,width: 27*scalew,height: 15*scaleh))
        //        Upbut.setBackgroundImage(UIImage(named: "hongwai_shang"), for: UIControlState())
        
        let lowerbut = UIButton(frame: CGRect(x: middleView.frame.size.width/2-13*scalew,y: middleView.frame.size.height - 15*scaleh-20*scaleh,width: 27*scalew,height: 15*scaleh))
        //        lowerbut.setBackgroundImage(UIImage(named: "hongwai_xia"), for: UIControlState())
        
        let Leftbut = UIButton(frame: CGRect(x: 15*scalew,y: middleView.frame.size.width/2 - 13*scaleh,width: 15*scalew,height: 27*scaleh))
        //        Leftbut.setBackgroundImage(UIImage(named: "hongwai_zuo"), for: UIControlState())
        
        let rightbut = UIButton(frame: CGRect(x: middleView.frame.size.width-15*scalew-20*scalew,y: middleView.frame.size.width/2 - 13*scaleh,width: 15*scalew,height: 27*scaleh))
        //        rightbut.setBackgroundImage(UIImage(named: "hongwai_you"), for: UIControlState())
        
        let middlebut = UIButton(frame: CGRect(x: middleView.frame.size.width/2-30*scalew,y: middleView.frame.size.height/2-30*scaleh,width: 60*scalew,height: 60*scaleh))
        //        middlebut.setBackgroundImage(UIImage(named: "中间确定"), forState: UIControlState.Normal)
        //        middlebut.setTitle(NSLocalizedString("确认", comment: ""), for: UIControlState())
        //        middlebut.setTitleColor(systemColor, for: UIControlState())
        // middlebut.titleLabel?.font = UIFont().fontWithSize(14.0)
        //        middlebut.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
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
        Upbut.tag = (index)*500+3+350
        lowerbut.tag = (index)*500+4+350
        Leftbut.tag = (index)*500+5+350
        rightbut.tag = (index)*500+6+350
        middlebut.tag = (index)*500+7+350
        
        self.addLongPass(Upbut)
        self.addLongPass(lowerbut)
        self.addLongPass(Leftbut)
        self.addLongPass(rightbut)
        self.addLongPass(middlebut)
        
        //middleView.insertSubview(Imaview, atIndex: 0)
        // middleView.backgroundColor = UIColor.blackColor()
        // middleView.backgroundColor = UIColor(patternImage: UIImage(named:"中部控件")!)
        //添加周围6个建
        OneBut = UIButton(frame: CGRect(x: (30*scalew),y: openBut.frame.size.height+leab.frame.size.height+35*scaleh,width: 70*scalew,height: 40*scalew))
        OneBut!.setBackgroundImage(UIImage(named: "bm_jingyin"), for: UIControlState())
        
        
        TwoBut = UIButton(frame: CGRect(x: ScreenWidth/2 - OneBut.frame.size.width/2 ,y: OneBut.frame.origin.y,width: OneBut.mj_w,height: OneBut.mj_h))
        TwoBut!.setBackgroundImage(UIImage(named: "bm_yinyue"), for: UIControlState())
        
        
        ThreeBut = UIButton(frame: CGRect(x: ScreenWidth - OneBut.frame.origin.x - OneBut.frame.size.width,y: OneBut.frame.origin.y,width: OneBut.mj_w,height: OneBut.mj_h))
        ThreeBut!.setBackgroundImage(UIImage(named: "bm_eq"), for: UIControlState())
        
        
        //音量加减 节目加减
        let volBackView = UIButton.init(frame: CGRect(x: OneBut.frame.origin.x, y: OneBut.frame.origin.y+OneBut.frame.size.height+22*scaleh + 105*scaleh,width: 50*scalew,height: 110*scaleh))
        //        volBackView.backgroundColor = mainColor
        //        volBackView.layer.cornerRadius = 5.0
        //        volBackView.layer.masksToBounds = true
        //        volBackView.setTitle("音量", for: UIControlState())
        //        volBackView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        volBackView.setImage(UIImage(named: "dians_yinliang"), for: .normal)
        let newCenter = CGPoint(x: volBackView.center.x, y: middleView.center.y)
        volBackView.center = newCenter
        
        let tvBackView = UIButton.init(frame: CGRect(x: ScreenWidth-volBackView.frame.size.width - volBackView.frame.origin.x, y: volBackView.frame.origin.y,width: volBackView.frame.size.width,height: volBackView.frame.size.height))
        //        tvBackView.backgroundColor = mainColor
        //        tvBackView.layer.cornerRadius = 5.0
        //        tvBackView.layer.masksToBounds = true
        //        tvBackView.setTitle("节目", for: UIControlState())
        //        tvBackView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        tvBackView.setImage(UIImage(named: "dians_jiemu"), for: .normal)
        
        
        SeveBut = UIButton(frame: CGRect(x: 0, y: 0,width: 50*scalew,height: 55*scaleh))
        //        SeveBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        //        SeveBut!.setTitleColor(UIColor.white, for: UIControlState())
        //        SeveBut!.setTitle("+", for: UIControlState())
        
        EightBut = UIButton(frame: CGRect(x: 0, y: 55*scaleh,width: 50*scalew,height: 55*scaleh))
        //        EightBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        //        EightBut!.setTitleColor(UIColor.white, for: UIControlState())
        //        EightBut!.setTitle("-", for: UIControlState())
        
        NightBut = UIButton(frame: CGRect(x: 0, y: 0,width: 50*scalew,height: 55*scaleh))
        //        NightBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        //        NightBut!.setTitleColor(UIColor.white, for: UIControlState())
        //        NightBut!.setTitle("+", for: UIControlState())
        
        TenBut = UIButton(frame: CGRect(x: 0, y: 55*scaleh,width: 50*scalew,height: 55*scaleh))
        //        TenBut!.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        //        TenBut!.setTitleColor(UIColor.white, for: UIControlState())
        //        TenBut!.setTitle("-", for: UIControlState())
        
        SeveBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        EightBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        NightBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        TenBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        
        SeveBut.tag = (index)*500+14+350
        EightBut.tag = (index)*500+15+350
        NightBut.tag = (index)*500+16+350
        TenBut.tag = (index)*500+17+350
        
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
        self.addSubview(OneBut!)
        self.addSubview(TwoBut!)
        self.addSubview(ThreeBut!)
        self.addSubview(volBackView)
        self.addSubview(tvBackView)
        
        
        OneBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        TwoBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        ThreeBut.addTarget(self, action: "butt:", for: UIControlEvents.touchUpInside)
        
        self.addLongPass(OneBut)
        self.addLongPass(TwoBut)
        self.addLongPass(ThreeBut)
        
        OneBut.tag = (index)*500+8+350
        TwoBut.tag = (index)*500+9+350
        ThreeBut.tag = (index)*500+10+350
        
        setup2()
        
    }
    
    
    
    func setup2(){
        
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
        
        var numView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height/2 * 1.05 - 10*scaleh, width: ScreenWidth, height: ScreenHeight * 0.33))
        
        let imgArr = ["bm_shangyiqu","bm_bofang","bm_xiayiqu","bm_kuaijin","bm_zanting","bm_kuaitui","bm_shez","bm_fanhui","bm_aux","bm_manfang","bm_tingzhi","bm_caidan"]
        
        var btag = 1
        for var i in 0...3
        {
            
            for var j in 0...2
            {
                let but = UIButton(frame: CGRect(x: CGFloat(Float(j))*(110*tempw) + 15*tempw + 10,y: CGFloat(Float(i))*53*scaleh + 20*scaleh,width: 70*scalew,height: 40*scalew))
//                but.backgroundColor = UIColor.white
                but.tag = (index)*500 + 350 + btag + 30
                but.setImage(UIImage(named: imgArr[btag - 1]), for: .normal)
//                but.setTitleColor(systemColor, for: .normal)
//                but.setTitle(dic[String((index)*500 + 380 + btag)], for: UIControlState())
                numView.addSubview(but)
                but.addTarget(self, action: #selector(NormalBMTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
                but.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
                self.addLongPass(but)
                butNum?.add(but)
                btag += 1;
                j += 1
            }
            i += 1
        }
        self.addSubview(numView)
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
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(NormalTVTableViewCell.longPress(_:)))
        
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
            case (index)*500+8+350:
                OneBut.setTitle(a, for: UIControlState())
                let parameters = ["deviceAddress":equip!.equipID,
                                  "deviceCode":equip!.hostDeviceCode,
                                  "infraredButtonsValuess":String(self.dtag),
                                  "infraredButtonsName":a]
                print(parameters)
                BaseHttpService .sendRequestAccess(updatebutten, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
                break
            case (index)*500+9+350:
                TwoBut.setTitle(a, for: UIControlState())
                let parameters = ["deviceAddress":equip!.equipID,
                                  "deviceCode":equip!.hostDeviceCode,
                                  "infraredButtonsValuess":String(self.dtag),
                                  "infraredButtonsName":a]
                print(parameters)
                BaseHttpService .sendRequestAccess(updatebutten, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
                break
            case (index)*500+10+350:
                ThreeBut.setTitle(a, for: UIControlState())
                let parameters = ["deviceAddress":equip!.equipID,
                                  "deviceCode":equip!.hostDeviceCode,
                                  "infraredButtonsValuess":String(self.dtag),
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
    
    
    
    @objc func butt(_ but:UIButton){
        print("----"+String(but.tag));
        if self.isMoni
        {
            self.equip?.status = String(but.tag)+","+dic[String(but.tag)]!+","+"H"
            app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
            print(self.equip?.status)
            self.parentController()?.navigationController!.popViewController(animated: true)
            return
        }
        let parameters = ["deviceAddress":equip!.equipID,
                          "isStudy":String(1),
                          "infraredButtonsValuess":String(but.tag)+","+"H"]
        print(parameters)
        BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
            print(response)
        }
    }
    
    typealias setJson = ()->()
    func detajson(_ set:@escaping setJson){
        var datajson = Dictionary<String, String>()
        datajson["\((index)*500+350+1)"] = NSLocalizedString("开", comment: "")
        datajson["\((index)*500+350+2)"] = NSLocalizedString("关", comment: "")
        datajson["\((index)*500+350+3)"] = NSLocalizedString("上", comment: "")
        datajson["\((index)*500+350+4)"] = NSLocalizedString("下", comment: "")
        datajson["\((index)*500+350+5)"] = NSLocalizedString("左", comment: "")
        datajson["\((index)*500+350+6)"] = NSLocalizedString("右", comment: "")
        datajson["\((index)*500+350+7)"] = NSLocalizedString("确定", comment: "")
        datajson["\((index)*500+350+8)"] = NSLocalizedString("静音", comment: "")
        datajson["\((index)*500+350+9)"] = NSLocalizedString("音乐", comment: "")
        datajson["\((index)*500+350+10)"] = NSLocalizedString("EQ", comment: "")
        datajson["\((index)*500+350+14)"] = NSLocalizedString("+", comment: "")
        datajson["\((index)*500+350+15)"] = NSLocalizedString("-", comment: "")
        datajson["\((index)*500+350+16)"] = NSLocalizedString("+", comment: "")
        datajson["\((index)*500+350+17)"] = NSLocalizedString("-", comment: "")
        
        //数字键盘从30开始
        for i in 1...13
        {
            datajson["\((index)*500 + 350 + 30 + i)"] = "\(i)"
            
            if i == 10{
                datajson["\((index)*500 + 350 + 30 + i)"] = "-/--"
            }else if i == 11{
                datajson["\((index)*500 + 350 + 30 + i)"] = "0"
            }else if i == 12{
                datajson["\((index)*500 + 350 + 30 + i)"] = "回看"
            }
            
        }
        print(dataDeal.toJSONString(jsonSource: datajson as AnyObject))
        print("H"+String(index))
        print("完成添加H")
        let jsonDic = ["classesInfo":"H"+String(self.index) ,
                       "infraredButtonsInfo":dataDeal.toJSONString(jsonSource: datajson as AnyObject),
                       "deviceAddress":equip!.equipID,
                       "deviceCode":equip!.hostDeviceCode
        ]
        print(jsonDic)
        BaseHttpService.sendRequestAccess(createButton, parameters: jsonDic as NSDictionary) { (Arr) -> () in
            set()
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
