//
//  NormalACTableViewCell.swift
//  SmartHome
//
//  Created by Smart house on 2018/4/19.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class NormalACTableViewCell: UITableViewCell,UIActionSheetDelegate,UIAlertViewDelegate {
    var index = 0
    
    var equip:Equip?
    var smallProgress:QLCycleProgressView? =  QLCycleProgressView(frame: CGRect(x: 0,y: 30,width: ScreenWidth/1.8 ,height: ScreenWidth/1.8))
    var leb = UIButton()
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
        
        let backgroundImg = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64))
        backgroundImg.image = UIImage(named: "hongwai_beijing")
        self.addSubview(backgroundImg)
        
        let openBut = UIButton(frame:CGRect(x: 20*scalew, y: 5*scaleh, width: 50*scalew, height: 50*scalew))
        let closBut = UIButton(frame:CGRect(x: ScreenWidth - openBut.frame.size.width - (20)*scalew, y: 5*scaleh, width: openBut.frame.size.width, height: openBut.frame.size.height))
        //开关
        openBut.setBackgroundImage(UIImage(named: "开电视"), for: UIControlState())
        closBut.setBackgroundImage(UIImage(named: "关电视"), for: UIControlState())
        openBut.tag = (index)*500 + 300 + 3
        closBut.tag = (index)*500 + 300  + 4
        openBut.addTarget(self, action: #selector(NormalACTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside )
        closBut.addTarget(self, action: #selector(NormalACTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside )
        addLongPass(openBut)
        addLongPass(closBut)
        //文字
        let leab = UILabel(frame: CGRect(x: 20*scalew,y: openBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        let leab1 = UILabel(frame: CGRect(x: ScreenWidth - openBut.frame.size.width-(20)*scalew,y: closBut.frame.size.height+10*scaleh,width: 50*scalew,height: 20*scaleh))
        leab.text = NSLocalizedString("开", comment: "")
        leab1.text = NSLocalizedString("关", comment: "")
        leab.textColor = UIColor.white
        leab1.textColor = UIColor.white
        leab.textAlignment = NSTextAlignment.center
        leab1.textAlignment = NSTextAlignment.center
        // self.smallProgress =
        //self.smallProgress?.frame = CGRectMake(0,0,ScreenWidth ,ScreenWidth*2/3)
        self.smallProgress!.center = CGPoint(x: ScreenWidth/2, y: ScreenWidth / 2.3)
        self.smallProgress!.backgroundColor = UIColor.clear
        self.smallProgress!.mainColor = UIColor.white//
        self.smallProgress?.fillColor = UIColor(red: 120/255.0, green: 215/255.0, blue: 252/255.0, alpha: 1)
        //控制
        self.smallProgress!.progress = 10 / 15.0;
        //度数
        self.leb = UIButton(frame: CGRect(x: ScreenWidth/2-72*scalew,y: ScreenHeight/4-50*scaleh,width: 150*scalew,height: 80*scaleh))
        self.leb.setTitle("25°", for: UIControlState())
        self.leb.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        self.leb.titleLabel?.font = UIFont.systemFont(ofSize: 45.0)
        self.leb.setTitleColor(UIColor.white, for: UIControlState())
        self.leb.tag = (index)*500 + 300  + 5
        
        
        
        //按钮view
        //加
        let sbut = UIButton(frame: CGRect(x: ScreenWidth - 60*scalew,y: self.smallProgress!.center.y,width: 40*scalew,height: 40*scalew))
        sbut.setImage(UIImage(named: "ac_+"), for: UIControlState())
        sbut.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        sbut.backgroundColor = UIColor.clear
        sbut.tag = (index)*500 + 300  + 1
        sbut.addTarget(self, action: #selector(NormalACTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside )
        addLongPass(sbut)
        
        //减
        let xbut = UIButton(frame: CGRect(x: 20*scalew,y: self.smallProgress!.center.y,width: 40*scalew,height: 40*scalew))
        xbut.setImage(UIImage(named: "ac_-"), for: UIControlState())
        xbut.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        xbut.tag = (index)*500 + 300  + 2
        xbut.addTarget(self, action: #selector(NormalACTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside )
        addLongPass(xbut)
        xbut.backgroundColor = UIColor.clear
        
        
        let spaceX = (ScreenWidth - 2 * openBut.mj_x - 3 * 75 * scalew)/2 + 75 * scalew
        let spaceY = (75 + 16) * scalew
        
        let imgArr = ["ac_zhileng","ac_zhire","ac_shuimian","ac_dinshi","ac_baifeng","ac_fengsu","ac_chushi","ac_moshi","ac_gongneng"]
        
        var btag = 40
        for var i in 0...2
        {
            
            for var j in 0...2
            {
                let but = UIButton(frame: CGRect(x: CGFloat(Float(j))*spaceX + openBut.mj_x,y: CGFloat(Float(i))*spaceY + ScreenHeight/2-20*scaleh-40,width: 75*scalew,height: 75*scalew))
//                but.backgroundColor = UIColor.white
                but.tag = (index)*500 + 300 + btag
                but.setBackgroundImage(UIImage(named: imgArr[btag - 40]), for: UIControlState())
                self.addSubview(but)
                but.addTarget(self, action: #selector(NormalACTableViewCell.butt(_:)), for: UIControlEvents.touchUpInside)
                but.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
                self.addLongPass(but)
//                butNum?.add(but)
                btag += 1;
                j += 1
            }
            i += 1
        }
        
        self.addSubview(leab)
        self.addSubview(leab1)
        self.addSubview(self.smallProgress!)
        self.addSubview(leb)
        self.addSubview(sbut)
        self.addSubview(xbut)
        self.addSubview(openBut)
        self.addSubview(closBut)
        
    }
    var temperature = 0 //红外的唯一表示
    //var current = 16 //当前温度
    var current = 10 //当前温度
    var bool = false //判断制冷制热 false 制冷
    
    typealias setJson = () -> ()
    
    func detajson(_ set:@escaping setJson){
        var dic = Dictionary<String,String>()
        dic["\((index)*500 + 300 + 4)"] = "关"
        dic["\((index)*500 + 300 + 3)"] = "开"
        dic["\((index)*500 + 300 + 40)"] = "制冷"
        dic["\((index)*500 + 300 + 41)"] = "制热"
        dic["\((index)*500 + 300 + 42)"] = "睡眠"
        for var i in 10...39
        {
            if i<25{
                dic["\((index)*500 + 300 + i)"] = "制冷\(i+6)°"
            }else{
                dic["\((index)*500 + 300 + i)"] = "制热\(i-9)°"
            }
            
        }
        print("G"+String(index))
        print(dataDeal.toJSONString(jsonSource: dic as AnyObject))
        let jsonDic = ["classesInfo":"G"+String(self.index) ,
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
    // var zhire = 34
    @objc func butt(_ but:UIButton){
        
        switch but.tag{
        case (index)*500 + 300  + 1:
            
            //加
            if bool{
                if zhileng+15 >= 39{
                    return
                }
                zhileng = zhileng+1
                temperature = (index)*500 + 300 + zhileng + 15
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng-9) / 15.0
                self.leb.setTitle("\(zhileng+15-9)°", for: UIControlState())
            }else{
                if zhileng >= 24{
                    return
                }
                zhileng = zhileng + 1
                temperature = (index)*500 + 300 + zhileng
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng+6 - 15) / 15.0
                self.leb.setTitle("\(zhileng+6)°", for: UIControlState())
            }
            
            
            print("1,\(temperature),\(bool)")
            if self.isMoni
            {
                self.equip?.status = String(temperature)+","+(self.leb.titleLabel?.text)!
                app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
                self.parentController()?.navigationController!.popViewController(animated: true)
                return
            }
            print("----"+String(temperature));
            if isBool == 1{
                let parameters = ["deviceAddress":equip!.equipID,
                                  "isStudy":String(isBool),
                                  "infraredButtonsValuess":String(temperature)+","+"G"]
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
        case (index)*500 + 300  + 2:
            print(zhileng)
            //减
            
            if isBool == 1
            {
                let parameters = ["deviceAddress":equip!.equipID,
                                  "isStudy":String(isBool),
                                  "infraredButtonsValuess":String(temperature)+","+"G"]
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
                return;
            }
            
            if bool{
                if zhileng+15 < 25{
                    return
                }
                zhileng = zhileng-1
                temperature = (index)*500 + 300 + zhileng + 15
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng-9) / 15.0
                self.leb.setTitle("\(zhileng+15-9)°", for: UIControlState())
            }else{
                if zhileng < 10{
                    return
                }
                zhileng = zhileng - 1
                temperature = (index)*500 + 300 + zhileng
                print(temperature)
                self.smallProgress!.progress = CGFloat(zhileng+6 - 15) / 15.0
                self.leb.setTitle("\(zhileng+6)°", for: UIControlState())
            }
            
            //            self.leb.setTitle("\(current)°", forState: UIControlState.Normal)
            //            temperature = (index)!*500 + 300+25+( bool ? 1 : -1) * current
            print("2,\(temperature),\(bool)")
            if self.isMoni
            {
                //                self.equip?.status = String(temperature)+","+(self.leb.titleLabel?.text)!
                //                app.modelEquipArr.replaceObjectAtIndex((indexqj?.row)!, withObject: self.equip!)
                //
                //                self.parentController()?.navigationController!.popViewControllerAnimated(true)
                return
            }
            print("----"+String(temperature));
            
            
            
            break
        case (index)*500 + 300  + 40:
            //制冷
            bool = false
            if isBool == 1
            {
                print("----"+String(but.tag));
                let parameters = ["deviceAddress":equip!.equipID,
                                  "isStudy":String(isBool),
                                  "infraredButtonsValuess":String(but.tag)+","+"G"]
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
        case (index)*500 + 300  + 41:
            //制热
            bool = true
            if isBool == 1
            {
                print("----"+String(but.tag));
                let parameters = ["deviceAddress":equip!.equipID,
                                  "isStudy":String(isBool),
                                  "infraredButtonsValuess":String(but.tag)+","+"G"]
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
        
        /*开关*/
        case (index)*500 + 300  + 3:
            if self.isMoni
            {
                self.equip?.status = String(but.tag)+","+("开")+","+"G"
                app.modelEquipArr.replaceObject(at: (indexqj?.row)!, with: self.equip!)
                
                self.parentController()?.navigationController!.popViewController(animated: true)
                return
            }
            //temperature = (index?.row)!*100 + 1
            
            if isBool == 1
            {//控制
                print("----"+String(but.tag));
                let parameters = ["deviceAddress":equip!.equipID,
                                  "isStudy":String(isBool),
                                  "infraredButtonsValuess":String(but.tag)+","+"G"]
                print(parameters)
                BaseHttpService .sendRequestAccess(studyandcommand, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                }
            }
            else
            {//学习
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
        case (index)*500 + 300 + 4:
            if self.isMoni
            {
                self.equip?.status = String(but.tag)+","+("关")+","+"G"
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
                                  "infraredButtonsValuess":String(but.tag)+","+"G"]
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
            if self.isMoni
            {
                self.equip?.status = String(but.tag)+","+("开")+","+"G"
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
                                  "infraredButtonsValuess":String(but.tag)+","+"G"]
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
    //添加按钮长按事件
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        self.btag = (sender.view?.tag)!
        if sender.state == UIGestureRecognizerState.began{
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: NSLocalizedString("学习", comment: ""), otherButtonTitles:NSLocalizedString("学习完成", comment: ""))
            actionSheet?.show(in: self.superview!)
        }
    }
    //长按事件
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //取消
            self.isBool = 0
            zhileng = 9
            bool = false
            temperature = (index)*500 + 300 + zhileng
            print("气温 = \(temperature)")
            self.smallProgress!.progress = CGFloat(zhileng+6+1 - 15) / 15.0
            self.leb.setTitle("\(zhileng+6+1)°", for: UIControlState())
            print("学习")
            break
        case 1:
            print("取消")
            break
        case 2:
            print("学习完成")
            self.isBool = 1
            zhileng = 19
            bool = false
            temperature = (index)*500 + 300 + zhileng
            print("气温 = \(temperature)")
            self.smallProgress!.progress = CGFloat(zhileng+6 - 15) / 15.0
            self.leb.setTitle("\(zhileng+6)°", for: UIControlState())
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
