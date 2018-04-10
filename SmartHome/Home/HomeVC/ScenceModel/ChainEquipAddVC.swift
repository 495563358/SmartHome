//
//  EquipAddVC.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ChainEquipAddVC: UIViewController, UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {
    var model: ChainModel? = ChainModel()
    var equipIndex :IndexPath?
    var NameText:String?//导航栏名
    
    var tableview:UITableView = UITableView.init(frame: UIScreen.main.bounds, style: .grouped)
    
    let imgArr:[String] = ["huijia","anfang", "guandeng", "huike", "jiucan","kaideng", "lijia", "qichuang", "qiye", "shangban", "shuijiao", "xiaban", "yingyuan", "yinyue", "youxi"]
    let nameArr:[String] = ["回家","安防","熄灯","会客","就餐","开灯","离家","起床","夜间","上班","安睡","下班","影院","音乐","游戏"]
    
    var arr = [String]()
    fileprivate var compeletBlock: ((Equip,IndexPath)->())?
    
    func configCompeletBlock(_ compeletBlock: @escaping (_ equip: Equip,_ indexPath:IndexPath)->()) {
        self.compeletBlock = compeletBlock
    }
    
    
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = NameText
  
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.sectionFooterHeight = 10
        self.tableview.sectionHeaderHeight = 0.1
        self.view.addSubview(self.tableview)
        
        self.tableview.register(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        self.tableview.register(UINib(nibName: "EquipConfigCell", bundle: nil), forCellReuseIdentifier: "equipconfigcell")
        self.tableview.register(UINib(nibName: "EquipImageCell", bundle: nil), forCellReuseIdentifier: "equipimagecell")
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChainEquipAddVC.handleTap(_:)))
        tap.delegate = self
        self.tableview.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChainEquipAddVC.handleBack(_:)))
        
        let nextStep = UIButton.init(frame: CGRect(x: ScreenWidth/4, y: 50, width: ScreenWidth/2, height: 45))
        nextStep.backgroundColor = systemColor
        nextStep.layer.cornerRadius = 10
        nextStep.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStep.setTitle("保存", for: UIControlState())
        nextStep.addTarget(self, action: #selector(ChainEquipAddVC.handleRightItem(_:)), for: UIControlEvents.touchUpInside)
        
        let footerView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWidth,height:100))
        footerView.addSubview(nextStep)
        self.tableview.tableFooterView = footerView
        self.tableview.tableHeaderView = UIView(frame:CGRect(x:0,y:0,width:ScreenWidth,height:0.01))
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        self.tableview.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    //获取随机六位数ID
    func randomNumAndLetter()->String
    {
        let kNumber = 6;
        let sourceStr:NSString="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var resultStr = ""
        
        for   _ in  0..<kNumber
        {
            let index = arc4random()%(UInt32)(sourceStr.length);
            let oneStr = sourceStr.substring(with: NSMakeRange(Int(index), 1))
            resultStr += oneStr
        }
        return resultStr
    }
    @objc func handleRightItem(_ barButton: UIBarButtonItem) {
        self.view.endEditing(true)
        //保存 编辑
        if self.model?.modelId == ""{
           self.model?.modelId = self.randomNumAndLetter()
        }
        if self.model!.modelIcon == ""{
            self.model!.modelIcon = "huijia.png"
        }
        if self.model?.modelName == ""{
            showMsg(msg: NSLocalizedString("名称不能为空", comment: ""))
            return
        }
        let parameters = ["modelId":self.model!.modelId
            ,"modelName":self.model!.modelName
            ,"ico":self.model!.modelIcon]
        print("\(parameters)")
        BaseHttpService.sendRequestAccess(Add_addmodel, parameters: parameters as NSDictionary) { [unowned self](back) -> () in
            print(back)
            self.navigationController?.popViewController(animated: true)
            showMsg(msg: NSLocalizedString("保存成功了!", comment: ""))
        }
        
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipimagecell", for: indexPath) as! EquipImageCell
            if self.model?.modelIcon != ""{
                cell.cellIconImage.image = UIImage(named: (self.model?.modelIcon)!)
                //cell.cellIconImage.contentMode = UIViewContentMode.ScaleAspectFill
            }else{
                cell.cellIconImage.image = UIImage(named:"huijia.png")
                self.model?.modelIcon = "huijia.png"
            }
            cell.cellTitleLabel.text = NSLocalizedString("模式图标", comment: "")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipnamecell", for: indexPath) as! EquipNameCell
            cell.leab.text = NSLocalizedString("模式名称", comment: "")
            if self.model?.modelName != ""{
                cell.equipName.text = self.model?.modelName
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.complete = {[unowned self](name)in
                print(name as Any)
                
                self.model?.modelName = name!
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
            cell.cellTitle.text = NSLocalizedString("模式设置", comment: "")
            cell.cellDetail.text = NSLocalizedString("进入详细设置界面", comment: "")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipconfigcell", for: indexPath) as! EquipConfigCell
            cell.cellTitle.text = NSLocalizedString("时间设置", comment: "")
            cell.cellDetail.text = NSLocalizedString("进入详细设置界面", comment: "")
            return cell
        default:
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reusetableview")
            return cell
        }
        
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.cellForRow(at: indexPath) as! EquipImageCell
            
            let choosIconVC = ChainVC(nibName: "ChainVC", bundle: nil)
            choosIconVC.chooseImageBlock( { [unowned self,unowned cell] (imageName) -> () in
                
                cell.cellIconImage.image = UIImage(named: imageName)
                self.model?.modelIcon = imageName
                
                for var i in 0...self.imgArr.count-1{
                    if self.imgArr[i] == imageName{
                        self.model?.modelName = self.nameArr[i]
                        print(self.model?.modelName)
                        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)] ,with: UITableViewRowAnimation.fade)
                        break
                    }
                    i += 1
                }
                
                })
            self.navigationController?.pushViewController(choosIconVC, animated: true)

            break
        case 3:
            self.view.endEditing(true)
            let createVc = CreateModelVC(nibName: "CreateModelVC", bundle: nil)
            
            if self.model?.modelId == ""{
                self.model?.modelId = self.randomNumAndLetter()
            }
            if self.model!.modelIcon == ""{
                self.model!.modelIcon = "huijia.png"
            }
            if self.model?.modelName == ""{
                showMsg(msg: NSLocalizedString("名称不能为空", comment: ""))
                return
            }
            createVc.modelId = (self.model?.modelId)!
            createVc.navTitle = "情景模式设置"
            let parameters = ["modelId":self.model!.modelId
                ,"modelName":self.model!.modelName
                ,"ico":self.model!.modelIcon]
            print("\(parameters)")
            BaseHttpService.sendRequestAccess(Add_addmodel, parameters: parameters as NSDictionary) { [unowned self](back) -> () in
                print(back)
                self.navigationController?.pushViewController(createVc, animated: true)
            }
          
            break
        case 2:
            self.view.endEditing(true)
            if self.model?.modelId == ""{
                self.model?.modelId = self.randomNumAndLetter()
            }
            if self.model!.modelIcon == ""{
                self.model!.modelIcon = "huijia.png"
            }
            if self.model?.modelName == ""{
                showMsg(msg: NSLocalizedString("名称不能为空", comment: ""))
                return
            }
            let parameters = ["modelId":self.model!.modelId
                ,"modelName":self.model!.modelName
                ,"ico":self.model!.modelIcon]
            print("\(parameters)")
            BaseHttpService.sendRequestAccess(Add_addmodel, parameters: parameters as NSDictionary) { [unowned self](back) -> () in
                print(back)
                let tierVC = CreateTimerViewController()
                tierVC.modelId = (self.model?.modelId)!
                self.navigationController?.pushViewController(tierVC, animated: true)
            }
            
            break
        default:
            break
        }
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
