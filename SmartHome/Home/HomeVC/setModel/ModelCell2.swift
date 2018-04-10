//
//  ModelCell.swift
//  SmartHome
//
//  Created by sunzl on 16/2/25.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ModelCell2: UICollectionViewCell,UIActionSheetDelegate {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    //model ID
    var modelID:String?
    //model
    var model = ChainModel()
    //手势长按
    lazy var longPressGR:UILongPressGestureRecognizer = {
        var long:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ModelCell2.longPress(_:)))
        return long
    }()
    func addLongPass()
    {
        longPressGR.minimumPressDuration = 0.5;
        self.addGestureRecognizer(longPressGR)
    }
    func removeLongPass()
    {
        self.removeGestureRecognizer(longPressGR)
    }
    func parentController()->UIViewController?
    {
        var next = self.superview
        while next != nil {
            let nextr = next?.next
            if nextr!.isKind(of: UIViewController.classForCoder()){
                return (nextr as! UIViewController)
            }
            next = next?.superview
        }
        return nil
        
    }
    //按钮长按事件
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            self.removeLongPass()
            print("情景模式管理长按");
//            if BaseHttpService.GetAccountOperationType() == "2"{
//                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
//                return
//            }
            
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("编辑", comment: ""), NSLocalizedString("删除", comment: ""))
            actionSheet?.show(in: (self.parentController()?.view)!)
            
            return
        }
        
        
    }
    
    //长按事件
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //取消
            break
        case 1:
            print("编辑1")
            let chainView = ChainEquipAddVC()
            chainView.hidesBottomBarWhenPushed=true
            chainView.model = self.model
            chainView.NameText = "编辑情景模式"
           // chainView.model?.modelId = self.modelID!
        self.parentController()?.navigationController?.pushViewController(chainView, animated: true)
            break
        case 2:
            print("删除")
            //删除 在查找 [unowned self]
            BaseHttpService .sendRequestAccess(Dele_deletemodel, parameters:["modelId":self.modelID!]) {[unowned self] (response) -> () in
                print(response)
                self.delegate?.DeleRefresh(self.modelID!)
            }
            break
        default:
            break
        }
        self.addGestureRecognizer(longPressGR)
    }
    //代理
    weak var delegate:DeleModels2?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

protocol DeleModels2:NSObjectProtocol{
    func DeleRefresh(_ modeleId:String)
}
