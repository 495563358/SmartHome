//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

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


class HomeVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,TouchSXT{//
//    let PLAYER_NEED_VALIDATE_CODE = -1   //播放需要安全验证
//    let PLAYER_REALPLAY_START     = 1    //直播开始
//    let PLAYER_VIDEOLEVEL_CHANGE  = 2    //直播流清晰度切换中
//    let PLAYER_STREAM_RECONNECT   = 3    //直播流取流正在重连
//    let PLAYER_PLAYBACK_START     = 11   //录像回放开始播放
//    let PLAYER_PLAYBACK_STOP      = 12   //录像回放结束播放
    var btnIsSeleted = false;
    @IBOutlet var popView: UIView!
    @IBOutlet var anfangCheck: UIButton!
    var bgView:UIView?
    @IBOutlet var jiajuCheck: UIButton!
    var timer:Timer?
    var judge_refresh_timer:Timer?
    var judge_refresh_count = 0.0
    var showSXT:Bool = false
    var sideView:MineSideView?          //侧滑栏
    
    //开始 停止 放大 摄像头
    var _cameraBtn:UIButton?
    var _stopCamera:UIButton?
    
    var _btn:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
    //安防总开关
    var _btnSecurity:UIBarButtonItem?
    var _SecuritySwift = "1"
    
    var head  = 1
    var cameraId = ""
    var headCell:HeadCell?
    var orientationLast:UIInterfaceOrientation?=UIInterfaceOrientation.portrait
    var roomArray:[String]?=[]
    let titleBtn:UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    
//    var player:EZPlayer?
    
    var headerImgV:UIImageView!
    
    var deviceDataSource = [Any]()
     var sxtData = [Equip]()
    
    //选择楼层和房间
    var floorNameArr = [String]()
    var floorNameindex:Int = 0
    var roomNameArr:[[String]] = []
    var roomCodeArr:[[String]] = []
    var roomNameindex:Int = 0
    
    @IBOutlet weak var okbut: UIButton!

    @IBOutlet weak var quxiao: UIButton!
    @IBOutlet var homeTableView: UITableView!
    
    lazy var  drakBtn:UIButton = {
        let dark:UIButton=UIButton()
        dark.isHidden=true
        dark.backgroundColor=UIColor.black
        dark.addTarget(self, action: #selector(HomeVC.showSide),  for:.touchUpInside)
        dark.alpha=0.3
        dark.isUserInteractionEnabled=true
        print("创建bg")
        return dark
    }()
    
    lazy var  drakBtn2:UIButton = {
        
        let dark:UIButton=UIButton()
        dark.frame = UIScreen.main.bounds
        dark.backgroundColor=UIColor.black
        dark.alpha = 0.2
        dark.addTarget(self, action: #selector(HomeVC.showSide2),  for:.touchUpInside)
        dark.isUserInteractionEnabled=true
        print("创建bg")
        return dark
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        registerCell()
        
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        //标题栏去掉
        titleBtn.setTitle(app.App_roomName, for: UIControlState())
        titleBtn.setTitleColor(UIColor.white, for: UIControlState())
        titleBtn.addTarget(self, action: #selector(HomeVC.chooseRoom(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn

    }
    @objc func MJRefreshHeaderReload(){
        if self.judge_refresh_count == 0 {
            self.DownRefreshStatus()
        }
    }
    
    //检查网络状态
    func checkConnect(){
//        let reachConnect = Reachability.init(hostName: "www.baidu.com")
//        switch reachConnect?.currentReachabilityStatus() {
//        case NotReachable?:
//            showMsg(msg: "网络不给力,请检查网络后重试!")
//            break
//        default:
//            break
//        }
    }
    
    
    //配置视图
    func configView(){
        //下拉加载
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(HomeVC.MJRefreshHeaderReload))
        self.homeTableView.mj_header = header
        
        //左侧导航按钮 侧滑栏
        let userBtn = UIButton(frame: CGRect(x: 0,y: 0,width: 30,height: 30))
        headerImgV = UIImageView(frame: CGRect(x: 0,y: 0,width: 30,height: 30))
        headerImgV.layer.cornerRadius = 15
        headerImgV.layer.masksToBounds = true
        userBtn.addSubview(headerImgV)
        userBtn.addTarget(self, action: #selector(HomeVC.showSide), for: .touchUpInside)
//        userBtn.addTarget(self, action: Selector("testActive"), forControlEvents: .TouchUpInside)
        
        let bbi_r3=UIBarButtonItem.init(customView: userBtn)
        bbi_r3.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem = bbi_r3
        
        //添加设备
        let bbi_r2 = UIBarButtonItem(image: UIImage(named: "shebei"), style:UIBarButtonItemStyle.plain, target:self ,action:#selector(HomeVC.modifyDeviceInfo))
        bbi_r2.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem = bbi_r2
        self._btn.isSelected = true
        
        //摄像头播放
        _cameraBtn = UIButton.init(frame: CGRect(x: (ScreenWidth - 32)/2, y: (ScreenHeight  * 100 / 320 - 32)/2, width: 32, height: 32))
        _cameraBtn!.addTarget(self, action: #selector(HomeVC.showEZ), for: UIControlEvents.touchUpInside)
        _cameraBtn?.setImage(UIImage(named: "bofang"), for:UIControlState())
        self.homeTableView.addSubview(_cameraBtn!)
        
        _stopCamera = UIButton.init(frame: CGRect(x: 2, y: (ScreenHeight  * 100 / 320 - 38), width: 36, height: 36))
        _stopCamera!.addTarget(self, action: #selector(HomeVC.showEZ), for: UIControlEvents.touchUpInside)
        _stopCamera?.setImage(UIImage(named: "zantin"),for:UIControlState())
        _stopCamera?.isHidden = true
        self.homeTableView.addSubview(_stopCamera!)
        
        //侧滑
        if sideView==nil{
            
            let sideWidth:CGFloat = ScreenWidth * 0.75
            
            sideView = MineSideView.init(frame: CGRect(x: 0-sideWidth, y: 0, width: sideWidth,height: ScreenHeight))
            sideView?.delegate=self
            sideView?.tableView.backgroundColor = UIColor.white
            self.drakBtn.frame=CGRect(x: 0, y: 0, width: ScreenWidth,height: ScreenHeight)
            UIApplication.shared.keyWindow?.addSubview(self.drakBtn)
            
            UIApplication.shared.keyWindow!.addSubview(sideView!)
            print("侧滑重构")
            self.sideView!.tableView.reloadData()
        }
    }
    
    
//    func testActive(){
//        let camera = CameraManagerVC()
//        camera.hidesBottomBarWhenPushed = true
//        var roomDict:NSMutableDictionary = NSMutableDictionary()
//        let floorArr = dataDeal.getModels(type: .Floor) as! [Floor]
//        for floor in floorArr {
//            let roomArr = dataDeal.getRoomsByFloor(floor: floor)
//            for room in roomArr {
//                roomDict.setValue(room.name, forKey: room.roomCode)
//            }
//        }
//
//        let cameras:[Equip] = DataDeal.sharedDataDeal.searchAllSXTModel()
//
//        camera.cameras = cameras
//        camera.roomDict = roomDict
//
//        self.navigationController?.pushViewController(camera, animated: true)
//    }
    
    
    //设备tableview 注册Cell
    func registerCell(){
    
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
        
    }
    
    func runTime(){
        if self.judge_refresh_count == 3
        {
           // self.refreshStatus()
           // self.DownRefreshStatus()
        }
        if self.judge_refresh_count  == 6
        {
            self.judge_refresh_timer?.invalidate()
             self.homeTableView.mj_header.endRefreshing()
            self.judge_refresh_count = 0
            return
        }
        self.judge_refresh_count += 0.5
    }
    
    //刷新天气
    func refreshWeather(){
        //print(BaseHttpService.userCity())
//        MyLocationManager.sharedManager().configLocation()
//        MyLocationManager.sharedManager().callback={(str:String!)in
//            if str == nil || str == ""{
//                return
//            }
//            //天气预报 闭包回调
//            weatherWithProvince(BaseHttpService.userCity(), localCity:str) {[unowned self] (weather:WeatherModel?) -> () in
//                if weather == nil{
//                    return;
//                }
//                self.headCell?.setWeatherModel( weather!)
//
//            }
//
//        }

    }
    
    
    func turnToCurrentRoom(_ indexpath:IndexPath){
        let roomcode = roomCodeArr[indexpath.section][indexpath.row]
        if (self.sxtData.count > 0){
            self.headCell!.removeHeadView()
        }
        if self._cameraBtn?.isHidden==true{
            self.showEZ()
        }
        self.deviceDataSource = dataDeal.getEquipsByRoomExceptSXT(room: Room(roomCode: roomcode))
        self.sxtData = [Equip]()
        self.sxtData = dataDeal.searchSXTModel(byRoomCode: roomcode)
        //非菜单选项
        print("点到具体房间。。\(roomcode)..\(self.deviceDataSource.count)---\(self.sxtData.count)")
        self.showSXT = false
        
        self._btn.isSelected  = self.sxtData.count == 0
        self.homeTableView.reloadData()
        
        self.drakBtn.isHidden=true
        
        app.App_room = roomcode
        
        app.App_roomName  = roomNameArr[indexpath.section][indexpath.row]
        self.titleBtn.set(image: UIImage(named: "zhankai-bai"), title: app.App_roomName, titlePosition: .left, additionalSpacing: 5, state: UIControlState())
        self.refreshStatus()
    }
    
    //选择房间
    @objc func chooseRoom(_ sender:UIButton){
        
        print(app.App_roomName)
        
        let choos = HomeChooseRoomVC()
        choos.hidesBottomBarWhenPushed = true
        choos.callBlock(block: { (indexpath) -> () in
            self.turnToCurrentRoom(indexpath)
        })
        
        
        self.navigationController?.pushViewController(choos, animated: true)
        floorNameArr.removeAll()
        roomNameArr.removeAll()
        roomCodeArr.removeAll()
        let floorArr = dataDeal.getModels(type: .Floor) as! [Floor]
        var codeArr = [String]()
        var nameArr = [String]()
        var titleArr = [String]()
        
        for floor in floorArr {
            floorNameArr.append(floor.name)
            let roomArr = dataDeal.getRoomsByFloor(floor: floor)
            var floorRoomNameArr = [String]()
            var floorRoomCodeArr = [String]()
            for room in roomArr {
                codeArr.append(room.roomCode)
                nameArr.append("\(floor.name)   \(room.name)")
                titleArr.append(room.name)
                floorRoomNameArr.append(room.name)
                floorRoomCodeArr.append(room.roomCode)
            }
            roomNameArr.append(floorRoomNameArr)
            roomCodeArr.append(floorRoomCodeArr)
        }
        
        print("楼层信息:\(floorNameArr)")
        print("房间名信息:\(roomNameArr)")
        return
        
    }
    
    //摄像头
    func barButton()->NSArray{
        //  let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        let item = UIBarButtonItem(customView: createButtonWithX(0, aSelector: #selector(HomeVC.showEZ)))
        
        return [item,self._btnSecurity!]//,negativeSeperator]
    }
    
    
    func createButtonWithX(_ x:Float,aSelector: Selector)->UIView{
       
        _btn.addTarget(self, action: aSelector, for: UIControlEvents.touchUpInside)
        _btn.setImage(UIImage(named: "sxt"), for: UIControlState())
         _btn.setImage(UIImage(named: "sxt3"), for: UIControlState.selected)
        return _btn
    }

    
    //添加设备
    @objc func modifyDeviceInfo(){
        
        self.drakBtn2.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(drakBtn2)
        if bgView == nil{
            bgView = UIView.init(frame: CGRect(x: ScreenWidth - 140, y: 74, width: 135, height: 240+48))
            bgView?.backgroundColor = UIColor.white
            bgView?.layer.cornerRadius = 5.0
            UIApplication.shared.keyWindow?.addSubview(bgView!)
            
            let tran = UIImageView.init(frame: CGRect(x: 135 - 14 - 14, y: -7, width: 14, height: 7))
            tran.image = UIImage(named: "sanjiao")
            bgView?.addSubview(tran)
            
            let nameArr:[String] = ["添加设备","搜索设备","添加主机","添加情景","添加安防","添加房间"]
            
            for i in 0...5{
                let btnY:CGFloat = (CGFloat)(0 + 48 * i)
                let btn = UIButton.init(frame: CGRect(x: 0, y: btnY, width: 135, height: 47))
                btn.tag = i
                btn.setTitle(nameArr[i], for: UIControlState())
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitleColor(UIColor.black, for: UIControlState())
                btn.setBackgroundImage(getImageWithColor(UIColor.groupTableViewBackground), for: .highlighted)
                btn.addTarget(self, action: #selector(HomeVC.addClick(_:)), for: UIControlEvents.touchUpInside)
                bgView!.addSubview(btn)
                
                if i<5{
                    let space = UIView.init(frame: CGRect(x: 0, y: btnY + 47, width: 135, height: 0.5))
                    space.backgroundColor = UIColor.lightGray
                    bgView!.addSubview(space)
                }
            }

        }
        bgView?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubview(toFront: bgView!)
    }
    
    func getImageWithColor(_ color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    @objc func addClick(_ sender:UIButton){
        self.drakBtn2.isHidden = true
        self.bgView?.isHidden = true
        switch(sender.tag){
        case 0:
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
            print("手动添加设备")
            let handly = HandlyAddDevice()
            handly.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(handly, animated: true)

            break
        case 1:
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
            print("搜索设备")
            let automatic = AutomaticDevice(nibName: "AutomaticDevice", bundle: nil)
            automatic.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(automatic, animated: true)
            break
        case 2:
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
            print("添加主机")
            let indvc = MainDeviceManager()
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        case 3:
            print("添加情景")
            let chainView = ChainEquipAddVC()
            chainView.NameText = "添加情景模式"
            chainView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chainView, animated: true)
            break
        case 4:
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
            let safeType = SafeTypeTVC();
            print("添加安防 : \(app.App_room)")
            safeType.roomCode = app.App_room
            safeType.hidesBottomBarWhenPushed
                = true
            self.navigationController?.pushViewController(safeType, animated: true)
            break
        case 5:
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
            print("添加房间")
            let creatHomeVC = CreatHomeViewController(nibName: "CreatHomeViewController", bundle: nil)
            creatHomeVC.isSimple = true
            creatHomeVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(creatHomeVC, animated: true)
            break
        default:
            break
        }

    }
    
    
    //管理房间和设备
    func modifyRoomInfo(){
        if BaseHttpService.GetAccountOperationType() == "2"{
            showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
            return
        }
        
        let manageVC = ManageRoomDev(nibName: "ManageRoomDev", bundle: nil)
        manageVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(manageVC, animated: true)
    }
  
    //摄像头 播放和暂停按钮的展示 获取视频内容 self.homeTableView.reloadSections
   @objc func showEZ(){
        if(sxtData.count <= 0){
            showMsg(msg: NSLocalizedString("该房间没有摄像头", comment: ""))
             self._btn.isSelected = true
            return
        }else{
            print("房间有摄像头")
            if _cameraBtn?.isHidden == true{
                _cameraBtn?.isHidden = false
                _stopCamera?.isHidden = true
            }else{
                _cameraBtn?.isHidden = true
                _stopCamera?.isHidden = false
            }
             headCell!.removeHeadView()
            
            if !showSXT {
               _btn.setImage(UIImage(named: "guang1"), for: UIControlState())
                 showSXT = true
            }else{
               _btn.setImage(UIImage(named: "sxt"), for: UIControlState())
                showSXT = false
            }
            let indexSet0 = IndexSet(integer: 0)
            self.homeTableView.reloadSections(indexSet0, with: UITableViewRowAnimation.automatic)
        
        }
       
//        let cameraType = CameraTypeTVC();
//        cameraType.hidesBottomBarWhenPushed
//            = true
//        self.navigationController?.pushViewController(cameraType, animated: true)
    }

    func getRoomInfo(){
        print("获取房间信息")
        tableSideViewDataSource.removeAllObjects()
        
        let floors = dataDeal.getModels(type: DataDeal.TableType.Floor) as! Array<Floor>
        for _floor in floors{
            let floor = RoomListItem()
            floor.name = _floor.name
            floor.iconName = "Floor"
            floor.isSubItem = false
            let rooms = dataDeal.getRoomsByFloor(floor: _floor)
            
            for _room in rooms{
                
                let room  = RoomListItem()
                room.name = _room.name
                room.roomCode = _room.roomCode
                room.iconName = "Home"
                room.isSubItem = true
                
                floor.items.add(room)
                
            }
         tableSideViewDataSource.add(floor)
            
           // if tableSideViewDataSource.count == 1{
                floor.isOpen = true
            tableSideViewDataSource.addObjects(from: floor.items as [AnyObject])
           // }
     
            
        }
        //刷新数据
        roomArray=[]
        print("刷新数据\(tableSideViewDataSource.count)\n\(floors.count)\n")
        let allrooms = dataDeal.getModels(type: DataDeal.TableType.Room) as! Array<Room>
        for room in allrooms{
            roomArray?.append(room.name)
        }
        
    }
    //下拉刷新设备状态
    func DownRefreshStatus(){
        
        checkConnect()
        //增加默认选项
        let _floors = dataDeal.getModels(type: DataDeal.TableType.Floor) as! Array<Floor>
        print(_floors.count)
        if _floors.count > 0{
            let rooms = dataDeal.getRoomsByFloor(floor: _floors[0])
            
            if app.App_room == "" && rooms.count > 0 {
                
                app.App_room  = rooms[0].roomCode
                app.App_roomName  = rooms[0].name
                
            }
            if app.App_room != ""{
                titleBtn.set(image: UIImage(named: "zhankai-bai"), title: app.App_roomName, titlePosition: .left, additionalSpacing: 5, state: UIControlState())
                let param = ["roomCode":app.App_room]
                print("get device status from server---->\(app.App_room)")

                BaseHttpService.sendRequestAccess(queryDeviceState, parameters: param as NSDictionary, success: { (back) -> () in
                    print(back)
                    self.refreshStatus()
                    self.homeTableView.mj_header.endRefreshing()
                })
                
                
            }
            else
            {
                app.App_roomName = ""
                self.titleBtn.set(image: UIImage(named: "zhankai-bai"), title: app.App_roomName, titlePosition: .left, additionalSpacing: 5, state: UIControlState())
                self.deviceDataSource = [Equip]()
                sxtData = [Equip]()
                self._btn.isSelected  = sxtData.count == 0
                self.homeTableView.reloadData()
                print("没有房间")
            }
            
        }
        else
        {
            app.App_roomName = ""
            self.titleBtn.set(image: UIImage(named: "zhankai-bai"), title: app.App_roomName, titlePosition: .left, additionalSpacing: 5, state: UIControlState())
            self.deviceDataSource = [Equip]()
            sxtData = [Equip]()
            self._btn.isSelected  = sxtData.count == 0
            self.homeTableView.reloadData()
            print("没有房间")
        }
        self.homeTableView.mj_header.endRefreshing()
        
    }
    //下拉刷新8秒后刷新状态
    func TimerDownRefreshStatus(){
        //获取状态
        self.refreshStatus()
    }
    
    //界面切设备状态
    func refreshStatus(){
        //增加默认选项
        let _floors = dataDeal.getModels(type: DataDeal.TableType.Floor) as! Array<Floor>
        print(_floors.count)
        if _floors.count > 0{
            let rooms = dataDeal.getRoomsByFloor(floor: _floors[0])
            
            if app.App_room == "" && rooms.count > 0 {
             
                    app.App_room  = rooms[0].roomCode
                    app.App_roomName  = rooms[0].name
            
            }
            if app.App_room != ""{
                titleBtn.set(image: UIImage(named: "zhankai-bai"), title: app.App_roomName, titlePosition: .left, additionalSpacing: 5, state: UIControlState())
                let param = ["roomCode":app.App_room]
                print("get device status from server---->\(app.App_room)")
                //queryDeviceState
                BaseHttpService.sendRequestAccess(queryDbDeviceState, parameters: param as NSDictionary, success: { (back) -> () in
                    print(back)
                    
                    
                    //////////////////////////
                    print("名字为\(app.App_room)")
                    
                    self.deviceDataSource = dataDeal.getEquipsByRoomCodeExceptSXT(currentRoomCode: app.App_room)
                    if back.count > 0{
                        for dic in (back as![[String:String]])
                        {
                            if self.getEquip(dic["deviceAddress"]!) != nil
                            {
                                self.getEquip(dic["deviceAddress"]!)?.status = dic["state"]!
                            }
                        }
                     
                    }
                   // self.deviceDataSource = dataDeal.getEquipsByRoomCodeExceptSXT(app.App_room)
                    print("get device from db------>\(self.deviceDataSource.count)")
                    self.sxtData = [Equip]()
                    self.sxtData = dataDeal.searchSXTModel(byRoomCode: app.App_room)
                    
                    
                    
                    //如果有摄像头 先配置 减少时间
                    if self.sxtData.count > 0{
                        print("有摄像头了")
                        self.headCell = self.homeTableView.dequeueReusableCell(withIdentifier: "HeadCell") as? HeadCell
                        if self.headCell?.myScorllView == nil  {
                            self.headCell!.configHeadView()
                            self.headCell!.myScorllView.config()
                            self.headCell!.myScorllView.setupPage()
                            
//                            headCell?.myScorllView.delegate = self
                        }
                    }

                    
                    
                    self._btn.isSelected  = self.sxtData.count == 0
                    //定时器取消
                    if self.timer != nil {
                        self.timer!.invalidate()
                        self.timer = nil
                    }
                    
                   self.homeTableView.reloadData()
                    
                })

                
            }
            else
            {
                app.App_roomName = ""
                self.titleBtn.set(image: UIImage(named: "zhankai-bai"), title: app.App_roomName, titlePosition: .left, additionalSpacing: 5, state: UIControlState())
                self.deviceDataSource = [Equip]()
                sxtData = [Equip]()
                self._btn.isSelected  = sxtData.count == 0
                self.homeTableView.reloadData()
                print("没有房间")
            }
            
        }
        else
        {
            app.App_roomName = ""
            self.titleBtn.set(image: UIImage(named: "zhankai-bai"), title: app.App_roomName, titlePosition: .left, additionalSpacing: 5, state: UIControlState())
            self.deviceDataSource = [Equip]()
            sxtData = [Equip]()
            self._btn.isSelected  = sxtData.count == 0
            self.homeTableView.reloadData()
            print("没有房间")
        }
        
    }
    
    //隐藏侧滑
    @objc func showSide(){
        print(self.sideView!.isOpen)
        if self.sideView!.isOpen
        {
            self.drakBtn.isHidden=true
            self.sideView?.closeTap()
        }else{
            self.drakBtn.isHidden=false
            self.sideView?.openTap()
        }
    }
    
    @objc func showSide2(){
        self.bgView?.isHidden = true
        self.drakBtn2.isHidden = true
    }
    
    
    func passTouch(_ dict: [AnyHashable: Any]!) {
        MBProgressHUD.showAdded(to: app.window, animated: true)
        Wrapper().pushCamera(self, dict: dict)
       
    }
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = false
        //        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        
        checkConnect()
        //刷新房间信息
        //第一次 从db先去获取 信息
        updateRoomInfo { [unowned self]() -> () in
            self.getRoomInfo()
            updateDeviceInfo(complete: { [unowned self]() -> () in
             
                self.refreshStatus()
                })
        }
        
        sideView?.isHidden = false
       
        self._btn.isSelected  = sxtData.count == 0
       // self.homeTableView.reloadData()
        
        
        //获取用户信息
        let parameters=["userPhone":BaseHttpService.getUserPhoneType()]
        BaseHttpService .sendRequestAccess(GetUser, parameters:parameters as NSDictionary) { (response) -> () in
            print("获取用户信息=\(response)")
            app.user = UserModel(dict: response as! [String:AnyObject])
            let arrayStr = (app.user?.city)!.components(separatedBy: "-")
            
            BaseHttpService.setUserCity(arrayStr[0] as NSString)
            
            print(app.user?.userName)
            
            self.sideView!.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .none)
        }
        
    }
    
    
    // MARK: - Table view data source
    //返回节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === sideView?.tableView{ return 1}
        if tableView===self.homeTableView{return 3}
        return 1
    }
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === sideView?.tableView{
            return 9
            
        }
        if tableView===self.homeTableView && section == 2{
            if deviceDataSource.count>1{
                return deviceDataSource.count}
            else {return 1}
        }
        if tableView===self.homeTableView && section == 0{
            return head
        }
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        //侧滑栏cell内容
        if tableView===sideView?.tableView{
            //个人信息
            if indexPath.row==0{
                cell = tableView.dequeueReusableCell(withIdentifier: "headerImgcell")
                if(cell == nil){
                    cell = SideHeaderCell.init(style: .default, reuseIdentifier: "headerImgcell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                }
                if BaseHttpService.getUserPhoneType() != ""{
                    (cell as! SideHeaderCell).titleLab.text = BaseHttpService.getUserPhoneType()
                }
                let str = imgUrl+(app.user?.headPic)!
                headerImgV.sd_setImage(with: URL(string: str), placeholderImage: UIImage.init(imageLiteralResourceName: "我的头像") )
                print("第二个 \(str)")
                (cell as! SideHeaderCell).imageV.sd_setImage(with: URL(string: str), placeholderImage: UIImage.init(imageLiteralResourceName: "我的头像") )
                return cell!
                
            }
            //其他功能模块
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "otherCells")
                if (cell == nil){
                    cell = SideOtherCell.init(style: .default, reuseIdentifier: "otherCells")
                }
                let nameArr = ["房间设备管理","情景设置","安防设置","授权解绑","安全中心","推送消息","用户指南","关于我们"]
                let imageArr = ["guanli","qingjingshez","anfangBlack","shouquanyonghu","safeCenter","tuisxx","yonghuzhin","guanyuwm"]
                
                (cell as! SideOtherCell).imageV.image = UIImage(named: imageArr[indexPath.row - 1])
                (cell as! SideOtherCell).titleLab.text = nameArr[indexPath.row - 1]
                
                cell?.imageView?.image = UIImage(named: imageArr[indexPath.row - 1])
                cell?.imageView?.isHidden = true
                cell?.accessoryType = .disclosureIndicator
                
                if indexPath.row == 4{
                    if BaseHttpService.getuiserlogoAccountType() == "M"{
                        (cell as! SideOtherCell).titleLab.text = "授权用户"
                    }else if BaseHttpService.getuiserlogoAccountType() == "S"{
                        (cell as! SideOtherCell).titleLab.text = "解除绑定"
                        
                    }
                }
            }
            cell!.selectionStyle=UITableViewCellSelectionStyle.default
            
        }
        
        //控制端cell内容
        else if tableView===self.homeTableView{
            //摄像头
            if indexPath.section == 0
            {
                headCell = self.homeTableView.dequeueReusableCell(withIdentifier: "HeadCell") as? HeadCell
               
                if sxtData.count > 0 && showSXT{
                    print("有摄像头了")
                    if headCell?.myScorllView == nil  {
                        headCell!.configHeadView()
                        var cameras = [HTCameras]()
                        for equip in sxtData
                        {
                            let  c = HTCameras()
                            c.id = equip.equipID;
                            c.name = "admin"
                            c.passWord = equip.num
                            c.deviceType = equip.type
                            //"hificat"
                            cameras.append(c)
                        }
                        //给模型 摄像头数据
                        headCell!.myScorllView.dataArray = cameras
                        headCell!.myScorllView.config()
                        headCell!.myScorllView.setupPage()
                        headCell?.myScorllView.delegate = self
                    }
                }
                else
                {
                  headCell!.removeHeadView()
                    
                }
                return headCell!
                
            }
            //情景模式
            if indexPath.section == 1
            {
                cell = self.homeTableView.dequeueReusableCell(withIdentifier: "RecentModelCell", for: indexPath)
                cell?.backgroundColor = UIColor.white
                (cell as? RecentModelCell)?.getModel()
                return cell!
            }
            
            //可操作设备
            if deviceDataSource.count < 1
            {
                cell = self.homeTableView.dequeueReusableCell(withIdentifier: "NoDeviceCell", for: indexPath)
                (cell as! NoDeviceCell).showLabel.text = NSLocalizedString("该房间暂无设备，点击添加", comment: "")
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                return cell!
            }
            let equip = deviceDataSource[indexPath.row] as! Equip
            print("设备名称及型号  \(equip.name)   \(equip.type) \(equip.icon)")
            if equip.type == "1"
            {//开关设备
                 cell = self.homeTableView.dequeueReusableCell(withIdentifier: "LightCell", for: indexPath)
                 cell?.backgroundColor = UIColor.white
                (cell as! LightCell).CallbackStat = { str in
                    print("str ---->"+"\(str)")
                    (self.deviceDataSource[indexPath.row] as! Equip).status = str
                }
                (cell as! LightCell).setModel(equip)
            }
            else if Int(equip.type) >= 1000 && Int(equip.type)<2000 {
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
                //射频锁
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
                    (self.deviceDataSource[indexPath.row] as! Equip).status = str;
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
         
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
 
    func judgeType(_ str:String,type:String)->Bool
   {
    if str.trimString() == ""
    {
    return false
    }
    let str1 = str as NSString

    return  str1.substring(to: 1) == type && str1.length == 4
    }
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //侧滑栏点击
        if tableView===sideView?.tableView{
            self.showSide()
            //用户信息
            if indexPath.row == 0 {
                let indvc:IndividuaViewController=IndividuaViewController(nibName: "IndividuaViewController", bundle: nil)
                indvc.hidesBottomBarWhenPushed=true
                self.navigationController!.pushViewController(indvc, animated:true)
            }
            //管理房间和设备
            else if indexPath.row == 1{
                modifyRoomInfo()
            }
            //情景设置
            else if indexPath.row == 2{
                let sceneVC = SceneSectionVC(nibName: "SceneSectionVC", bundle: nil)
                sceneVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(sceneVC, animated: true)
            }
                else if indexPath.row == 3{
                if BaseHttpService.GetAccountOperationType() == "2"{
                    showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                    return
                }
                let safeType = SafeTypeTVC();
                print("添加安防 : \(app.App_room)")
                safeType.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(safeType, animated: true)
            }
            //授权解绑
            else if indexPath.row == 4{
                if BaseHttpService.getuiserlogoAccountType() == "M"{
//                    let view = ApprovalViewController(nibName: "ApprovalViewController", bundle: nil)
//                    view.hidesBottomBarWhenPushed=true
//                    self.navigationController!.pushViewController(view, animated:true)
                    
                    let vc = ApprovalManageViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController!.pushViewController(vc, animated:true)
                    
                    
                }else if BaseHttpService.getuiserlogoAccountType() == "S"{
                    let alert = UIAlertView(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("确认解绑？", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("确定", comment: ""), otherButtonTitles: NSLocalizedString("取消", comment: ""))
                    alert.tag = 2
                    alert.show()

                }
            }
            else if indexPath.row == 5{
                let vc1 = MyPasser()
                vc1.hidesBottomBarWhenPushed=true
                self.navigationController!.pushViewController(vc1, animated:true)
            }
            else if indexPath.row == 6{
                let pushMessage = PushMessageViewController()
                pushMessage.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(pushMessage, animated: true)
//                let tuisong = GuiRecordViewController()
//                tuisong.hidesBottomBarWhenPushed=true //隐藏分栏
//                self.navigationController?.pushViewController(tuisong, animated: true)
            }
            else if indexPath.row == 7{
                let userHelp = MallViewController()
                userHelp.strUrl = "http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=article.list.categorylist&cateid=75"
                userHelp.strNavTitle = "用户指南"
                userHelp.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(userHelp, animated: true)
            }
            //关于我们
            else if indexPath.row == 8{
                let aboutus = AboutUSViewController();
                aboutus.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(aboutus, animated: true)
            }

        }

        //主tableview  添加设备 其他通过cell 操作
        else{
            if deviceDataSource.count < 1 && indexPath.section == 2
            {
                if BaseHttpService.GetAccountOperationType() == "2"{
                    showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                    return
                }
                let handly = HandlyAddDevice()
                handly.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(handly, animated: true)
                return
            }

        }

    }
    
    //清除缓存
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 1{
            if buttonIndex == 0{
                let cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                let files = FileManager.default.subpaths(atPath: cachPath )
                for p in files!{
                    
                    let path = (cachPath as NSString).appendingPathComponent(p)
                    if FileManager.default.fileExists(atPath: path){
                        do{
                            try FileManager.default.removeItem(atPath: path)
                        }catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }else if alertView.tag == 2{
            if buttonIndex == 0{
                BaseHttpService.sendRequestAccess(subordinateAccountRemoveAuthorize, parameters: ["userPhone":BaseHttpService.getUserPhoneType()], success: { [unowned self](any) -> () in
                    self.didSelectedEnter()
                    })
            }
        }
        
        
    }
    func didSelectedEnter(){
        
        let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
        UserDefaults.standard.set(0, forKey: "\(BaseHttpService.userCode())RoomInfoVersionNumber")
        BaseHttpService.clearToken()
        app.window!.rootViewController=nav
        UserDefaults.standard.set("0", forKey: "password")
    }
   
    func getEquip(_ equip_id:String)->Equip?
    {
        for e in self.deviceDataSource
        {
            
            if (e as! Equip).equipID == equip_id
            {
            return e as? Equip
            }
        }
        return nil
    }
    
    //更改索引
    func indexPathsOfDeal(_ item:RoomListItem, nowIndexPath nowPath:IndexPath ) ->NSArray{
        if  item.items.count == 0 {
            return []
        }
        let mArr = NSMutableArray(capacity:1)
        //
        for i in 0..<item.items.count{
            let indexPath:IndexPath = IndexPath(row: nowPath.row+i+1, section: nowPath.section)
            mArr.add(indexPath)

        }
        return mArr;
    }

    //高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView === self.homeTableView{
            if indexPath.section == 0{
            return ScreenHeight  * 100 / 320
//                return 180
            }
            if indexPath.section == 1
            {
//                return ScreenWidth / 4.5 - 9
                return 98
            }
            if deviceDataSource.count < 1{
            return 44
            }
            let equip = deviceDataSource[indexPath.row] as! Equip


            if equip.type == "1" || judgeType(equip.type, type: "1")

            {
                return 65
            }
            else if  equip.type == "8" || equip.type == "32" || equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "3")||judgeType(equip.type, type: "2" )

            {
                return 65
            }
             else if equip.type == "99" || equip.type == "98" ||  equip.type == "5" || equip.type == "501"
            {

             return 65
            }
            else if Int(equip.type) >= 4000 && Int(equip.type)<5000 {
                return 65
            }
            else if Int(equip.type) == 5314 {
                return 65
            }
            return 50
        }
        if tableView === sideView?.tableView{

            if indexPath.row == 0{
                return 205}

            return 55
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0{
        return 0.001
        }
        return 38
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 120,height: 38))
        label.textColor = UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.00)
        label.font = UIFont.systemFont(ofSize: 17.0)

        let view = UIView(frame:  CGRect(x: 0,y: 0,width: ScreenWidth,height: 38))
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        view.addSubview(label)
        switch(section){
        case 0:

            label.text = ""

            break
        case 1:

            label.text = NSLocalizedString("  情景模式", comment: "")
            label.font = UIFont.systemFont(ofSize: 15)
            let btn = UIButton(frame:  CGRect(x: 60,y: 0,width: ScreenWidth-120,height: 30))
                btn.setImage(UIImage(named: "up_black"), for: UIControlState())
                btn.setImage(UIImage(named: "down_black"), for: UIControlState.selected)
            btn.addTarget(self, action: #selector(HomeVC.open(_:)), for: UIControlEvents.touchUpInside)
            btn.isSelected = btnIsSeleted
            view.addSubview(btn)
            break

        default:
            label.text = NSLocalizedString("  房间设备", comment: "")
            label.font = UIFont.systemFont(ofSize: 15)
        }
        return view
    }
    //手势识别
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.drakBtn.isHidden=true
         headCell!.removeHeadView()
    }

    @objc func open(_ sender:UIButton){
    sender.isSelected = !sender.isSelected
        btnIsSeleted = sender.isSelected
        if sender.isSelected
        {
            if(!showSXT){
                _cameraBtn?.isHidden = true
            }
            removeOneCell()
        }else{
            if(!showSXT){
                _cameraBtn?.isHidden = false
            }
            addOneCell()
        }
    print("点击----")
    }
   func addOneCell()
     {
        head = 1
        self.homeTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.middle)
      
        
      
    }
    func removeOneCell()
    {
        

        head = 0
        self.homeTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.middle)
      
   
      
    }
    
    
    @IBAction func checkTap(_ sender: UIButton) {
        print("\(sender.tag)")
        anfangCheck.isSelected = anfangCheck.tag == sender.tag
        jiajuCheck.isSelected = jiajuCheck.tag == sender.tag
    }
   
    @IBAction func qxTap(_ sender: UIButton) {
//        popView.removeFromSuperview()
//        drakBtn.isHidden = true
    }
   
    @IBAction func qrTap(_ sender: AnyObject) {
       
//        let chainView = ChainEquipAddVC()
//        chainView.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(chainView, animated: true)
     
    }
    @IBAction func leftTap(_ sender: AnyObject) {
        print("左")
        if getCodeOfRooms(app.App_room, isNext: true){
            nextOne()
        }
    }
  
    @IBAction func rightTap(_ sender: AnyObject) {
        print("右")
        if getCodeOfRooms(app.App_room, isNext: false){
            preOne()
        }else{
            self.showSide()
        }
        
    }
    func getCodeOfRooms(_ roomCode:String,isNext:Bool)->Bool{
        let allrooms = dataDeal.getModels(type: DataDeal.TableType.Room) as! Array<Room>
        if allrooms.count == 0{
            return false
        }
        var i = 0
        for j in 0...allrooms.count-1 {
            i = j
            if allrooms[i].roomCode == roomCode{
                break
            }
        }
        if i == allrooms.count{
             return false
        }
        if i == 0 && !isNext
        {
             return false
        }
        if i == allrooms.count-1 && isNext
        {
            return false
        }
      
         app.App_room = allrooms[i+(isNext ? 1 : -1)].roomCode
         app.App_roomName = allrooms[i+(isNext ? 1 : -1)].name
        print(app.App_roomName)
        return true
    }
    
    func preOne(){
//        let transition = CATransition()
//        transition.type = kCATransitionPush//可更改为其他方式
//        transition.subtype = kCATransitionFromLeft//可更改为其他方式
//        let homevc:HomeVC=HomeVC(nibName: "HomeVC", bundle: nil)
//      
//        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//        self.navigationController?.pushViewController(homevc, animated: false)
        
        self.refreshStatus()
    }
     func nextOne()
    {
//        let transition = CATransition()
//        transition.type = kCATransitionPush//可更改为其他方式
//        transition.subtype = kCATransitionFromRight//可更改为其他方式
//        let homevc:HomeVC=HomeVC(nibName: "HomeVC", bundle: nil)
//        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//        self.navigationController?.pushViewController(homevc, animated: false)
        
        
        self.refreshStatus()
        
    }
    
    //    //MARK-转屏适配-optional
//    func statusBarOrientationChange(notification:NSNotification)
//        
//    {
//        
//        let  orientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
//        if orientation == UIInterfaceOrientation.LandscapeRight||orientation == UIInterfaceOrientation.LandscapeLeft && !(orientationLast==UIInterfaceOrientation.LandscapeRight)// home键靠右
//        {
//            
//            orientationLast=UIInterfaceOrientation.LandscapeRight
//            sideView!.frame=CGRectMake(ScreenHeight-(ScreenWidth-sideView!.frame.origin.x),-35, sideView!.frame.size.width,ScreenWidth+35);
//           // hscroll!.frame=CGRectMake(0,20, ScreenHeight-60, 64);
//            self.drakBtn.frame=CGRectMake(0, 31,ScreenHeight, ScreenWidth)
//            
//        }
//        
//        if orientation == UIInterfaceOrientation.Portrait && !(orientationLast==UIInterfaceOrientation.Portrait)
//            
//        {
//            orientationLast=UIInterfaceOrientation.Portrait
//            sideView!.frame=CGRectMake(ScreenWidth-(ScreenHeight-sideView!.frame.origin.x), 0, sideView!.frame.size.width,ScreenHeight);
//           // hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
//            self.drakBtn.frame=CGRectMake(0, 64, ScreenWidth,ScreenHeight)
//        }
//        
//        
//        if (orientation == UIInterfaceOrientation.PortraitUpsideDown)
//            
//        { 
//            //
//            
//        }
//        
//    }
    
}


