//
//  VerificationDevice.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/2.
//  Copyright © 2017年 sunzl. All rights reserved.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class VerificationDevice:UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var equip:Equip?
    var homeTableView:UITableView!
    var indexNum:Int?//位置
    var flagStr:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "设备对码"
        
        self.homeTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 65), style: UITableViewStyle.plain)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        self.view.addSubview(homeTableView)
        
        self.initView()
        
        self.homeTableView.register(UINib(nibName: "LightCell", bundle: nil), forCellReuseIdentifier: "LightCell")
        
        self.homeTableView.register(UINib(nibName: "ModulateCell", bundle: nil), forCellReuseIdentifier: "ModulateCell")
        self.homeTableView.register(UINib(nibName: "HeadCell", bundle: nil), forCellReuseIdentifier: "HeadCell")
        self.homeTableView.register(UINib(nibName: "RecentModelCell", bundle: nil), forCellReuseIdentifier: "RecentModelCell")
        self.homeTableView.register(UINib(nibName: "UnkownCell", bundle: nil), forCellReuseIdentifier: "UnkownCell")
        self.homeTableView.register(UINib(nibName: "NoDeviceCell", bundle: nil), forCellReuseIdentifier: "NoDeviceCell")
        self.homeTableView.register(UINib(nibName: "InfraredCell", bundle: nil), forCellReuseIdentifier: "InfraredCell")
        self.homeTableView.register(UINib(nibName: "ShotLightCell", bundle: nil), forCellReuseIdentifier: "ShotLightCell")
        self.homeTableView.register(UINib(nibName: "ShotWindowCell", bundle: nil), forCellReuseIdentifier: "ShotWindowCell")
        
        self.homeTableView.register(UINib(nibName: "ShotLockCell", bundle: nil), forCellReuseIdentifier: "ShotLockCell")
        self.homeTableView.register(UINib(nibName: "SensorTableViewCell", bundle: nil), forCellReuseIdentifier: "SensorTableViewCell")
        
        self.homeTableView.register(UINib(nibName: "Modulate2Cell", bundle: nil), forCellReuseIdentifier: "Modulate2Cell")
        
        self.homeTableView.register(UINib(nibName: "boxCell", bundle: nil), forCellReuseIdentifier: "boxCell")
        
        self.homeTableView.register(UINib(nibName: "lockCell", bundle: nil), forCellReuseIdentifier:"lockCell" )
        
        self.homeTableView.register(UINib(nibName: "DuYaCell", bundle: nil), forCellReuseIdentifier:"DuYaCell" )
        
        self.homeTableView.register(UINib(nibName: "SmartLockCell", bundle: nil), forCellReuseIdentifier:"SmartLockCell" )

        // Do any additional setup after loading the view.
    }
    
    func initView(){
        let space = UIView.init(frame: CGRect(x: 0, y: 65, width: ScreenWidth, height: 10))
        space.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        self.view.addSubview(space)
        
        let imgV = UIImageView.init(frame: CGRect(x: ScreenWidth/2-100, y: 75+30, width: 200, height: 200))
        imgV.image = UIImage(named: "zhinengchazuoDM")
        self.view.addSubview(imgV)
        
        
        
        let textL = UILabel.init(frame: CGRect(x: 10, y: 325, width: ScreenWidth - 20, height: ScreenHeight - 474))
        textL.font = UIFont.systemFont(ofSize: 14)
        textL.numberOfLines = 0
        
        self.addTextAndImage(textL,imageV:imgV)
        
//        let tipLab = UILabel.init(frame: CGRectMake(10, 80, ScreenWidth - 20, 70))
//        tipLab.numberOfLines = 0
//        tipLab.textAlignment = .Center
//        tipLab.font = UIFont.systemFontOfSize(14)
//        tipLab.text = "    提示：操作方法仅供参考，具体方法根据不同设备可能有所偏差"
//        self.view.addSubview(tipLab)
        
        let nextStep = UIButton.init(frame: CGRect(x: (ScreenWidth - 192)/2, y: ScreenHeight - 145, width: 192, height: 45))
        nextStep.backgroundColor = systemColor
        nextStep.layer.cornerRadius = 10
        nextStep.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStep.setTitle("完成", for: UIControlState())
        nextStep.addTarget(self, action: #selector(VerificationDevice.handleRightItem), for: UIControlEvents.touchUpInside)
        self.view .addSubview(nextStep)
    }
    
    
    
    func addTextAndImage(_ label:UILabel,imageV:UIImageView){
        let dataArr = ["灯光开关","智能门锁","摄像头","窗帘开关","窗帘电机","卷帘开关","排风扇","插座","空调","电视","热水器","调光开关","智能晾衣架","电动门窗","电动升降架","电动幕布","影音设备","空气净化器","净水机","水管阀门","燃气阀门","浇花灌溉"]
//        ["0灯光开关","1智能门锁","2摄像头","3窗帘开关","4窗帘电机","5卷帘开关","6排风扇","7插座","8空调","9电视","10热水器","11调光开关","12智能晾衣架","13电动门窗","14电动升降架","15电动幕布","16影音设备","17空气净化器","18净水机","19水管阀门","20燃气阀门","21浇花灌溉"]
        
        var typeNum:Int = self.indexNum!
        
        //默认为开关面板
        imageV.contentMode = .scaleAspectFit
        imageV.image = UIImage(named: "dengDM")
        label.text = "    提示：若设备连续通电超过30分钟,则会锁定。若需对码，请重新上电。\n\n    开：按住要对码的面板按键，当左上角指示灯第二次连续闪烁两次后，松手。5秒内，点击应用内当前界面的“开”图标。若对码指示灯继续闪烁1次，则对码成功。\n\n    关：按住要对码的面板按键，左上角指示灯第三次连续闪烁3次后，松手。5秒内，点击应用内当前界面的“关”图标。若对码指示灯继续闪烁1次，则对码成功。"
        
        
        switch self.indexNum!{
        case 0://普通灯光开关面板
            imageV.image = UIImage(named: "dengDM")
            label.text = "    提示：若设备连续通电超过30分钟,则会锁定。若需对码，请重新上电。\n\n    开灯对码：按住要对码的面板按键，当左上角指示灯第二次连续闪烁两次后，松手。5秒内，点击应用内当前界面对应灯的“开”图标。若对码指示灯继续闪烁1次，则对码成功。\n\n    关灯对码：按住要对码的面板按键，左上角指示灯第三次连续闪烁3次后，松手。5秒内，点击应用内当前界面的对应灯的“关”图标。若对码指示灯继续闪烁1次，则对码成功。"
            typeNum = 1
            break
        case 1://智能门锁
            imageV.image = UIImage(named: "duima-suoDM")
            label.text = "    开关锁对码：门锁上按*#，添加用户，语音提示添加密码后，输入00000012345678密码，成功后再添加用户。当提示“请添加指纹、密码或无线设备”后，在应用当前页面上按“开”，门锁会提示添加成功，关锁无需对码。"
            break
        case 2://摄像头
            break
        case 3://窗帘开关
            
            if flagStr == "双轨窗帘"{
                imageV.image = UIImage(named: "shuangguichuanglianDM")
                label.text = "    提示：若设备连续通电超过30分钟,则会锁定。若需对码，请重新上电。\n\n    布窗开对码：面板上电，按住“布窗开”按键-->当面板左上角指示灯连续闪烁2次后，松手-->松手5秒内点击app已创建的窗帘“开窗”图标。若对码指示灯继续闪烁1次，则代表可以使用此图标打开窗帘。\n\n    布窗关对码：按住“布窗关”-->当面板左上角指示灯连续闪烁2次后，松手-->松手5秒内，点击APP已创建的窗帘“关窗”图标。若对码指示灯继续闪烁1次，则代表可以使用此图标关闭窗帘。\n\n     停止对码：按住“布窗开”或“布窗关”-->当面板左上角指示灯连续闪烁3次后，松手-->松手5秒内，点击APP已创建的窗帘“停止”图标。若对码指示灯继续闪烁2次，则代表可以使用此图标使窗帘停止。\n\n    按上述步骤对码完成后即可一次控制多路开关，若需要分开控制，可添加两次设备，依次对码开关即可。"
                
            }else{
                imageV.image = UIImage(named: "chuanglianDM")
                label.text = "    开窗对码：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面对应窗帘的“开”图标。若对码指示灯继续闪烁1次，对码成功\n\n    停止对码：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面对应窗帘的“停”图标。若对码指示灯继续闪烁1次，对码成功\n\n    关窗对码：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面对应窗帘的“关”图标。若对码指示灯继续闪烁1次，对码成功"
            }
            typeNum = 3
            break
        case 4://窗帘电机
            imageV.image = UIImage(named: "chuangliandianjiDM")
            label.text = "    长按窗帘电机上的按钮，当指示灯变绿时，点两下APP上的“学习”图标，指示灯连续闪烁多次说明对码成功。"
            break
        case 5://卷帘开关
            imageV.image = UIImage(named: "juanliankaiguanDM")
            label.text = "    开：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“开”图标。若对码指示灯继续闪烁1次，对码成功\n\n    停：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“停”图标。若对码指示灯继续闪烁1次，对码成功\n\n    关：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“关”图标。若对码指示灯继续闪烁1次，对码成功"
            typeNum = 3
            break
        case 6://排风扇开关面板
            imageV.image = UIImage(named: "dengDM")
            label.text = "    提示：若设备连续通电超过30分钟,则会锁定。若需对码，请重新上电。\n\n    打开对码：按住要对码的面板按键，当左上角指示灯第二次连续闪烁两次后，松手。5秒内，点击应用内当前界面对应灯的“开”图标。若对码指示灯继续闪烁1次，则对码成功。\n\n    关闭对码：按住要对码的面板按键，左上角指示灯第三次连续闪烁3次后，松手。5秒内，点击应用内当前界面的对应灯的“关”图标。若对码指示灯继续闪烁1次，则对码成功。"
            typeNum = 1
            break
        case 7://智能插座
            
            if flagStr == "插排"{
                imageV.image = UIImage(named: "zhinengpaichaDM")
                label.text = "    第1路指示灯熄灭的情况下，长按第1路手动按钮-->当第1路指示灯亮起，且第3路指示灯闪亮一次后，松手-->点击客户端已创建的“开”按钮。若第3路指示灯再次更亮闪烁一次，说明对码成功。\n\n    第1路指示灯亮起的情况下，长按第1路手动按钮-->当第1路指示灯熄灭，且第3路指示灯闪亮一次后，松手-->点击客户端已创建的“关”按钮。若指示灯再次闪亮一次，说明对码成功。\n\n    第2路指示灯熄灭的情况下，长按第2路手动按钮-->当第2路指示灯亮起，且第3路指示灯闪亮一次后，松手-->点击客户端已创建的“开”按钮。若第3路指示灯再次更亮闪烁一次，说明对码成功。\n\n    第2路指示灯亮起的情况下，长按第2路手动按钮-->当第2路指示灯熄灭，且第3路指示灯闪亮一次后，松手-->点击客户端已创建的“关”按钮。若第3路指示灯再次闪亮一次，说明对码成功。\n\n    第3路指示灯熄灭的情况下，长按第3路手动按钮-->当第3路指示灯亮起，且闪亮闪烁一次后，松手-->点击客户端已创建的“开”按钮。若第3路指示灯再次更亮闪烁一次，说明对码成功。\n\n    第3路指示灯亮起的情况下，长按第3路手动按钮-->当第3路指示灯熄灭，且闪亮闪烁一次后，松手-->点击客户端已创建的“关”按钮。若第3路指示灯再次闪亮一次，说明对码成功。\n\n    按上述步骤对码完成后即可一次控制多路开关，若需要分开控制，可添加三次设备，依次对码开关即可。"
                
            }else{
                imageV.image = UIImage(named: "zhinengchazuoDM")
                label.text = "    打开：按住插座上的开关按键2秒，插座指示灯亮，松开，立即按下应用当前页面的“开”，指示灯闪烁三次后熄灭，表示对码成功。    \n\n    关闭：按住插座上的开关按键2秒，插座指示灯亮，松开，立即按下应用当前页面的“开”，再按下当前页面的“关”，指示灯闪烁三次后熄灭，表示对码成功。"
            }
            typeNum = 1
            break
        case 8://空调 ---------
            typeNum = 1
            break
        case 9://电视 ---------
            typeNum = 1
            break
        case 10://热水器
            imageV.image = UIImage(named: "reshuiqiDM")
            label.text = "    打开：按住插座上的开关按键2秒，插座指示灯亮，松开，立即按下应用当前页面的“开”，指示灯闪烁三次后熄灭，表示对码成功。    \n\n    关闭：按住插座上的开关按键2秒，插座指示灯亮，松开，立即按下应用当前页面的“开”，再按下当前页面的“关”，指示灯闪烁三次后熄灭，表示对码成功。"
            typeNum = 1
            break
        case 11://调光 ---------
            label.text = "    面板上电，手动“开灯”，调整灯光亮度，按住中间按键，当面板左上角指示灯连续闪烁2次后，松手。松手5秒内，点击App已创建的调光灯的某一刻度。若对码指示灯继续闪烁1次，则代表可以使用此刻度执行灯的“当前亮度 开灯”操作。\n\n    调光灯其它亮度对码，可重复上述步骤进行设置。\n\n    面板上电，按住中间按键，当面板左上角指示灯连续闪烁3次后，松手，松手5秒内，点击App已创建的调光灯的某一刻度（建议最左边的刻度）。若对码指示灯继续闪烁1次，则代表可以使用此刻度执行调光灯的“关灯”操作。\n\n    若面板的“开灯”或“关灯”的不能对码，则需要对面板进行“清码”操作。步骤如下：灯光面板上电，按住中间按键，当面板左上角指示灯连续闪烁4次后，松手2秒内，重新按住中间按键。若对码指示灯继续闪烁4次，则代表此触摸按键已对码的信号失效。"
            typeNum = 1
            break
        case 12://智能晾衣架
            imageV.image = UIImage(named: "juanliankaiguanDM")
            label.text = "    提示：若设备连续通电超过30分钟,则会锁定。若需对码，请重新上电。\n\n    开：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“开”图标。若对码指示灯继续闪烁1次，对码成功\n\n    停：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“停”图标。若对码指示灯继续闪烁1次，对码成功\n\n    关：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“关”图标。若对码指示灯继续闪烁1次，对码成功"
            typeNum = 3
            break
        case 13://电动门窗
            imageV.image = UIImage(named: "chuanglianDM")
            label.text = "    开：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“开”图标。若对码指示灯继续闪烁1次，对码成功\n\n    停：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“停”图标。若对码指示灯继续闪烁1次，对码成功\n\n    关：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“关”图标。若对码指示灯继续闪烁1次，对码成功"
            typeNum = 3
            break
        case 14://电动升降架
            imageV.image = UIImage(named: "juanliankaiguanDM")
            label.text = "    开：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“开”图标。若对码指示灯继续闪烁1次，对码成功\n\n    停：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“停”图标。若对码指示灯继续闪烁1次，对码成功\n\n    关：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“关”图标。若对码指示灯继续闪烁1次，对码成功"
            typeNum = 3
            break
        case 15://电动幕布
            imageV.image = UIImage(named: "juanliankaiguanDM")
            label.text = "    开：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“开”图标。若对码指示灯继续闪烁1次，对码成功\n\n    停：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“停”图标。若对码指示灯继续闪烁1次，对码成功\n\n    关：按住要对码的面板按键，当左上角指示灯闪烁1次后，松手。5秒内，点击应用内当前界面的“关”图标。若对码指示灯继续闪烁1次，对码成功"
            typeNum = 3
            break
        case 16://影音设备 ---------
            typeNum = 1
            break
        case 17://空气净化器
            typeNum = 1
            break
        case 18://净水机
            typeNum = 1
            break
        case 19://水管
            typeNum = 1
            break
        case 20://燃气
            typeNum = 1
            break
        case 21://浇花
            typeNum = 1
            break
        default:
            typeNum = 1
            break
        }
        
        
        let hh:CGFloat = (CGFloat)((label.text?.characters.count)!/20 * 25)
        
        label.frame = CGRect(x: 10, y: 0, width: ScreenWidth - 20, height: hh)
        
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 325, width: ScreenWidth, height: ScreenHeight - 474))
        
        scrollView.addSubview(label)
        scrollView.contentSize = CGSize(width: 0, height: label.frame.size.height)
        
        self.view.addSubview(scrollView)
        
        print("设备种类  ： \(indexNum)")
        
        self.navigationItem.title = "\(dataArr[indexNum!])对码"
        
        
    }
    
    @objc func handleRightItem(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        var equip:Equip = self.equip!
        
        if Int(equip.type) >= 1000 && Int(equip.type)<2000 {
            //开关分开
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "ShotLightCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! ShotLightCell).setModel(equip)
        }
        else if Int(equip.type) >= 3000 && Int(equip.type)<4000 {
            //开关停 窗帘
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "ShotWindowCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! ShotWindowCell).setModel(equip)
        }
        else if equip.type == "999"{
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "ShotLockCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! ShotLockCell).setModel(equip)
        }
        else if equip.type == "2" || equip.type == "4"/*||judgeType(equip.type, type: "2")*/
        {//可调设备
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "ModulateCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            (cell as! ModulateCell).CallbackStat = { str in
                print("str ---->"+"\(str)");
                (equip ).status = str;
            }
            (cell as! ModulateCell).setModel(equip)
        }
        else if Int(equip.type) >= 2000 && Int(equip.type)<3000
        {
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "Modulate2Cell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! Modulate2Cell).setModel(equip)
            
        }
            //todo
        else if equip.type == "99" || equip.type == "98" || equip.type == "8192" || equip.type == "500" || equip.type == "501"
        {//红外学习设备
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "InfraredCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! InfraredCell).setModel(equip)
        }
        else if equip.type == "998"
        {
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "SensorTableViewCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            (cell as! SensorTableViewCell).setModel(equip)
        }
        else if equip.type == "8" || equip.type == "32"
        {
            
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "boxCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            print(equip)
            (cell as! boxCell).setModel(equip)
        }
        else if equip.type == "5"
        {
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "lockCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            print(equip)
            (cell as! lockCell).setModel(equip)
        }
        else if Int(equip.type) >= 4000 && Int(equip.type)<5000
        {
            //杜亚电机
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "DuYaCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! DuYaCell).setModel(equip)
        }
        else if Int(equip.type) == 5314
        {
            //杜亚电机
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "SmartLockCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            (cell as! SmartLockCell).setModel(equip)
        }
        else
        {
            
            cell = self.homeTableView.dequeueReusableCell(withIdentifier: "UnkownCell", for: indexPath)
            cell?.backgroundColor = UIColor.white
            
            //(cell as! UnkownCell).setModel(equip)
            
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
