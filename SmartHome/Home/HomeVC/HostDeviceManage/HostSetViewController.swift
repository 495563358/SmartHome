//
//  HostSetViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/7/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class HostSetViewController: UIViewController,UITextFieldDelegate {

    let scalew = ScreenWidth / 320
    let scaleh = ScreenHeight / 568
    
    var shotID = ""
    
    var hostName = NSLocalizedString("输入修改主机名称", comment: "")
    
    var leabName:UITextField?
    var zhongduan:UITextField?
    var zhongduan1:UITextField?
    var zhuji:UITextField?
    var zhuji1:UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view = UIView(frame: CGRect(x: 0*scalew,y: 0*scaleh,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        self.view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        self.navigationItem.title = NSLocalizedString("编辑", comment: "")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        leabName = UITextField(frame: CGRect(x: 8*scalew,y: 5*scaleh,width: ScreenWidth/1.5,height: 30*scaleh))
        leabName!.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        leabName!.borderStyle=UITextBorderStyle.bezel
        leabName!.clearButtonMode=UITextFieldViewMode.whileEditing
        leabName?.placeholder = self.hostName
        
        let butName = UIButton(frame: CGRect(x: ScreenWidth/1.5+25*scalew,y: 5*scaleh,width: 50*scalew,height: 30*scaleh))
        butName.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: UIControlState())
        butName.layer.cornerRadius = 10.0
        butName.backgroundColor = UIColor.white
        butName.addTarget(self, action: #selector(HostSetViewController.setName(_:)), for: .touchUpInside)
        butName.setTitle(NSLocalizedString("确定", comment: ""), for: UIControlState())
        butName.tag = 1
        
        let wangluo = UILabel(frame: CGRect(x: 8*scalew,y: leabName!.frame.size.height+10*scaleh,width: ScreenWidth/2-12*scalew,height: 30*scaleh))
        wangluo.textAlignment = .center
        wangluo.text = NSLocalizedString("网络号", comment: "")
        //wangluo.backgroundColor = UIColor.whiteColor()
        
        let xindao = UILabel(frame: CGRect(x: wangluo.frame.size.width+16*scalew,y: leabName!.frame.size.height+10*scaleh,width: wangluo.frame.size.width,height: 30*scaleh))
        xindao.textAlignment = .center
        xindao.text = NSLocalizedString("信道", comment: "")
        //xindao.backgroundColor = UIColor.whiteColor()
        
        zhuji = UITextField(frame: CGRect(x: 8*scalew,y: leabName!.frame.size.height+10*scaleh+wangluo.frame.size.height+10*scaleh,width: wangluo.frame.size.width,height: 30*scaleh))
        zhuji!.borderStyle=UITextBorderStyle.bezel
        zhuji!.placeholder = NSLocalizedString("主机网络号", comment: "")
        
        zhuji1 = UITextField(frame: CGRect(x: wangluo.frame.size.width+16*scalew,y: leabName!.frame.size.height+10*scaleh+wangluo.frame.size.height+10*scaleh,width: wangluo.frame.size.width,height: 30*scaleh))
        zhuji1!.borderStyle=UITextBorderStyle.bezel
        zhuji1!.placeholder = NSLocalizedString("主机信道", comment: "")
        
       
        let jOK = UIButton(frame: CGRect(x: zhuji!.frame.size.width/4+8*scalew,y: leabName!.frame.size.height+wangluo.frame.size.height+30*scaleh+zhuji!.frame.size.height,width: zhuji!.frame.size.width/2,height: 30*scaleh))
        jOK.setTitle(NSLocalizedString("查询主机", comment: ""), for: UIControlState())
        jOK.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: UIControlState())
        jOK.backgroundColor = UIColor.white
        jOK.layer.cornerRadius = 10.0
        jOK.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        jOK.tag = 4
        jOK.addTarget(self, action: #selector(HostSetViewController.setName(_:)), for: .touchUpInside)
        
        let jOK1 = UIButton(frame: CGRect(x: zhuji!.frame.size.width+16*scalew+zhuji!.frame.size.width/4,y: leabName!.frame.size.height+wangluo.frame.size.height+30*scaleh+zhuji!.frame.size.height,width: jOK.frame.size.width,height: 30*scaleh))
        jOK1.layer.cornerRadius = 10.0
        jOK1.setTitle(NSLocalizedString("写入主机", comment: ""), for: UIControlState())
        jOK1.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: UIControlState())
        jOK1.backgroundColor = UIColor.white
        jOK1.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        jOK1.tag = 5
        jOK1.addTarget(self, action: #selector(HostSetViewController.setName(_:)), for: .touchUpInside)
        
        
        
        
        
        
        zhongduan  = UITextField(frame: CGRect(x: 8*scalew,y: leabName!.frame.size.height+wangluo.frame.size.height+40*scaleh+zhuji!.frame.size.height+jOK.frame.size.height,width: wangluo.frame.size.width,height: 30*scaleh))
        zhongduan!.borderStyle=UITextBorderStyle.bezel
        zhongduan!.placeholder = NSLocalizedString("终端", comment: "")
        
        zhongduan1 = UITextField(frame: CGRect(x: wangluo.frame.size.width+16*scalew,y: leabName!.frame.size.height+wangluo.frame.size.height+40*scaleh+zhuji!.frame.size.height+jOK.frame.size.height,width: wangluo.frame.size.width,height: 30*scaleh))
        zhongduan1!.borderStyle=UITextBorderStyle.bezel
        zhongduan1!.placeholder = NSLocalizedString("终端", comment: "")
        
        let zOK = UIButton(frame: CGRect(x: zhuji!.frame.size.width/4+8*scalew,y: leabName!.frame.size.height+wangluo.frame.size.height+50*scaleh+zhuji!.frame.size.height+jOK.frame.size.height+zhongduan!.frame.size.height,width: zhuji!.frame.size.width/2,height: 30*scaleh))
        zOK.setTitle(NSLocalizedString("配置终端", comment: ""), for: UIControlState())
        zOK.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: UIControlState())
        zOK.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        zOK.backgroundColor = UIColor.white
        zOK.layer.cornerRadius = 10.0
        zOK.tag = 2
        zOK.addTarget(self, action: #selector(HostSetViewController.setName(_:)), for: .touchUpInside)
        
        let zOK1 = UIButton(frame: CGRect(x: zhuji!.frame.size.width+16*scalew+zhuji!.frame.size.width/4,y: leabName!.frame.size.height+wangluo.frame.size.height+50*scaleh+zhuji!.frame.size.height+jOK.frame.size.height+zhongduan!.frame.size.height,width: jOK.frame.size.width,height: 30*scaleh))
        zOK1.layer.cornerRadius = 10.0
        zOK1.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        zOK1.setTitle(NSLocalizedString("写入终端", comment: ""), for: UIControlState())
        zOK1.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: UIControlState())
        zOK1.backgroundColor = UIColor.white
        zOK1.tag = 3
        zOK1.addTarget(self, action: #selector(HostSetViewController.setName(_:)), for: .touchUpInside)
        //---------主机
        
        let Labtext = UILabel(frame: CGRect(x: 8*scalew,y: leabName!.frame.size.height+wangluo.frame.size.height+100*scaleh+zhuji!.frame.size.height+jOK.frame.size.height+zhongduan!.frame.size.height+zOK.frame.size.height,width: ScreenWidth-16*scalew,height: 110*scaleh))
        Labtext.lineBreakMode = NSLineBreakMode.byWordWrapping
        Labtext.numberOfLines = 0
        Labtext.text = NSLocalizedString("网络号和信道是主机和终端配件之间成功通信的前提条件，我公司出厂的所有终端配件，网络号默认为8192，信道默认为25。", comment: "")
        Labtext.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        self.view.addSubview(leabName!)
        self.view.addSubview(butName)
        self.view.addSubview(wangluo)
        self.view.addSubview(xindao)
        self.view.addSubview(zhongduan!)
        self.view.addSubview(zhongduan1!)
        self.view.addSubview(zOK)
        self.view.addSubview(zOK1)
        self.view.addSubview(jOK1)
        self.view.addSubview(jOK)
        self.view.addSubview(zhuji!)
        self.view.addSubview(zhuji1!)
        self.view.addSubview(Labtext)
        self.view.addSubview(zhuji!)
        self.view.addSubview(zhuji1!)
        
        let dic = ["deviceCode":shotID,"deviceOrHost":"1"]
        print(dic)
        BaseHttpService.sendRequestAccess(queryNetworkNumber, parameters: dic as NSDictionary, success: { (arr) -> () in
            
            print(arr)
            self.zhuji?.text = arr["networkNumber"] as? String
            self.zhuji1?.text = arr["channel"] as? String
            
        })
        leabName?.delegate = self
        zhongduan?.delegate = self
        zhongduan1?.delegate = self
        zhuji?.delegate = self
        zhuji1?.delegate = self
    }
    
    @objc func setName(_ but:UIButton){
        //self.textFieldShouldReturn(leabName!)
        switch but.tag{
        
        case 1:
            if leabName?.text == ""{
                showMsg(msg: NSLocalizedString("请输入名称", comment: ""))
                break
            }
            let dic = ["deviceCode":shotID,"nickName":(leabName!.text)!]
             print(dic)
            BaseHttpService.sendRequestAccess(modifyHostNickname, parameters: dic as NSDictionary, success: { (arr) -> () in
                
            })
            break
        case 2:
            let dic = ["deviceCode":shotID]
            BaseHttpService.sendRequestAccess(config, parameters: dic as NSDictionary, success: { (arr) -> () in
                
            })
            break
        case 3:
            if zhongduan?.text == "" || zhongduan1?.text == ""{
                showMsg(msg: NSLocalizedString("完整信息", comment: ""))
                break
            }
            let dic = ["deviceCode":shotID,"networkNumber":(zhongduan!.text)!,"channel":(zhongduan1!.text)!,"deviceOrHost":"2"]
            BaseHttpService.sendRequestAccess(setNetworkNumber, parameters: dic as NSDictionary, success: { (arr) -> () in
                
            })
            break
        case 4:
            //queryNetworkNumber
            let dic = ["deviceCode":shotID,"deviceOrHost":"1"]
            print(dic)
            BaseHttpService.sendRequestAccess(queryNetworkNumber, parameters: dic as NSDictionary, success: { (arr) -> () in
                
                print(arr)
                self.zhuji?.text = arr["networkNumber"] as? String
                self.zhuji1?.text = arr["channel"] as? String
            })
            break
        case 5:
            if zhuji?.text == "" || zhuji1?.text == ""{
                showMsg(msg: NSLocalizedString("完整信息", comment: ""))
                break
            }
            let dic = ["deviceCode":shotID,"networkNumber":(zhuji!.text)!,"channel":(zhuji1!.text)!,"deviceOrHost":"1"]
            BaseHttpService.sendRequestAccess(setNetworkNumber, parameters: dic as NSDictionary, success: { (arr) -> () in
                
            })
            break
        default :
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //键盘消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //触发事件消失
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
