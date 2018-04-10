//
//  ChooseIconVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/31.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit


class ChainVC: UICollectionViewController {
    
    var itemDataSource: [String : [String]] = [NSLocalizedString("为你的情景选取图标", comment: "") : ["huijia","anfang", "guandeng", "huike", "jiucan","kaideng", "lijia", "qichuang", "qiye", "shangban", "shuijiao", "xiaban", "yingyuan", "yinyue", "youxi"]]
//    ["icon1.png", "icon2.png", "icon3.png", "icon4.png", "icon5.png","icon6.png", "icon7.png", "icon8.png"]
    let nameArr:[String] = ["回家","安防","熄灯","会客","就餐","开灯","离家","起床","夜间","上班","安睡","下班","影院","音乐","游戏"]
    
//var arr = [UIImage(imageLiteral: "icon1.png"),UIImage(imageLiteral: "icon2.png"),UIImage(imageLiteral: "icon3.png"),UIImage(imageLiteral: "icon4.png"),UIImage(imageLiteral: "icon5.png"),UIImage(imageLiteral: "icon6.png"),UIImage(imageLiteral: "icon7.png"),UIImage(imageLiteral: "icon8.png"),]
    
    var sectionDataSource: [String] = [NSLocalizedString("为你的情景选取图标", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ScreenWidth / 3 - 1, height: ScreenWidth / 3 - 1)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: 30)
        self.collectionView!.collectionViewLayout = flowLayout
        
        self.collectionView!.register(UINib(nibName: "ChooseHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "chooseheaderview")
//        self.collectionView!.registerNib(UINib(nibName: "EquipCollectionCell", bundle: nil), forCellWithReuseIdentifier: "equipcollectioncell")
        
        let nib = UINib(nibName: "ModelCell2", bundle: Bundle.main)
        self.collectionView!.register(nib , forCellWithReuseIdentifier: "model_cell")
        
        navigationItem.title = "选取图标"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChainVC.handleBack(_:)))
        
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionDataSource.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemDataSource[sectionDataSource[section]]!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("equipcollectioncell", forIndexPath: indexPath) as! EquipCollectionCell
//        cell.equipName.text = nameArr[indexPath.row]
//        cell.equip.text = ""
//        cell.equipImage.image = UIImage(named: itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item])
        // Configure the cell
        
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "model_cell", for: indexPath) as? ModelCell2
        cell?.name.font = UIFont.systemFont(ofSize: 14.0)
        cell?.icon.image = UIImage(named: itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item])
        // cell?.icon.image =  self.arr[indexPath.row]
        cell?.name.text = nameArr[indexPath.row]
        cell?.backgroundColor = UIColor.white
        
        
        return cell!
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
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageAction?(itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item])
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
