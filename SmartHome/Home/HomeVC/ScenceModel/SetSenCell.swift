//
//  SetSenCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/23.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class SetSenCell: UITableViewCell {
    var nameLeab:UILabel!
    var switchBut:UISwitch!
    var setName:UIButton!
    var studyBut:UIButton!
    
    var OneButLab2:UILabel!
    var OneButLab4:UILabel!
    var TwoButLab2:UILabel!
    var TwoButLab4:UILabel!
    var ThreeButLab2:UILabel!
    var ThreeButLab4:UILabel!
    
    var OneButSwhit:UIButton!
    var TwoButSwhit:UIButton!
    var ThreeButSwhit:UIButton!
    
    var oneBool:String = "1"
    var towBool:String = "1"
    var threeBool:String = "1"
    
    var  model:SensorModel?
    
    func setinit(){
        
        
        self.nameLeab.text = self.model?.SensorName
        if self.model?.sensorType == "0"
        {
            self.switchBut.setOn(false, animated: true)
        }
        else
        {
            self.switchBut.setOn(true, animated: true)
        }
        if self.model?.sensorTimer.count == 0 {
            return
        }
        for var i in 0...(self.model?.sensorTimer.count)!-1
        {
            switch i{
            case 0:
                print((self.model?.sensorTimer[i]))
                let arr = (self.model?.sensorTimer[i])!.components(separatedBy: ",")
                self.OneButLab2.text = (arr[0])
                
                self.OneButLab4.text = (arr[1])
                if arr[2] == "0"{
                    self.OneButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                    self.oneBool = "0"
                }else{
                    self.OneButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                    self.oneBool = "1"
                }
                print(self.OneButLab2.text)
                print(self.OneButLab4.text)
                //print((self.model?.sensorTimer[i])! as NSString).substringWithRange(NSMakeRange(4, 1)))
                break
            case 1:
                 let arr = (self.model?.sensorTimer[i])!.components(separatedBy: ",")
                self.TwoButLab2.text = (arr[0])
                self.TwoButLab4.text = (arr[1])
                if arr[2] == "0"{
                    self.TwoButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                    self.towBool = "0"
                }else{
                    self.TwoButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                    self.towBool = "1"
                }
                break
            case 2:
                 let arr = (self.model?.sensorTimer[i])!.components(separatedBy: ",")
                self.ThreeButLab2.text = arr[0]
                self.ThreeButLab4.text = arr[1]
                if arr[2] == "0"{
                    self.ThreeButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                    self.threeBool = "0"
                }else{
                    self.ThreeButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                    self.threeBool = "1"
                }
                break
            default:
                break
            }
        }
        
    }
    
     var dic1 = [String:[String:[String]]]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "a")
        
        for var index1 in 0...23
        {
            var dic2 = [String:[String]]()
            for var index2 in 0...23
            {
                let defenses = [NSLocalizedString("布防", comment: ""),NSLocalizedString("撤防", comment: "")]
                if index2 < 10
                {
                dic2["0"+String(index2)] = defenses
                }else{
                 dic2[String(index2)] = defenses
                }
            }
           
            if index1 < 10
            {
                 dic1["0"+String(index1)] = dic2
            }else{
                dic1[String(index1)] = dic2
            }
        
        }
    
        let scalew = ScreenWidth / 320
        let scaleh = ScreenHeight / 568
        let imag = UIImageView(image: UIImage(named: "安防"))
        imag.frame = CGRect(x: 5*scalew, y: 5*scaleh, width: 35*scalew, height: 40*scaleh)
        
        nameLeab = UILabel(frame: CGRect(x: imag.frame.size.width + 10*scalew, y: 5*scaleh, width: 65*scalew, height: 40*scaleh))
        nameLeab.text = " "
        nameLeab.font = UIFont.systemFont(ofSize: 15)
        nameLeab.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        
        var setNameX = nameLeab.frame.size.width + imag.frame.size.width + 5*scalew
        setNameX += 10*scalew
        
        setName = UIButton(frame:CGRect(x: setNameX, y: nameLeab.frame.size.height+5*scaleh-20*scaleh, width: 40*scalew, height: 20*scaleh))
        setName.setTitle(NSLocalizedString("修改名称", comment: ""), for: UIControlState())
        setName.addTarget(self, action: #selector(SetSenCell.setName(_:)), for: .touchUpInside)
        //setName.backgroundColor = UIColor.redColor()
        setName.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        setName.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0), for: UIControlState())
        let setNameleb = UILabel(frame:CGRect(x: setNameX, y: nameLeab.frame.size.height+5*scaleh-3*scaleh, width: 40*scalew, height: 1*scaleh))
        setNameleb.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        
        switchBut = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width-60*scalew,y: 10*scaleh,width: 40*scalew, height: 30*scaleh))
        switchBut.addTarget(self, action: #selector(SetSenCell.stateChanged(_:)), for: UIControlEvents.valueChanged)
        
        studyBut = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-60*scalew - switchBut.frame.size.width - 10*scalew,y: 10*scaleh,width: 40*scalew, height: 30*scaleh))
        studyBut.setTitle(NSLocalizedString("学习", comment: ""), for: UIControlState())
        studyBut.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0), for: UIControlState())
        studyBut.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        studyBut.backgroundColor = UIColor.green
        studyBut.layer.cornerRadius = 10.0
        studyBut.tag = 7
        studyBut.addTarget(self, action: #selector(SetSenCell.butswith(_:)), for: .touchUpInside)
        
        
        let OneBut = UIButton(frame: CGRect(x: 10*scalew,y: studyBut.frame.size.height+20*scalew,width: UIScreen.main.bounds.width/1.5,height: 40*scalew))
       // OneBut.backgroundColor = UIColor.redColor()
        let OneButLab1 = UILabel(frame: CGRect(x: 5*scalew,y: 5*scaleh,width: OneBut.frame.size.width/2-45*scalew,height: OneBut.frame.size.height - 10*scaleh))
        OneButLab1.text = NSLocalizedString("开始", comment: "")
        OneButLab2 = UILabel(frame: CGRect(x: OneButLab1.frame.size.width+10*scalew,y: 5*scaleh,width: 30*scalew,height: OneBut.frame.size.height - 10*scaleh))
        
        OneButLab2.text = "0"
        let OneButLab3 = UILabel(frame: CGRect(x: OneButLab1.frame.size.width+OneButLab2.frame.size.width+20*scalew,y: 5*scaleh,width: OneButLab1.frame.size.width,height: OneBut.frame.size.height - 10*scaleh))
        OneButLab3.text = NSLocalizedString("结束", comment: "")
        OneButLab4 = UILabel(frame: CGRect(x: OneButLab1.frame.size.width+OneButLab2.frame.size.width+20*scalew+5*scalew+OneButLab3.frame.size.width,y: 5*scaleh,width: 30*scalew,height: OneBut.frame.size.height - 10*scaleh))
        OneButLab4.text = "0"
        
        OneButLab1.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        OneButLab2.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        OneButLab3.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        OneButLab4.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        OneBut.addSubview(OneButLab1)
        OneBut.addSubview(OneButLab2)
        OneBut.addSubview(OneButLab3)
        OneBut.addSubview(OneButLab4)
        OneBut.tag = 4
        OneBut.addTarget(self, action: #selector(SetSenCell.butTimer(_:)), for: .touchUpInside)
        
        //----------------------------------
        
        OneButSwhit = UIButton(frame: CGRect(x: OneBut.frame.size.width+20*scalew,y: studyBut.frame.size.height+20*scalew,width: UIScreen.main.bounds.width-OneBut.frame.size.width-25*scalew,height: 40*scaleh))
        OneButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
        OneButSwhit.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0), for: UIControlState())
        OneButSwhit.layer.cornerRadius = 10.0
        OneButSwhit.layer.borderWidth = 1.0
        OneButSwhit.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        OneButSwhit.tag = 1
        OneButSwhit.addTarget(self, action: #selector(SetSenCell.butswith(_:)), for: .touchUpInside)
        
        
        
        let TwoBut = UIButton(frame: CGRect(x: 10*scalew,y: OneBut.bottom+10*scaleh,width: UIScreen.main.bounds.width/1.5,height: 40*scalew))
        //TwoBut.backgroundColor = UIColor.redColor()
        let TwoButLab1 = UILabel(frame: CGRect(x: 5*scalew,y: 5*scaleh,width: TwoBut.frame.size.width/2-45*scalew,height: TwoBut.frame.size.height - 10*scaleh))
        TwoButLab1.text = NSLocalizedString("开始", comment: "")
        
        TwoButLab2 = UILabel(frame: CGRect(x: TwoButLab1.frame.size.width+10*scalew,y: 5*scaleh,width: 30*scalew,height: TwoBut.frame.size.height - 10*scaleh))
        TwoButLab2.text = "0"
        
        let TwoButLab3 = UILabel(frame: CGRect(x: TwoButLab1.frame.size.width+TwoButLab2.frame.size.width+20*scalew,y: 5*scaleh,width: TwoButLab1.frame.size.width,height: TwoBut.frame.size.height - 10*scaleh))
        TwoButLab3.text = NSLocalizedString("结束", comment: "")
        
        TwoButLab4 = UILabel(frame: CGRect(x: TwoButLab1.frame.size.width+TwoButLab2.frame.size.width+20*scalew+5*scalew+TwoButLab3.frame.size.width,y: 5*scaleh,width: 30*scalew,height: TwoBut.frame.size.height - 10*scaleh))
        TwoButLab4.text = "0"
        
        TwoButLab1.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        TwoButLab2.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        TwoButLab3.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        TwoButLab4.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        
        TwoBut.addSubview(TwoButLab1)
        TwoBut.addSubview(TwoButLab2)
        TwoBut.addSubview(TwoButLab3)
        TwoBut.addSubview(TwoButLab4)
        TwoBut.tag = 5
        TwoBut.addTarget(self, action: #selector(SetSenCell.butTimer(_:)), for: .touchUpInside)
        //-----------
        
        TwoButSwhit = UIButton(frame: CGRect(x: OneBut.frame.size.width+20*scalew,y: OneBut.bottom+10*scaleh,width: UIScreen.main.bounds.width-OneBut.frame.size.width-25*scalew,height: 40*scaleh))
        TwoButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
        TwoButSwhit.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0), for: UIControlState())
        TwoButSwhit.layer.cornerRadius = 10.0
        TwoButSwhit.layer.borderWidth = 1.0
        TwoButSwhit.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        TwoButSwhit.tag = 2
        TwoButSwhit.addTarget(self, action: #selector(SetSenCell.butswith(_:)), for: .touchUpInside)
        
        
        
        
        let ThreeBut = UIButton(frame: CGRect(x: 10*scalew,y: TwoBut.bottom+10*scaleh,width: UIScreen.main.bounds.width/1.5,height: 40*scalew))
       // ThreeBut.backgroundColor = UIColor.redColor()
        let ThreeButLab1 = UILabel(frame: CGRect(x: 5*scalew,y: 5*scaleh,width: ThreeBut.frame.size.width/2-45*scalew,height: ThreeBut.frame.size.height - 10*scaleh))
        ThreeButLab1.text = NSLocalizedString("开始", comment: "")
        
        ThreeButLab2 = UILabel(frame: CGRect(x: ThreeButLab1.frame.size.width+10*scalew,y: 5*scaleh,width: 30*scalew,height: ThreeBut.frame.size.height - 10*scaleh))
        ThreeButLab2.text = "0"
        
        let ThreeButLab3 = UILabel(frame: CGRect(x: ThreeButLab1.frame.size.width+ThreeButLab2.frame.size.width+20*scalew,y: 5*scaleh,width: ThreeButLab1.frame.size.width,height: ThreeBut.frame.size.height - 10*scaleh))
        ThreeButLab3.text = NSLocalizedString("结束", comment: "")
        
        ThreeButLab4 = UILabel(frame: CGRect(x: ThreeButLab1.frame.size.width+ThreeButLab2.frame.size.width+20*scalew+5*scalew+ThreeButLab3.frame.size.width,y: 5*scaleh,width: 30*scalew,height: ThreeBut.frame.size.height - 10*scaleh))
        ThreeButLab4.text = "0"
        
        ThreeButLab1.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        ThreeButLab2.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        ThreeButLab3.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        ThreeButLab4.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        
        ThreeBut.addSubview(ThreeButLab1)
        ThreeBut.addSubview(ThreeButLab2)
        ThreeBut.addSubview(ThreeButLab3)
        ThreeBut.addSubview(ThreeButLab4)
        ThreeBut.tag = 6
        ThreeBut.addTarget(self, action: #selector(SetSenCell.butTimer(_:)), for: .touchUpInside)
        //------------
        ThreeButSwhit = UIButton(frame: CGRect(x: OneBut.frame.size.width+20*scalew,y: TwoButSwhit.bottom+10*scaleh,width: UIScreen.main.bounds.width-OneBut.frame.size.width-25*scalew,height: 40*scaleh))
        ThreeButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
        ThreeButSwhit.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0), for: UIControlState())
        ThreeButSwhit.layer.cornerRadius = 10.0
        ThreeButSwhit.layer.borderWidth = 1.0
        ThreeButSwhit.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        ThreeButSwhit.tag = 3
        ThreeButSwhit.addTarget(self, action: #selector(SetSenCell.butswith(_:)), for: .touchUpInside)
        
        
        
        self.addSubview(imag)
        self.addSubview(nameLeab)
        
        self.addSubview(setNameleb)
        self.addSubview(setName)
        self.addSubview(switchBut)
        self.addSubview(studyBut)
        self.addSubview(OneBut)
        self.addSubview(OneButSwhit)
        self.addSubview(TwoBut)
        self.addSubview(TwoButSwhit)
        self.addSubview(ThreeBut)
        self.addSubview(ThreeButSwhit)
        setName.isHidden = true
        setNameleb.isHidden = true
        
    }
    
    @objc func setName(_ but:UIButton){
        let alertController = UIAlertController(title:NSLocalizedString("请输入名称", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "名称"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("好的",comment:""), style: .default,
            handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let login = alertController.textFields!.first! as UITextField
                let data = ["deviceCode":self.model!.sensorhost,
                            "deviceAddress":self.model!.SensorID,
                            "sensorName":login.text! ]
                BaseHttpService.sendRequestAccess(setSensorName, parameters: data as NSDictionary, success: { (arr) -> () in
                    self.nameLeab.text = login.text
               })
                print("用户名：\(login.text)")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.parentController()?.present(alertController, animated: true, completion: nil)
    }
    
    @objc func stateChanged(_ switchState: UISwitch) {
        if switchState.isOn {
           print("开")
            let data = ["deviceCode":self.model!.sensorhost,
                        "deviceAddress":self.model!.SensorID,
                        "securityType":"1",
                        "patternType":"1"
                                            ]
            BaseHttpService.sendRequestAccess(setTotalSecuritySwitch, parameters: data as NSDictionary, success: { (arr) -> () in
                
            })
        } else {
           print("关")
            let data = ["deviceCode":self.model!.sensorhost,
                "deviceAddress":self.model!.SensorID,
                "securityType":"0",
                 "patternType":"1"
            ]
            BaseHttpService.sendRequestAccess(setTotalSecuritySwitch, parameters: data as NSDictionary, success: { (arr) -> () in
                
            })
        }
        
    }
    @objc func butTimer(_ but:UIButton){
        
//        var timerArr=[String]()
//        for var i = 1;i<25;i++
//        {
//            timerArr.append("\(i)")
//        }
        
       // let arr = [timerArr,timerArr,timerNum]
        let parent =  self.parentController() as! SetSenViewController
       // let dic = ["111":["121":["11","22"]],"222":["122":["33","44"]]]
       

        switch but.tag{
        
        case 4:
            parent.sunData.title.text = NSLocalizedString("设置时间(小时)", comment: "")
            parent.sunData.setNumberOfComponents(3, set: dic1, addTarget:parent.navigationController!.view , complete: { (one, two, three) -> Void in
                var thr = 0
                if three == NSLocalizedString("撤防", comment: ""){
                    thr = 0
                }else{
                    thr = 1
                }
                let data = [
                    "startTime":one!,
                    "endTime":two!,
                    "security":"\(thr)",
                    "howMany":"1",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                print(one!+"--"+two!+"--"+three!)
                print(data)
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    if three == NSLocalizedString("撤防", comment: ""){
                       self.OneButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                        self.oneBool = "0"
                    }else{
                        self.OneButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                        self.oneBool = "1"
                    }
                    self.OneButLab2.text = one
                    self.OneButLab4.text = two
                    self.model!.sensorTimer[0] = "\(self.OneButLab2.text),\(self.OneButLab4.text),\(thr)"
                })
            })
            break
        case 5:
            parent.sunData.title.text = NSLocalizedString("设置时间(小时)", comment: "")
            parent.sunData.setNumberOfComponents(3, set: dic1, addTarget:parent.navigationController!.view , complete: { (one, two, three) -> Void in
                var thr = 0
                if three == NSLocalizedString("撤防", comment: ""){
                    thr = 0
                }else{
                    thr = 1
                }
                let data = [
                    "startTime":one!,
                    "endTime":two!,
                    "security":"\(thr)",
                    "howMany":"2",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                print(one!+"--"+two!+"--"+three!)
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    if three == NSLocalizedString("撤防", comment: ""){
                        self.TwoButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                        self.towBool = "0"
                    }else{
                        self.TwoButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                        self.towBool = "1"
                    }
                    self.TwoButLab2.text = one
                    self.TwoButLab4.text = two
                     self.model!.sensorTimer[1] = "\(self.OneButLab2.text),\(self.OneButLab4.text),\(thr)"
                })
            })
            break
        case 6:
            parent.sunData.title.text = NSLocalizedString("设置时间(小时)", comment: "")
            parent.sunData.setNumberOfComponents(3, set: dic1, addTarget:parent.navigationController!.view , complete: { (one, two, three) -> Void in
                var thr = 0
                if three == NSLocalizedString("撤防", comment: ""){
                    thr = 0
                }else{
                    thr = 1
                }
                let data = [
                    "startTime":one!,
                    "endTime":two!,
                    "security":"\(thr)",
                    "howMany":"3",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                print(one!+"--"+two!+"--"+three!)
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    if three == NSLocalizedString("撤防", comment: ""){
                        self.ThreeButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                        self.threeBool = "0"
                    }else{
                        self.ThreeButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                        self.threeBool = "1"
                    }
                    self.ThreeButLab2.text = one
                    self.ThreeButLab4.text = two
                    })
                 self.model!.sensorTimer[2] = "\(self.OneButLab2.text),\(self.OneButLab4.text),\(thr)"
                
            })
            break
            
        default :
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
    @objc func butswith(_ but:UIButton){
        switch but.tag{
        
        case 1:
            if oneBool == "0"
            {
                let arr = self.model?.sensorTimer[0].components(separatedBy: ",")
                let data = [
                    "startTime":arr![0],
                    "endTime":arr![1],
                    "security":"1",
                    "howMany":"1",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]

                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                        self.OneButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                        self.oneBool = "1"
                    })
            }
            else if oneBool == "1"
            {
                let arr = self.model?.sensorTimer[0].components(separatedBy: ",")
                let data = [
                    "startTime":arr![0],
                    "endTime":arr![1],
                    "security":"0",
                    "howMany":"1",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    self.OneButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                    self.oneBool = "0"
                    })
            }
            break
        case 2:
            if towBool == "1"
            {
                let arr = self.model?.sensorTimer[1].components(separatedBy: ",")
                let data = [
                    "startTime":arr![0],
                    "endTime":arr![1],
                    "security":"0",
                    "howMany":"2",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    self.TwoButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                    self.towBool = "0"
                    })
            }
            else if towBool == "0"
            {
                let arr = self.model?.sensorTimer[1].components(separatedBy: ",")
                let data = [
                    "startTime":arr![0],
                    "endTime":arr![1],
                    "security":"1",
                    "howMany":"2",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    self.TwoButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                    self.towBool = "1"
                    })
            }
            break
        case 3:
            if threeBool == "0"
            {
                let arr = self.model?.sensorTimer[2].components(separatedBy: ",")
                let data = [
                    "startTime":arr![0],
                    "endTime":arr![1],
                    "security":"1",
                    "howMany":"3",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    self.ThreeButSwhit.setTitle(NSLocalizedString("布防", comment: ""), for: UIControlState())
                    self.threeBool = "1"
                    })
            }
            else if threeBool == "1"
            {
                let arr = self.model?.sensorTimer[2].components(separatedBy: ",")
                let data = [
                    "startTime":arr![0],
                    "endTime":arr![1],
                    "security":"0",
                    "howMany":"3",
                    "deviceAddress":self.model!.SensorID,
                    "deviceCode":self.model!.sensorhost,
                     "patternType":"1"
                ]
                
                BaseHttpService.sendRequestAccess(setSensorSecurityTime, parameters: data as NSDictionary, success: {
                    [unowned self](arr) -> () in
                    self.ThreeButSwhit.setTitle(NSLocalizedString("撤防", comment: ""), for: UIControlState())
                    self.threeBool = "0"
                    })
            }
            break
        case 7:
            let dic = ["deviceAddress":self.model!.SensorID,"deviceCode":self.model!.sensorhost]
            BaseHttpService.sendRequestAccess(studysensor, parameters: dic as NSDictionary) { (back) -> () in
                
            }
            break
        default:
            break
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
