//
//  RecentModelCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/8.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RecentModelCell: UITableViewCell ,UICollectionViewDataSource,UICollectionViewDelegate,DeleModels{
    @IBOutlet var collectionView: UICollectionView!
//  var arr = [UIImage.init(imageLiteralResourceName:"icon1.png"),UIImage.init(imageLiteralResourceName: "icon2.png"),UIImage.init(imageLiteralResourceName: "icon3.png"),UIImage.init(imageLiteralResourceName: "icon4.png"),UIImage.init(imageLiteralResourceName: "icon5.png"),UIImage.init(imageLiteralResourceName: "icon6.png"),UIImage.init(imageLiteralResourceName: "icon7.png"),UIImage.init(imageLiteralResourceName: "icon8.png"),]
    var name = ["回家","上班","娱乐","就餐","回家","上班","娱乐","就餐"]
    
    //代理 删除之后刷新
    func DeleRefresh(_ modeleId: String){
        self.getModel()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.sectionInset = UIEdgeInsetsMake(17, 15, 17, 15)
//        layout.itemSize = CGSizeMake(ScreenWidth / 4.5 - 10, ScreenWidth / 4.5 - 10);
        layout.itemSize = CGSize(width: 60, height: 64);
        layout.minimumLineSpacing = 37
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //注册Cell，必须要有
        let nib = UINib(nibName: "ModelCell", bundle: Bundle.main)
        self.collectionView.register(nib , forCellWithReuseIdentifier: "model_cell")
        print("sssss")
        
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    func getModel(){
        BaseHttpService .sendRequestAccess(Get_gainmodel, parameters:["":""]) { (response) -> () in
            print(response)
        app.models = [ChainModel]()
            if response.count == 0{
                self.collectionView.reloadData()
            return
            }
            for model in (response as! Array<Dictionary<String,String>>)
            {
                let modele = ChainModel()
                modele.modelName = model["modelName"]!
                modele.modelId = model["modelId"]!
                modele.modelIcon = model["ico"]!
                self.setmodelss(modele)
            }
            self.collectionView.reloadData()
        }
    }
    
    func setmodelss(_ model:ChainModel){
        app.models.append(model)
    }
    //定义展示的UICollectionViewCell的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app.models.count + 1;
    }
    //定义展示的Section的个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if indexPath.row == app.models.count
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "model_cell", for: indexPath) as? ModelCell
            cell?.name.font = UIFont.systemFont(ofSize: 14.0)
            cell?.icon.image = UIImage(named: "icon_add_model")
            cell?.name.text = NSLocalizedString("添加", comment: "")
            cell?.removeLongPass()
            cell?.tag = indexPath.row
            return cell!
        
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "model_cell", for: indexPath) as? ModelCell
        cell?.name.font = UIFont.systemFont(ofSize: 14.0)
        cell?.icon.image = UIImage(named: app.models[indexPath.row].modelIcon)
       // cell?.icon.image =  self.arr[indexPath.row]
        cell?.name.text = app.models[indexPath.row].modelName
        cell?.addLongPass()
        cell?.tag = indexPath.row
        cell?.modelID = app.models[indexPath.row].modelId
        cell?.model = app.models[indexPath.row]
        cell?.delegate=self
        return cell!
        }
    }
    
    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == app.models.count
        {
//            if BaseHttpService.GetAccountOperationType() == "2"{
//                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
//                return
//            }
            let chainView = ChainEquipAddVC()
            chainView.NameText = "添加情景模式"
            chainView.hidesBottomBarWhenPushed = true
            self.parentController()?.navigationController?.pushViewController(chainView, animated: true)
            print("点击添加");
          
        }else
        {
            let m = app.models[indexPath.row] 
        // 使用
            BaseHttpService.sendRequestAccess(commandmodel, parameters: ["modelId":m.modelId]) { (backJson) -> () in
                print(backJson)
              
            }
        }
    }
    
    
 
    func parentController()->HomeVC?
    {
        var next = self.superview
        while next != nil {
            let nextr = next?.next
            if nextr!.isKind(of: HomeVC.classForCoder()){
                return (nextr as! HomeVC)
            }
            next = next?.superview
        }
        return nil
    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
