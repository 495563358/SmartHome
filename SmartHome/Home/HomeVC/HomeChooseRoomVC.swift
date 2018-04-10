//
//  HomeChooseRoomVC.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/25.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class HomeChooseRoomVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //首先定义代码块类型
    typealias chooseRoomBlock = (IndexPath)->()
    //然后定义代码块属性
    var block:chooseRoomBlock?
    
    //实现代码块
    func callBlock(block:chooseRoomBlock?) {
        
        self.block = block
        
    }
    var flag:Int = 0
    
    var floorArr: [Building] = []
    var roomArr: [[Building]] = []
    var roomDic: [String : [Building]] = [String : [Building]]()
    var showroomDic: [String : [Building]] = [String : [Building]]()
    var dataSource: [Building] = []
    
    var collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    
    
    //楼层信息组装
    func assembleFloor() -> String {
        var subArr = [[String : String]]()
        for floor in floorArr {
            subArr.append(["floorName" : floor.buildName,"floorCode" : floor.buildCode])
            
        }
        
        return dataDeal.toJSONString(jsonSource: subArr as AnyObject)
    }
    
    //房间信息组装
    func assembleRoom()->String {
        
        var subArr: [[String : String]] = []
        for key in roomDic.keys {
            for value in roomDic[key]! {
                if value != roomDic[key]?.last {
                    var suDic = ["roomName" : value.buildName]
                    suDic["floorName"] = key
                    suDic["roomCode"] = value.buildCode
                    subArr.append(suDic)
                }
            }
        }
        
        return dataDeal.toJSONString(jsonSource: subArr as AnyObject)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = themeColors
        
        let imgV = UIImageView.init(frame: CGRect(x: 0, y: -10, width: ScreenWidth, height: ScreenHeight - 54))
        imgV.image = UIImage(named: "qiehuanfj_beij")
        self.view.addSubview(imgV)
        
        self.navigationItem.title = "切换房间"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeChooseRoomVC.handleBack(_:)))
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize(width: ScreenWidth/2-31, height: (0.75) * (ScreenWidth/2-31))
        flowLayout.scrollDirection = .vertical
        flowLayout.footerReferenceSize = CGSize(width: ScreenWidth, height: 0.1)
        flowLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: 42)
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 5, 15)
        
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "StaticCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader , withReuseIdentifier: "HeaderView")
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionFooter , withReuseIdentifier: "FooterView")
        
        self.view.addSubview(collectionView)
    }
    
    
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let floor = dataSource[section]
        return (showroomDic[floor.buildName]?.count)!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "\(indexPath.section)StaticCell\(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(indexPath.section)StaticCell\(indexPath.row)", for: indexPath)
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        if(cell.contentView.subviews.count < 2){
            
            label.center = CGPoint(x: cell.contentView.mj_size.width/2, y: cell.contentView.mj_size.height/2)
            label.font = UIFont.systemFont(ofSize: 17)
            label.textAlignment = .center
            label.textColor = UIColor.white
            cell.contentView.addSubview(label)
            
            let imgV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.contentView.bounds.size.height))
            imgV.image = UIImage(named: "fangjianqiehuan_beijing")
            cell.contentView.addSubview(imgV)
        }
        label.text = (showroomDic[dataSource[indexPath.section].buildName])![indexPath.row].buildName
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block  =  self.block {
            
            block(indexPath)
            
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var v = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
            
            collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader , withReuseIdentifier: "HeaderView\(indexPath.section)")
            
            v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView\(indexPath.section)", for: indexPath)
            
            if v.subviews.count < 2{
                let floorName = UILabel.init(frame: CGRect(x: 10, y: 15, width: 100, height: 32))
                floorName.font = UIFont.systemFont(ofSize: 15)
                floorName.textColor = UIColor.white
                floorName.text = dataSource[indexPath.section].buildName
                v.addSubview(floorName)
                
                let btn = UIButton.init(frame: CGRect(x: ScreenWidth - 36,y: 24, width: 26, height: 14))
                btn.setImage(UIImage(named: "zhankai-bai"), for: UIControlState())
                btn.setImage(UIImage(named: "shouqi-bai"), for: .selected)
                btn.tag = indexPath.section
                btn.addTarget(self, action: #selector(HomeChooseRoomVC.hideorShow(_:)), for: .touchUpInside)
                v.addSubview(btn)
            }
            
            
            print(v.subviews.count)
            print(indexPath.section)
        }
        if kind == UICollectionElementKindSectionFooter{
            
            v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
        }
        return v
    }
    
    @objc func hideorShow(_ sender:UIButton){
        
        
        let floor = dataSource[sender.tag]
        if sender.isSelected{
            showroomDic[floor.buildName] = roomDic[floor.buildName]
        }else{
            showroomDic[floor.buildName]?.removeAll()
        }
        
        sender.isSelected = !sender.isSelected
        
        self.collectionView.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(15, 15, 5, 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //刷新数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floorArr = []
        roomDic = [String : [Building]]()
        showroomDic = [String : [Building]]()
        dataSource = []
        updateRoomInfo { () -> () in
            
            self.getRoomInfoForCreate()
            self.collectionView.reloadData()
        }
        
    }
    
    
    func getRoomInfoForCreate(){
        
        //得到所有floor
        let floors = dataDeal.getModels(type: DataDeal.TableType.Floor) as! Array<Floor>
        for _floor in floors{
            let floor = Building(buildType: .buildFloor, buildName:  _floor.name, isAddCell: false)
            floor.buildCode = _floor.floorCode
            floorArr.append(floor)
            dataSource.append(floor)
            let rooms = dataDeal.getRoomsByFloor(floor: _floor)
            floor.isUnfold = true//打开
            
            var roomArr: [Building] = []
            for _room in rooms{
                let room = Building(buildType: .buildRoom, buildName: _room.name, isAddCell: false)
                room.buildCode = _room.roomCode
                print(room.buildName)
                room.floor = floor
                roomArr.append(room)
                
            }
            roomDic[floor.buildName] = roomArr
            showroomDic[floor.buildName] = roomArr
        }
    }


}
