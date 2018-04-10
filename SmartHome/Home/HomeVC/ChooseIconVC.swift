//
//  ChooseIconVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/31.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit


class ChooseIconVC: UICollectionViewController {
    //,"窗帘半开","窗帘关闭"
    var itemDataSource: [String : [String]] = [NSLocalizedString("为你的设备选取图标", comment: "") : ["普通灯泡","调光灯泡","摄像头","窗帘","窗帘半开","窗帘全关","窗帘全开","红外","影音设备","手拉卷帘","卷帘","窗帘电机","智能门锁","插座","阀门","电磁阀","电视","控制盒","挂式空调","立式空调","中央空调","排风扇","热水器","智能晾衣架","电动门窗","电动幕布","电动升降架","空气净化器","净水机","浇花灌溉","双向灯","调光开关","台灯"]]
    
    var sectionDataSource: [String] = [NSLocalizedString("为你的设备选取图标", comment: "")]
    
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
        self.collectionView!.register(UINib(nibName: "EquipCollectionCell", bundle: nil), forCellWithReuseIdentifier: "equipcollectioncell")

        // Do any additional setup after loading the view.
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "equipcollectioncell", for: indexPath) as! EquipCollectionCell
        cell.equipName.text = NSLocalizedString(itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item], comment: "")
        cell.equipImage.image = UIImage(named: itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item])
        // Configure the cell
        cell.equip.isHidden = true
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "chooseheaderview", for: indexPath) as! ChooseHeaderView
            headerView.viewTitleLabel.text = NSLocalizedString(sectionDataSource[indexPath.section], comment: "")
        
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
