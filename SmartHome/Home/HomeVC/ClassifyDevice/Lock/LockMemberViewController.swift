//
//  LockMemberViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/11/11.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LockMemberViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    var tabArr = [NSLocalizedString("头像", comment: ""),NSLocalizedString("名称", comment: "")]
    var lockuser:LockUser?
    var curentImage:UIImage?//图片
    
    var tableView: UITableView = UITableView(frame: UIScreen.main.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "修改信息"


        // Do any additional setup after loading the view.
        self.tableView = UITableView(frame: UIScreen.main.bounds)

        tableView.register(UINib(nibName:"OtherTableViewCell", bundle: nil), forCellReuseIdentifier:"Other")
        tableView.register(UINib(nibName:"HeadImgTableViewCell", bundle: nil), forCellReuseIdentifier:"Head")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.tableView)
        
    }
    
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0   {return 96}
        return 48
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            //          PersonalCell 自定cell
            let  cellImg = tableView.dequeueReusableCell(withIdentifier: "Head") as? HeadImgTableViewCell
            //cell 箭头
            cellImg!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cellImg?.HeadImg.image = UIImage(named: "我的头像")
            cellImg!.HeadImg.contentMode = UIViewContentMode.scaleToFill
            cellImg!.leab!.text = tabArr[indexPath.row]
            if self.curentImage != nil{
                //选择图片
                cellImg?.HeadImg.image = self.curentImage
            }else if app.user?.headPic != ""{
                if app.user?.headPic != nil{
                    let str = imgUrl+(app.user?.headPic)!
                    cellImg!.HeadImg.sd_setImage(with: URL(string: str))
                }
                
            }
            
            return cellImg!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Other") as? OtherTableViewCell
            //cell 箭头
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell!.information.text = self.lockuser?.userName
            cell?.leab.text = tabArr[indexPath.row]
            return cell!
            
        }
        

    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if actionSheet.tag == 310{
            if buttonIndex==1{
                self.LoaclPhoto()
            }else if buttonIndex==2{
                self.takePhoto()
            }
        
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil,otherButtonTitles:NSLocalizedString("从相册选择", comment: ""), NSLocalizedString("拍照", comment: ""))
            actionSheet!.tag = 310;
            actionSheet?.show(in: self.tableView)
            break
        default:
            let indvc:AlterViewController=AlterViewController(nibName: "AlterViewController", bundle: nil)
            indvc.alteText = NSLocalizedString("修改姓名", comment: "");
            indvc.textName = self.lockuser?.userName
            indvc.lockuser = self.lockuser
            
            //将当前someFunctionThatTakesAClosure函数指针传到第二个界面，第二个界面的闭包拿到该函数指针后会进行回调该函数
            indvc.myClosure = somsomeFunctionThatTakesAClosure
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        }
    }
    //闭包函数
    func somsomeFunctionThatTakesAClosure(_ string:String) -> Void{
        print(string)
        self.lockuser?.userName = string
        self.tableView.reloadData()
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
                self.present(picker!, animated: true, completion: nil)
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
            self.present(picker!, animated: true, completion: nil)
        }
        //获取图片
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            self.curentImage = image;
            
            self.tableView.reloadData()
            saveImage(image, imageName: "1236")
            //dismissViewControllerAnimated:YES completion:nil
            self.dismiss(animated: true, completion: nil)
        }
        func saveImage(_ currentImage:UIImage,imageName:NSString){
            let imageData:Data = UIImageJPEGRepresentation(currentImage, 0.5)!
            //fingerprintHeadpic
            let url = "\(fingerprintHeadpic)"+"?fingerprintMembersId=\(self.lockuser!.userID)"
            print(url)
            BaseHttpService.locksaveImageAccess(url, data: imageData) { (arr) -> () in
                
            }
           //开始上传操作
        }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
