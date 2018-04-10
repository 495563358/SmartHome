//
//  CameraCollectionView.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
import MJRefresh

class CameraCollectionView: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var roomCode = ""
    var dataSource = NSArray()
    var currentPageIndex = 0
    var needRefresh = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing  = 1;
        layout.itemSize = CGSize(width: ScreenWidth / 2 - 2, height: (ScreenWidth / 2 - 2 ) / 144 * 129);
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.white
        //注册Cell，必须要有
        let nib = UINib(nibName: "CameraCell", bundle: Bundle.main)
        self.collectionView.register(nib , forCellWithReuseIdentifier: "CameraCell")
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(CameraCollectionView.MJRefreshHeaderReload))
        
        let footer = MJRefreshFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(CameraCollectionView.MJRefreshFooterReload))
        
        
       
        // Do any additional setup after loading the view.
    }
    
    @objc func MJRefreshHeaderReload(){
        self.currentPageIndex = 0;
    
        print("刷新界面")
    
        EZOpenSDK.getCameraList(self.currentPageIndex, pageSize: 10, completion: { (cameraList, error) -> Void in
            // print("得到结果 %@",error)
            self.currentPageIndex += 1
            if error != nil{
                if ((error! as NSError).userInfo["NSLocalizedDescription"] as! String == "https error code = 10002"){
                    BaseHttpService.sendRequestAccess(gaineztokens, parameters: [:], success: { (arr) -> () in
                print(arr)
                let ezToken = arr["Eztoken"]
    
                GlobalKit.share().accessToken = ezToken as! String
    
                EZOpenSDK.setAccessToken(GlobalKit.share().accessToken)
                BaseHttpService.setAccessToken(GlobalKit.share().accessToken! as NSString)
        
                self.collectionView.mj_header.beginRefreshing()
    
            })
        }
    }
    
    
    
            if cameraList == nil{
                self.collectionView.mj_header.endRefreshing()
                return
            }
            self.dataSource = []
    
    
            self.dataSource = cameraList as! NSArray
            print(" self.dataSource.count==\( self.dataSource.count)")
            self.collectionView.reloadData()
            self.collectionView.mj_header.endRefreshing()
        })
    }
    
    @objc func MJRefreshFooterReload(){
        EZOpenSDK.getCameraList(self.currentPageIndex, pageSize: 10, completion: { (cameraList, error) -> Void in
            if cameraList == nil{
                self.collectionView.mj_header.endRefreshing()
                return
            }
            if self.dataSource.count == 0
            {
                self.collectionView.mj_footer.isHidden = true;
                return;
            }
            self.dataSource.addingObjects(from: cameraList!)
            self.collectionView.reloadData()
            self.collectionView.mj_header.endRefreshing()
            self.currentPageIndex+=1
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.needRefresh)
        {
            self.needRefresh = false;
            self.collectionView.mj_header.beginRefreshing()
        }
        self.collectionView.reloadData()
    }
  
    //定义展示的UICollectionViewCell的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count;
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        var cell:CameraCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for:indexPath) as? CameraCell
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("CameraCell", owner: self, options: nil)?.first as? CameraCell
        }
        let ez = dataSource[indexPath.row] as! EZCameraInfo
        let equip = Equip(equipID: ez.cameraId)
        equip.name = ez.cameraName
        equip.type = "101"
        equip.icon = "list_camera"
        equip.roomCode = self.roomCode
        print("2----\(self.roomCode)")
        equip.num = ""
        equip.hostDeviceCode = "commonsxt"
        cell?.setCameraInfo(dataSource[indexPath.row] as! EZCameraInfo)
        cell?.setModel(equip)
        return cell!
    }
    
    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
         // 点击进入摄像头详情界面
//        let storyBoard=UIStoryboard(name: "EZMain", bundle: nil);
//        let ezlive:EZLivePlayViewController = storyBoard.instantiateViewControllerWithIdentifier("EZLivePlayViewController") as! EZLivePlayViewController
//        ezlive.cameraId = (dataSource[indexPath.row] as! EZCameraInfo).cameraId
//        ezlive.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(ezlive, animated: true)
    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
}
