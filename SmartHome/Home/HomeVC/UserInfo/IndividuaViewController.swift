//
//  IndividuaViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/29.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
class IndividuaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var tabArr = [NSLocalizedString("头像", comment: ""),NSLocalizedString("名称", comment: ""),NSLocalizedString("签名", comment: ""),NSLocalizedString("修改性别", comment: "" ),NSLocalizedString("选择城市", comment: "")];
    var usreArr = [" "," "," "," "]
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
    var cellArr = [OtherTableViewCell]()//存放cell
    var cellI:Int = 0
    var curentImage:UIImage?//图片
    var city:String?//城市
    var sex:String?//男女
    var areas:NSDictionary?
    @IBOutlet var walk: UIButton!
    @IBOutlet var tableView: UITableView!
//    var cellImg:HeadImgTableViewCell?
//    var cell:OtherTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 6.0
        tableView.layer.masksToBounds = true
        tableView.dataSource = self;
        tableView.delegate = self;
        //选择学校界面初始化
        sunData?.title.text = "选择城市"
        //显示导航栏
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        self.navigationItem.title = NSLocalizedString("个人信息", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        // self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView()
        //拉出cell
        tableView.register(UINib(nibName:"HeadImgTableViewCell", bundle: nil), forCellReuseIdentifier:"Head")
        tableView.register(UINib(nibName:"OtherTableViewCell", bundle: nil), forCellReuseIdentifier:"Other")
        //退出事件
        walk.setTitle(NSLocalizedString("退出登录", comment: ""), for: UIControlState())
        walk.addTarget(self, action: #selector(IndividuaViewController.tui(_:)), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
        
    }
    //拖拽手势取消
    
    //退出登录
    @objc func tui(_ but:UIButton){
        didSelectedEnter()
        
    }
    func didSelectedEnter(){
        
        let nav:UINavigationController = UINavigationController(rootViewController: ChangeLoginVC(nibName: "ChangeLoginVC", bundle: nil))
        UserDefaults.standard.set(0, forKey: "\(BaseHttpService.userCode())RoomInfoVersionNumber")
        BaseHttpService.clearToken()
        //let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.window!.rootViewController=nav
        // [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"password"];
        
        UserDefaults.standard.set("0", forKey: "password")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //节
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let languages = Locale.preferredLanguages
        let currentLanguage = languages[0]
        print(currentLanguage)
        //en-CN 英文
        //zh-Hans-CN 中文
        if currentLanguage == "en-CN"{
            return tabArr.count - 1
        }
        return tabArr.count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0 && indexPath.row==0{
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
        }
        else{
           
         let cell = tableView.dequeueReusableCell(withIdentifier: "Other") as? OtherTableViewCell
            //cell 箭头
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//            cell!.information.text = usreArr[indexPath.row-1]
//            cell!.leab!.text = tabArr[indexPath.row]
           
            switch(indexPath.row){
            
            case 1:
                cell!.information.text = app.user?.userName
                if app.user?.userName != nil{
                    self.usreArr[0] = (app.user?.userName)!
                }
                cell?.leab.text = tabArr[indexPath.row]
                break
            case 2:
                cell!.information.text = app.user?.signature
                cell?.leab.text = tabArr[indexPath.row]
                if app.user?.userName != nil{
                    self.usreArr[1] = (app.user?.signature)!
                }
                break
            case 3:
                if self.sex != nil
                {
                    cell!.information.text = NSLocalizedString(self.sex!, comment: "")
                    cell?.leab.text = tabArr[indexPath.row]
                }else
                {
                     cell!.information.text = NSLocalizedString((app.user?.userSex)!, comment: "")
                     cell?.leab.text = tabArr[indexPath.row]
                }
//                cell!.information.text = app.user?.userSex
//                cell?.leab.text = tabArr[indexPath.row]
                break
            case 4:
                if self.city != nil
                {
                    cell!.information.text = self.city
                    cell?.leab.text = tabArr[indexPath.row]
                }
                else
                {
                    cell!.information.text = app.user?.city
                    cell?.leab.text = tabArr[indexPath.row]
                }
               
                break
                //case sign
            default :
                break
            }
            cellArr.append(cell!)
            return cell!
        }
        
    }
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0   {return 96}
        return 48
    }
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("从相册选择", comment: ""), NSLocalizedString("拍照", comment: ""))
            actionSheet!.tag = 310;
            actionSheet?.show(in: self.tableView)
            break
        case 1:

            //从xib拉去
            let indvc:AlterViewController=AlterViewController(nibName: "AlterViewController", bundle: nil)
            indvc.alteText = NSLocalizedString("修改姓名", comment: "");
            print(usreArr[indexPath.row-1])
            indvc.textName = usreArr[indexPath.row-1]
            cellI = 0
            //将当前someFunctionThatTakesAClosure函数指针传到第二个界面，第二个界面的闭包拿到该函数指针后会进行回调该函数
            indvc.myClosure = somsomeFunctionThatTakesAClosure
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        case 2:
            //从xib拉去
            let indvc:AlterViewController=AlterViewController(nibName: "AlterViewController", bundle: nil)
            indvc.alteText = NSLocalizedString("修改签名", comment: "");
            cellI = 1
            indvc.textName = usreArr[indexPath.row-1]
            //将当前someFunctionThatTakesAClosure函数指针传到第二个界面，第二个界面的闭包拿到该函数指针后会进行回调该函数
            indvc.myClosure = somsomeFunctionThatTakesAClosure
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        case 3:
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("男", comment:"" ), NSLocalizedString("女", comment: ""))
            actionSheet!.tag = 320;
            //[actionSheet showInView:[UIApplication sharedApplication].keyWindow]
            actionSheet?.show(in: self.view)
           // actionSheet?.showInView(self.tableView)
            break
        case 4:
            let path = Bundle.main.path(forResource: "mJson", ofType: "json")
            var jsonstr:String?
            do {
                jsonstr = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            let jsondata = jsonstr?.data(using: String.Encoding.utf8)
            do {
                self.areas = try JSONSerialization.jsonObject(with: jsondata! , options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            print(self.areas)
            self.sunData?.setNumberOfComponents(3, set: self.areas, addTarget:self.navigationController!.view , complete: { (one, two, three) -> Void in
                let a = "\(one),\(two),\(three)"
                print(a)
                print("\(two)")
                print("\(1)")
                let parameters=["city":a,"userPhone":BaseHttpService.getUserPhoneType()]
                BaseHttpService.sendRequestAccess(GetUserCity, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                    //self.usreArr[3] = "\(two)-\(three)"
                   
                    self.city = "\(two)-\(three)"
                    self.tableView.reloadData()
                }
            })
            break
        default:
            break
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //获取用户信息

        self.navigationController?.isNavigationBarHidden=false

        BaseHttpService .sendRequestAccess(GetUser, parameters:["userPhone":BaseHttpService.getUserPhoneType()]) { (response) -> () in
            print("获取用户信息=\(response)")
            app.user = UserModel(dict: response as! [String:AnyObject])
            print(app.user?.userName)
             self.tableView.reloadData()

        }

       
    }
    //闭包函数
    func somsomeFunctionThatTakesAClosure(_ string:String) -> Void{
        print(string)
        cellArr[cellI].information?.text = string
    }

    //选择照片男女
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if actionSheet.tag == 310{
            if buttonIndex==1{
                self.LoaclPhoto()
            }else if buttonIndex==2{
                self.takePhoto()
            }
        }else if actionSheet.tag == 320{
            if buttonIndex==0{
                cellArr[2].information.text = NSLocalizedString("男", comment: "")
                let parameters=["userSex":"男","userPhone":BaseHttpService.getUserPhoneType()]
                BaseHttpService.sendRequestAccess(GetUserSex, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                    self.sex = NSLocalizedString("男", comment: "")
                    self.tableView.reloadData()
                }
                
            }else if buttonIndex==1{
                cellArr[2].information.text = NSLocalizedString("女", comment: "")
                let parameters=["userSex":"女","userPhone":BaseHttpService.getUserPhoneType()]
                BaseHttpService.sendRequestAccess(GetUserSex, parameters:parameters as NSDictionary) { (response) -> () in
                    print(response)
                    self.sex = NSLocalizedString("女", comment: "")
                    self.tableView.reloadData()
                }
            }
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true) {
            self.curentImage = info["UIImagePickerControllerEditedImage"] as? UIImage;
            dump(self.curentImage)
            self.tableView.reloadData()
            self.saveImage(self.curentImage!, imageName: "1236")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, info: [String : AnyObject]?) {
        
        self.dismiss(animated: true) {
            self.curentImage = image;
            dump(image)
            self.tableView.reloadData()
            self.saveImage(image, imageName: "1236")
        }
        
        //dismissViewControllerAnimated:YES completion:nil
    }
    func saveImage(_ currentImage:UIImage,imageName:NSString){
        let imageData:Data = UIImageJPEGRepresentation(currentImage, 0.5)!
        print(imageData)
        BaseHttpService.saveImageAccess(GetUserFileupload, data: imageData) { (back) -> () in
            
        }
        
        //开始上传操作
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
