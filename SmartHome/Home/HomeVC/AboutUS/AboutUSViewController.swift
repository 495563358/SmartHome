//
//  AboutUSViewController.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/20.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class AboutUSViewController: UITableViewController,UIGestureRecognizerDelegate,UIAlertViewDelegate {
    
    
    
    let APP_UPLOAD:String = "http://itunes.apple.com/lookup?id=1216518997"
    let APP_URL = "itms-apps://itunes.apple.com/app/id1216518997"
    
    let scalew = ScreenWidth/375
    let scaleh = ScreenHeight/667
    
    let nameArr = ["提交评分","提交反馈","检查更新","清理缓存","分享APP"]
    let imageArr = ["pingfen","jianyifankui","gengxin","qingchuhuanc","fenxiangapp"]
    
    var currentVersion:String = ""
    var itunesVersion:String = ""
    
    var label:UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "关于我们"
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AboutUSViewController.backClick))
        let swipeGes = UISwipeGestureRecognizer.init(target: self, action: #selector(AboutUSViewController.backClick))
        swipeGes.direction = .right
        
        setupView()
    }
    
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        
        let localDic = Bundle.main.infoDictionary
        currentVersion = localDic!["CFBundleShortVersionString"] as! String
        
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 242*scaleh))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        
        let logoImg = UIImageView.init(frame: CGRect(x: (ScreenWidth - 128*scalew)/2, y: 40*scaleh, width: 128*scalew, height: 128*scalew))
        logoImg.image = UIImage(named: "登录log")
        headerView.addSubview(logoImg)
        
        let versionLab = UILabel.init(frame: CGRect(x: (ScreenWidth - 128)/2, y: logoImg.frame.origin.y + 130*scalew, width: 128, height: 30))
        versionLab.font = UIFont.systemFont(ofSize: 17)
        versionLab.textAlignment = .center
        versionLab.text = "v" + currentVersion
        headerView.addSubview(versionLab)
        
        self.tableView.tableHeaderView = headerView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        Alamofire.request(APP_UPLOAD,method:.post).responseJSON { (responseResult) -> Void in
            print("res = \(responseResult.result)")
            
            if responseResult.result.isFailure{
                return
            }
            
            let result = responseResult.result.value as! NSDictionary
            if result["resultCount"] as! Int  == 1{
                    print(((result["results"] as! NSArray).firstObject as! NSDictionary)["version"])
                    self.itunesVersion = ((result["results"] as! NSArray).firstObject as! NSDictionary)["version"] as! String
                    self.tableView.reloadData()
                }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if (cell == nil){
            
            cell = SideOtherCell.init(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        
        (cell as! SideOtherCell).imageV.image = UIImage(named: imageArr[indexPath.row])
        (cell as! SideOtherCell).titleLab.text = nameArr[indexPath.row]
        
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        
        if indexPath.row == 2{
            label.removeFromSuperview()
            label = UILabel.init(frame: CGRect(x: ScreenWidth - 200, y: 10, width: 185, height: 30))
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.gray
            label.textAlignment = .right
            if itunesVersion == currentVersion || itunesVersion == ""{
                label.text = "已是最新版本"
            }else{
                label.text = "点击去App Store更新"
            }
            print(label.text)
            cell?.contentView.addSubview(label)
            return cell!
        }else{
            cell?.accessoryType = .disclosureIndicator
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
        case 0:
            
            var score_url = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1216518997"
            let version:NSString = UIDevice.current.systemVersion as NSString
            if version.doubleValue >= 11.0{
                score_url = "itms-apps://itunes.apple.com/zh/app/twitter/id1216518997?mt=8&action=write-review"
            }
            let scoreUrl:URL = URL(string: score_url)!
            if(UIApplication.shared.canOpenURL(scoreUrl)){
                UIApplication.shared.openURL(scoreUrl)
                
            }else{
                showMsg(msg: "无法打开");
            }
            
            break
        case 1:
            
            let feed = MallViewController()
            feed.strNavTitle = "意见反馈"
            feed.strUrl = "http://www.znhome.co/feedback"
            self.navigationController!.pushViewController(feed, animated:true)
            
            break
        case 2:
            if itunesVersion == currentVersion || itunesVersion == ""{
                return
            }
            UIApplication.shared.openURL(URL.init(string: APP_URL)!)
            break
        case 3:
//            let cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//            let num = FileManager().folderSize(atPath: cachPath)
            
            let alert = UIAlertView(title: NSLocalizedString("提示", comment: ""), message: "\(NSLocalizedString("缓存大小为", comment: ""))\(NSLocalizedString("0.00M确定要清理吗?", comment: ""))", delegate: self, cancelButtonTitle: NSLocalizedString("确定", comment: ""), otherButtonTitles: NSLocalizedString("取消", comment: ""))
            alert.show()
            break
        case 4:
            shareApp()
            break
        default:
            break
        }
    
    }
    
    //清除缓存
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0{
            let cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            let files = FileManager.default.subpaths(atPath: cachPath )
            for p in files!{
                
                let path = (cachPath as NSString).appendingPathComponent(p)
                if FileManager.default.fileExists(atPath: path){
                    do{
                        try FileManager.default.removeItem(atPath: path)
                    }catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    func shareApp(){

        UMSocialUIManager.setPreDefinePlatforms([4,5,35,1,2,0])
        UMSocialUIManager.removeAllCustomPlatformWithoutFilted()
        UMSocialShareUIConfig.shareInstance().sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
        UMSocialShareUIConfig.shareInstance().sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .iconAndBGRadius
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) -> Void in
            let VC = UMShareTypeViewController.init(type: platformType)
            VC?.titleName = "智能屋APP 官方应用下载"
            VC?.typeName = "无线智能家居全屋智能化管理 一站式智能设备商圈商城平台 走进智能屋，生活更美好！"
            VC?.imageUrl = "https://is1-ssl.mzstatic.com/image/thumb/Purple128/v4/b0/44/a7/b044a78c-9b92-dccb-351b-f4f2faebe7fd/mzl.pfggmexx.png/690x0w.jpg"
            VC?.shareLink = "http://www.znhome.co/code/code.html"
            VC?.shareWebPage(to: platformType)
        }
    }
    
}


