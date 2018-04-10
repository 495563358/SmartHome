//
//  ContactsTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/11/11.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,DeleModels1{
    
    var equip:Equip?
    var lockUserArr = [LockUser]() //保存门锁成员
    
    @IBOutlet weak var ContaCell: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()

        //水平滑动
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
       // layout.itemSize = CGSizeMake(ScreenWidth / 3.5 - 10, ScreenWidth / 3.5 - 10);
        layout.itemSize = CGSize(width: 110, height: 131);
        self.ContaCell.collectionViewLayout = layout
        self.ContaCell.backgroundColor = UIColor.white
        self.ContaCell.delegate = self
        self.ContaCell.dataSource = self
        
        // Initialization code
        let nib = UINib(nibName: "ModelCell1", bundle: Bundle.main)
        self.ContaCell.register(nib , forCellWithReuseIdentifier: "model1")
        self.ContaCell.reloadData()
    }
    
    func getHttp(){
        let dic1 = ["lockAddress":self.equip!.equipID]
        BaseHttpService.sendRequestAccess(gainFingerprintMembers, parameters: dic1 as NSDictionary) { (arr) -> () in
            print(arr)
            self.lockUserArr = []
            if arr.count == 0{
                return
            }
            for var i in 0...arr.count-1
            {
                let info = (arr as! NSArray)[i] as! NSDictionary
                let lockuser = LockUser()
                lockuser.setValue(userID: info["fingerprintMembersId"] as! String, lockAddress: info["lockAddress"] as! String, userimg: info["membersHeadpic"] as! String, userName: info["membersName"] as! String,usersubscript: info["subscript"] as! String)
                self.lockUserArr.append(lockuser)
            }
            self.ContaCell.reloadData()
        }
    }
    
    
    
    func DeleRefresh(_ modeleId: String){
        self.getModel()
    }
    func getModel(){
        
    }
    //定义展示的UICollectionViewCell的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lockUserArr.count;
    }
    //定义展示的Section的个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "model1", for: indexPath) as! ModelCell1
        //cell?.icon.image = UIImage(named: app.models[indexPath.row].modelIcon)
        
        let str = imgUrl+(self.lockUserArr[indexPath.row].userimg)
        cell.icon.sd_setImage(with: URL(string: str))
        if self.lockUserArr[indexPath.row].userName == ""{
            cell.name.text = NSLocalizedString("用户", comment: "")
        }else{
            cell.name.text = self.lockUserArr[indexPath.row].userName
        }
        cell.num.text = self.lockUserArr[indexPath.row].usersubscript
        cell.addLongPass()
        cell.tag = indexPath.row
        //cell.modelID = app.models[indexPath.row].modelId
        //cell.model = app.models[indexPath.row]
        cell.lockuser = self.lockUserArr[indexPath.row]
        cell.delegate=self
        return cell
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
