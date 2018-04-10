//
//  ModelCell.swift
//  SmartHome
//
//  Created by sunzl on 16/2/25.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ModelCell1: UICollectionViewCell,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet weak var num: UILabel!
    
    var lockuser:LockUser?
    //model ID
    var modelID:String?
    //model
    var model = ChainModel()
    //手势长按
    lazy var longPressGR:UILongPressGestureRecognizer = {
        var long:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ModelCell1.longPress(_:)))
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
            if BaseHttpService.GetAccountOperationType() == "2"{
                showMsg(msg: NSLocalizedString("无操作权限", comment: ""))
                return
            }
            self.removeGestureRecognizer(sender)
            print(self.tag)
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("修改", comment: "")/*, NSLocalizedString("删除", comment: "")*/)
            actionSheet?.show(in: self.superview!)
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
//            let chainView = LockMemberViewController(nibName: "LockMemberViewController", bundle: nil)
//            chainView.hidesBottomBarWhenPushed=true
//            chainView.lockuser = self.lockuser
//            chainView.curentImage = self.icon.image
//            self.parentController()?.navigationController?.pushViewController(chainView, animated: true)
            break
        case 2:
            print("删除")
            break
        case 3:
            print("从相册选择")
            self.LoaclPhoto()
            break
        case 4:
            print("拍照")
            self.takePhoto()
        default:
            break
        }
        self.addGestureRecognizer(longPressGR)
    }
    //打开相机
    func takePhoto(){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let picker: UIImagePickerController?=UIImagePickerController()
            picker!.delegate = self
            //设置拍照后的图片可被编辑
            picker?.allowsEditing = true
            picker?.sourceType = sourceType
            self.parentController()!.present(picker!, animated: true, completion: nil)
        }
        else{
            print("模拟机无法打开")
        }
    }

    //相册
    func LoaclPhoto(){
        let picker:UIImagePickerController?=UIImagePickerController()
        picker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker?.delegate = self
        //设置选择后的图片可被编辑
        picker?.allowsEditing = true
        self.parentController()!.present(picker!, animated: true, completion: nil)
    }
    //获取图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        saveImage(image, imageName: "1236")
        //dismissViewControllerAnimated:YES completion:nil
        self.parentController()!.dismiss(animated: true, completion: nil)
    }
    func saveImage(_ currentImage:UIImage,imageName:NSString){
        let imageData:Data = UIImageJPEGRepresentation(currentImage, 0.5)!
        
       
        
        //开始上传操作
    }
    //代理
    weak var delegate:DeleModels1?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.icon.layer.cornerRadius = 42.5
        self.icon.layer.masksToBounds = true
    }

}

protocol DeleModels1:NSObjectProtocol{
    func DeleRefresh(_ modeleId:String)
}
