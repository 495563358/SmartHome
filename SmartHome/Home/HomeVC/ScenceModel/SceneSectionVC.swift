//
//  SceneSectionVC.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/17.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SceneSectionVC: UICollectionViewController,DeleModels2,UIGestureRecognizerDelegate {
    
    var itemDataSource: [String : [String]] = [NSLocalizedString("长按可修改您的情景模式", comment: "") : ["huijia","anfang", "guandeng", "huike", "jiucan","kaideng", "lijia", "qichuang", "qiye", "shangban", "shuijiao", "xiaban", "yingyuan", "yinyue", "youxi"]]
    
    let nameArr:[String] = ["回家","安防","关灯","会客","就餐","开灯","离家","起床","夜间","上班","睡觉","下班","影院","音乐","游戏"]
    
    //var arr = [UIImage(imageLiteral: "icon1.png"),UIImage(imageLiteral: "icon2.png"),UIImage(imageLiteral: "icon3.png"),UIImage(imageLiteral: "icon4.png"),UIImage(imageLiteral: "icon5.png"),UIImage(imageLiteral: "icon6.png"),UIImage(imageLiteral: "icon7.png"),UIImage(imageLiteral: "icon8.png"),]
    
    var sectionDataSource: [String] = [NSLocalizedString("长按可修改您的情景模式", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "情景设置"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.view.backgroundColor = themeColors
        
        let rightBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightBtn.setImage(UIImage(named: "tianjiasb"), for: UIControlState())
        rightBtn.addTarget(self, action: Selector("addScene"), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        // Register cell classes
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ScreenWidth / 3 - 1, height: ScreenWidth / 3 - 1)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: 30)
        self.collectionView!.collectionViewLayout = flowLayout
        
        self.collectionView!.register(UINib(nibName: "ChooseHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "chooseheaderview")
        self.collectionView!.register(UINib(nibName: "EquipCollectionCell", bundle: nil), forCellWithReuseIdentifier: "equipcollectioncell")
        
        //注册Cell，必须要有
        let nib = UINib(nibName: "ModelCell2", bundle: Bundle.main)
        self.collectionView!.register(nib , forCellWithReuseIdentifier: "model_cell")
        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SceneSectionVC.backClick))
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getModel()
    }
    
    // MARK: UICollectionViewDataSource
    
    func getModel(){
        BaseHttpService .sendRequestAccess(Get_gainmodel, parameters:["":""]) { (response) -> () in
            print(response)
            app.models = [ChainModel]()
            if response.count == 0{
                self.collectionView!.reloadData()
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
            self.collectionView!.reloadData()
        }
    }
    
    func setmodelss(_ model:ChainModel){
        app.models.append(model)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return app.models.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "model_cell", for: indexPath) as? ModelCell2
        cell?.name.font = UIFont.systemFont(ofSize: 14.0)
        cell?.icon.image = UIImage(named: app.models[indexPath.row].modelIcon)
        cell?.name.text = app.models[indexPath.row].modelName
        cell?.addLongPass()
        cell?.tag = indexPath.row
        cell?.modelID = app.models[indexPath.row].modelId
        cell?.model = app.models[indexPath.row]
        cell?.delegate=self
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    //代理 删除之后刷新
    func DeleRefresh(_ modeleId: String){
        self.getModel()
    }
    
    @objc func addScene(){
//        if BaseHttpService.GetAccountOperationType() == "2"{
//            showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
//            return
//        }
        let chainView = ChainEquipAddVC()
        chainView.NameText = "添加情景模式"
        chainView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chainView, animated: true)
        print("点击添加");
    }
    
    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let m = app.models[indexPath.row]
        // 使用
        BaseHttpService.sendRequestAccess(commandmodel, parameters: ["modelId":m.modelId]) { (backJson) -> () in
            print(backJson)
            
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "chooseheaderview", for: indexPath) as! ChooseHeaderView
        headerView.viewTitleLabel.text = sectionDataSource[indexPath.section]
        
        return headerView
    }
    
    
    // MARK: UICollectionViewDelegate
    
    fileprivate var imageAction: ((_ imageName:String) -> ())?
    
    func chooseImageBlock(_ block: @escaping (_ imageName:String) -> ()) {
        imageAction = block
    }
    
    
    
    
}
