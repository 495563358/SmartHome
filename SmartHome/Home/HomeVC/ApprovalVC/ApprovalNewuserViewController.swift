//
//  ApprovalNewuserViewController.swift
//  SmartHome
//
//  Created by Smart house on 2018/3/6.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class ApprovalNewuserViewController: UIViewController,UIGestureRecognizerDelegate,postApprovalDevice{
    
    var dataSource: [Building] = []
    var tDataSource: [FloorOrRoomOrEquip] = []
    var tDic: [String : [Equip]] = [String : [Equip]]()
    
    var choosedRoomSource :[Building] = []
    var choosedDeviceSource :[FloorOrRoomOrEquip] = []
    
    var modelData = [EditChainModel]()
    
    //授权类型  1 管理员(编辑授权) 2普通用户(编辑授权) 3新授权用户
    var accountOperationType : Int = 3
    
    var isNewuser:Bool = true
    var userPhonenum:UITextField = UITextField.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
    var firedNum:UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
    var userNum:NSString = ""
    
    var manageBtn:UIButton = UIButton.init(frame: CGRect(x: 0, y: 40, width: 100, height: 40))
    var usualBtn:UIButton = UIButton.init(frame: CGRect(x: 10, y: 90, width: 100, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choosedRoomSource = dataSource
        choosedDeviceSource = tDataSource
        
        self.navigationItem.title = "授权"
        self.view.backgroundColor = mygrayColor
        setupView()
        setupView2()
        
        let backBtn = UIButton.init(frame: CGRect(x: 0, y: 35, width: 40, height: 40))
        backBtn.setImage(UIImage(named: "fanhui(b)"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(ApprovalNewuserViewController.backClick), for: UIControlEvents.touchUpInside)
        
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        if isNewuser{
            let leftLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: 65, height: 50))
            leftLab.text = "手机号:"
            leftLab.textAlignment = .center
            
            userPhonenum.backgroundColor = UIColor.white
            userPhonenum.borderStyle = .none
            userPhonenum.placeholder = "请输入已注册用户的手机号"
            userPhonenum.font = UIFont.systemFont(ofSize: 15)
            userPhonenum.keyboardType = .numberPad
            userPhonenum.leftView = leftLab
            userPhonenum.leftViewMode = .always
            self.view .addSubview(userPhonenum)
        }else{
            firedNum.backgroundColor = UIColor.white
            firedNum.setTitle("解绑", for: .normal)
            firedNum.setTitleColor(UIColor.black, for: .normal)
            firedNum.contentHorizontalAlignment = .left
            firedNum.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
            firedNum.addTarget(self, action: #selector(ApprovalNewuserViewController.firedUser), for: .touchUpInside)
            
            let image1 = UIImageView.init(frame: CGRect(x: ScreenWidth - 20, y: 17, width: 8, height: 15))
            image1.image = UIImage(named:"gengduo-拷贝")
            firedNum.addSubview(image1)
            self.view.addSubview(firedNum)
        }
        
        let view1 = UIView.init(frame: CGRect(x: 0, y: 55, width: ScreenWidth, height: 155))
        view1.backgroundColor = UIColor.white
        
        let tipLab = UILabel.init(frame: CGRect(x: 10, y: 12, width: 300, height: 30))
        tipLab.text = "请选择授权账号类型"
        
        manageBtn.setTitleColor(UIColor.black, for: .normal)
        manageBtn.set(image: UIImage(named: "shouq_xianz_bux"), title: "管理员", titlePosition: .right, additionalSpacing: 8, state: .normal)
        manageBtn.set(image: UIImage(named: "shouq_xianz_yix"), title: "管理员", titlePosition: .right, additionalSpacing: 8, state: .selected)
        manageBtn.addTarget(self, action: #selector(ApprovalNewuserViewController.senderSelected(sender:)), for: .touchUpInside)
        manageBtn.tag = 1
        
        let manageLab = UILabel.init(frame: CGRect(x: 10, y: 12+30+25, width: 400, height: 30))
        manageLab.text = "具有系统所有设置、管理、使用授权等全部权限"
        manageLab.textColor = UIColor.gray
        manageLab.font = UIFont.systemFont(ofSize: 14)
        
        
        usualBtn.setTitleColor(UIColor.black, for: .normal)
        usualBtn.set(image: UIImage(named: "shouq_xianz_bux"), title: "普通用户", titlePosition: .right, additionalSpacing: 8, state: .normal)
        usualBtn.set(image: UIImage(named: "shouq_xianz_yix"), title: "普通用户", titlePosition: .right, additionalSpacing: 8, state: .selected)
        usualBtn.addTarget(self, action: #selector(ApprovalNewuserViewController.senderSelected(sender:)), for: .touchUpInside)
        usualBtn.tag = 2
        
        let usualLab = UILabel.init(frame: CGRect(x: 10, y: 120, width: 300, height: 30))
        usualLab.text = "具有设备控制、情景控制等使用权限"
        usualLab.textColor = UIColor.gray
        usualLab.font = UIFont.systemFont(ofSize: 14)
        
        view1.addSubview(tipLab)
        view1.addSubview(manageBtn)
        view1.addSubview(manageLab)
        view1.addSubview(usualBtn)
        view1.addSubview(usualLab)
        self.view.addSubview(view1)
        
        //授权类型  1 管理员(编辑授权) 2普通用户(编辑授权) 3新授权用户
        if accountOperationType == 1{
            manageBtn.isSelected = true
        }else{
            usualBtn.isSelected = true
        }
        
    }
    
    
    func setupView2(){
        let view2 = UIView.init(frame: CGRect(x: 0, y: 211, width: ScreenWidth, height: 149))
        view2.backgroundColor = UIColor.white
        
        let roomBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 49))
        roomBtn.addTarget(self, action: #selector(ApprovalNewuserViewController.roomBtnClick), for: .touchUpInside)
        let deviceBtn = UIButton.init(frame: CGRect(x: 0, y: 50, width: ScreenWidth, height: 49))
        deviceBtn.addTarget(self, action: #selector(ApprovalNewuserViewController.deviceBtnClick), for: .touchUpInside)
        let modelBtn = UIButton.init(frame: CGRect(x: 0, y: 100, width: ScreenWidth, height: 49))
        modelBtn.addTarget(self, action: #selector(ApprovalNewuserViewController.modelBtnClick), for: .touchUpInside)
        
        let lab1 = UILabel.init(frame: CGRect(x: 10, y: 0, width: 300, height: 49))
        lab1.text = "房间权限"
        let lab2 = UILabel.init(frame: CGRect(x: 10, y: 0, width: 300, height: 49))
        lab2.text = "设备权限"
        let lab3 = UILabel.init(frame: CGRect(x: 10, y: 0, width: 300, height: 49))
        lab3.text = "情景权限"
        
        let image1 = UIImageView.init(frame: CGRect(x: ScreenWidth - 20, y: 17, width: 8, height: 15))
        image1.image = UIImage(named:"gengduo-拷贝")
        let image2 = UIImageView.init(frame: CGRect(x: ScreenWidth - 20, y: 17, width: 8, height: 15))
        image2.image = UIImage(named:"gengduo-拷贝")
        let image3 = UIImageView.init(frame: CGRect(x: ScreenWidth - 20, y: 17, width: 8, height: 15))
        image3.image = UIImage(named:"gengduo-拷贝")
        
        let spaceView = UIView.init(frame: CGRect(x: 0, y: 49, width: ScreenWidth, height: 1))
        spaceView.backgroundColor = mygrayColor
        let spaceView2 = UIView.init(frame: CGRect(x: 0, y: 99, width: ScreenWidth, height: 1))
        spaceView2.backgroundColor = mygrayColor
        
        let approvalBtn = UIButton.init(frame: CGRect(x: ScreenWidth/2 - 100, y: 415, width: 200, height: 50))
        approvalBtn.backgroundColor = systemColor
        approvalBtn.layer.cornerRadius = 10
        approvalBtn.layer.masksToBounds = true
        approvalBtn.setTitleColor(UIColor.white, for: .normal)
        approvalBtn.setTitle("授权", for: .normal)
        approvalBtn.addTarget(self, action: #selector(ApprovalNewuserViewController.approvalClick), for: .touchUpInside)
        
        
        roomBtn.addSubview(lab1)
        roomBtn.addSubview(image1)
        deviceBtn.addSubview(lab2)
        deviceBtn.addSubview(image2)
        modelBtn.addSubview(lab3)
        modelBtn.addSubview(image3)
        view2.addSubview(roomBtn)
        view2.addSubview(spaceView)
        view2.addSubview(deviceBtn)
        view2.addSubview(spaceView2)
        view2.addSubview(modelBtn)
        
        self.view.addSubview(view2)
        self.view.addSubview(approvalBtn)
    }
    @objc func senderSelected(sender:UIButton){
        if sender.isSelected{
            return
        }
        sender.isSelected = !sender.isSelected
        if sender.tag == 1{
            usualBtn.isSelected = false
        }else{
            manageBtn.isSelected = false
        }
        
    }
    @objc func roomBtnClick(){
        if !usualBtn.isSelected{
            showMsg(msg: "授权账号类型错误")
            return
        }
        let roomVC = RoomApprovalViewController()
        roomVC.dataSource = dataSource
        roomVC.choosedRoomSource = choosedRoomSource
        roomVC.callBlock { (datas) in
            self.choosedRoomSource = datas
            self.reloadDeviceData()
        }
        self.navigationController?.pushViewController(roomVC, animated: true)
    }
    @objc func deviceBtnClick(){
        
        if !usualBtn.isSelected{
            showMsg(msg: "授权账号类型错误")
            return
        }
        reloadDeviceData()
        
        let deviceVC = DeviceApprovalViewController()
        deviceVC.delegate = self
        deviceVC.tDataSource = choosedDeviceSource
        deviceVC.tDic = tDic
        self.navigationController?.pushViewController(deviceVC, animated: true)
    }
    @objc func modelBtnClick(){
        if !usualBtn.isSelected{
            showMsg(msg: "授权账号类型错误")
            return
        }
        
        let modelVC = ApprovalModelViewController()
        modelVC.modelData = modelData
        modelVC.callBlock { (modeldata) in
            self.modelData = modeldata
        }
        self.navigationController?.pushViewController(modelVC, animated: true)
    }
    
    //更新设备数据
    func reloadDeviceData(){
        //先移除
        choosedDeviceSource.removeAll()
        //拼装被授权的房间里面的设备
        for var building in choosedRoomSource{
            if building.isApproval == true{
                switch building.buildType{
                case .buildFloor:
                    let f = Floor(floorCode: building.buildCode)
                    f.name = building.buildName
                    let ff = FloorOrRoomOrEquip(floor: f, room: nil, equip: nil)
                    //添加楼层
                    choosedDeviceSource.append(ff)
                    break
                case .buildRoom:
                    for var temp in tDataSource{
                        if temp.room?.roomCode == building.buildCode{
                            //添加房间
                            choosedDeviceSource.append(temp)
                            //将房间数据展开
                            temp.isUnfold = true
                            var equips = [FloorOrRoomOrEquip]()
                            for i in 0..<(tDic[temp.room!.roomCode]?.count)! {
                                //添加设备
                                equips.append(FloorOrRoomOrEquip(floor:nil,room: nil, equip: tDic[temp.room!.roomCode]?[i]))
                            }
                            choosedDeviceSource.append(contentsOf: equips)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getApprovalDeviceData(datas: [FloorOrRoomOrEquip]) {
        choosedDeviceSource = datas
        
        for var temp in choosedDeviceSource {
            if temp.type == .equip{
                print("\(temp.equip?.name) - \(temp.equip?.isApproval)")
            }
            
        }
    }
    
    @objc func approvalClick(){
        
        if ((userPhonenum.text! as NSString).length < 7 && userNum.length < 7){
            showMsg(msg: "请输入已注册用户的手机号")
            return
        }
        if(!manageBtn.isSelected && !usualBtn.isSelected){
            showMsg(msg: "请选择授权账号类型")
            return
        }
        if userNum.length == 0 {
            userNum = userPhonenum.text! as NSString
        }
        
        reloadDeviceData()
        
        var uploadModel = [ChainModel]()
        var uploadIds = [String]()
        //处理情景模式
        for var modelInfo in self.modelData{
            if modelInfo.isApproval == true{
                let model = ChainModel()
                model.modelIcon = modelInfo.modelIcon
                model.modelId = modelInfo.modelId
                model.modelName = modelInfo.modelName
                uploadModel.append(model)
                uploadIds.append(modelInfo.modelId)
            }
        }
        
        let upModelIdstr = dataDeal.toJSONString(jsonSource: uploadIds as AnyObject)
        
        
        print(choosedDeviceSource)
        var subArr: [[String : String]] = []
        for var temp in choosedDeviceSource {
            
            if temp.type == .equip{
                var suDic = ["roomCode" : temp.equip?.roomCode]
                suDic["deviceAddress"] = temp.equip?.equipID
                suDic["deviceCode"] = temp.equip?.hostDeviceCode
                suDic["userCode"] = temp.equip?.userCode
                suDic["name"] = temp.equip?.name
                suDic["type"] = temp.equip?.type
                suDic["icon"] = temp.equip?.icon
                
                if temp.equip?.type == "100"{
                    let string:NSString = (temp.equip?.num)! as NSString
                    print(string)
                    let sub = string.substring(with: NSRange(location: 9,length:string.length-10))
                    suDic["validationCode"] = sub
                }
                if temp.equip?.isApproval == true{
                    suDic["isAuthorited"] = "1"
                    subArr.append(suDic as! [String : String])
                }
                else{
                    suDic["isAuthorited"] = "0"
                    subArr.append(suDic as! [String : String])
                }
            }
        }
        
        if subArr.count == 0 && usualBtn.isSelected{
            showMsg(msg: "至少选择一个设备哦")
            return
        }
        
        let str = dataDeal.toJSONString(jsonSource: subArr as AnyObject)
        
        var dic:[String:Any] = [:]
        //初次授权   授权类型  1 管理员(编辑授权) 2普通用户(编辑授权) 3新授权用户
        if isNewuser{
            if manageBtn.isSelected {
                dic = ["userPhone":userNum as Any,"accountOperationType":"1","approvalinfo":str,"modelIds":upModelIdstr] as [String : Any]
            }else{
                dic = ["userPhone":userNum as Any,"accountOperationType":"2","approvalinfo":str,"modelIds":upModelIdstr] as [String : Any]
            }
            BaseHttpService.sendRequestAccessAndBackall(authorize1, parameters: dic as NSDictionary) { (data) -> () in
                if !data.isKind(of: NSDictionary.classForCoder()) {
                    showMsg(msg: "服务器返回数据异常,请稍后再试")
                    return
                }
                let backdata = data as! [String:Any]
                if backdata["message"] == nil{
                    showMsg(msg: "服务器异常,请稍后再试")
                    return
                }else{
                    showMsg(msg: backdata["message"] as! String)
                }
            }
        }
        //编辑授权
        else{
            if manageBtn.isSelected {
                dic = ["userPhone":userNum as Any,"accountOperationType":"1","approvalinfo":str,"modelIds":upModelIdstr] as [String : Any]
            }else{
                dic = ["userPhone":userNum as Any,"accountOperationType":"2","approvalinfo":str,"modelIds":upModelIdstr] as [String : Any]
            }
            BaseHttpService.sendRequestAccessAndBackall(updateAuthorize, parameters: dic as NSDictionary) { (data) -> () in
                
                if !data.isKind(of: NSDictionary.classForCoder()) {
                    showMsg(msg: "服务器返回数据异常,请稍后再试")
                    return
                }
                let backdata = data as! [String:Any]
                if backdata["message"] == nil{
                    showMsg(msg: "服务器异常,请稍后再试")
                    return
                }else{
                    showMsg(msg: backdata["message"] as! String)
                }
            }
        }
        
    }
    
    @objc func firedUser(){
        let tip = UIAlertController.init(title: nil, message: "取消授权", preferredStyle: .alert)
        tip.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            //取消授权
            let dic = ["userPhone":self.userNum]
            BaseHttpService.sendRequestAccess(primaryAccountRemoveBelowAccount, parameters: dic as NSDictionary, success: { [unowned self](any) -> () in
                
                self.navigationController?.popViewController(animated: true)
            })
        }))
        tip.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(tip, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
