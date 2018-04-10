//
//  SetModelVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class SetModelVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet var modelCollectionView: UICollectionView!
    var name = [NSLocalizedString("相库", comment: ""),NSLocalizedString("资讯", comment: ""),NSLocalizedString("圈子", comment: ""),NSLocalizedString("分享", comment: "")]
    var arr = [UIImage.init(imageLiteralResourceName: "xc.png"),UIImage.init(imageLiteralResourceName: "zx.png"),UIImage.init(imageLiteralResourceName: "qz.png"),UIImage.init(imageLiteralResourceName: "share.png")]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = false
        //        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        //self.navigationController?.navigationBar.backgroundColor =  UIColor(patternImage: navBgImage!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.backgroundColor =  UIColor(patternImage: navBgImage!)
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSize(width: ScreenWidth / 4 - 10, height: ScreenWidth / 4 - 10);
        self.modelCollectionView.collectionViewLayout = layout
        self.modelCollectionView.backgroundColor = UIColor.white
        self.navigationItem.title = NSLocalizedString("商圈", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //注册Cell，必须要有
        //let nib = UINib(nibName: "ModelCell", bundle: NSBundle.mainBundle())
        //self.modelCollectionView.registerNib(nib , forCellWithReuseIdentifier: "model_cell")
        modelCollectionView.register(UINib(nibName:"ModelCell", bundle: nil), forCellWithReuseIdentifier:"model_cell")
        // Do any additional setup after loading the view.
    }
    //定义展示的UICollectionViewCell的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    //定义展示的Section的个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        var cell:UICollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("model_cell", forIndexPath:indexPath)
        //        if (cell == nil) {
        //            cell = NSBundle.mainBundle().loadNibNamed("ModelCell", owner: self, options: nil).first as? UICollectionViewCell
        //
        //        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "model_cell", for: indexPath) as? ModelCell
        cell?.icon.image = arr[indexPath.row]
         cell?.name.text = name[indexPath.row]
        return cell!
    }
    
    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//                            let  popView = PopupView(frame: CGRect(x: 100, y: ScreenHeight-200, width: 0, height: 0))
//                            popView.parentView = UIWindow.visibleViewController().view
//                            popView.setText(NSLocalizedString("暂未开放敬请期待", comment: ""))
//                              popView.parentView .addSubview(popView)
    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
}
