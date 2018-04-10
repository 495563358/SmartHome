//
//  TabbarC.swift
//  SmartHome
//
//  Created by sunzl on 16/5/10.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class TabbarC: UITabBarController {
    lazy var btn:UIButton = {
        let _btn = UIButton(frame: CGRect(x: ScreenWidth/2-40, y: 0 ,width: 80,height: 48))
        _btn.setImage(voiceIconSelected, for: UIControlState())
        
        //        _btn.imageEdgeInsets = UIEdgeInsetsMake(5,10,5,10)
        
        _btn.imageView?.frame = CGRect(x: ScreenWidth/2-19, y: 5 ,width: 38,height: 38)
        _btn.backgroundColor = UIColor.white
        _btn.imageView?.layer.cornerRadius = 19
        _btn.imageView?.layer.masksToBounds = true
        _btn.imageView?.layer.borderWidth = 1.0
        
        _btn.imageView?.layer.borderColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).cgColor
        
        return _btn;
        
    }()
    lazy var yytool = YYTool.share()
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.tabBar.isOpaque = true;
        self.configBtn()
        //        self.tabBar.backgroundImage = imageWithColor(UIColor.clearColor())
        //        self.tabBar.shadowImage = imageWithColor(UIColor.clearColor())
        
        self.tabBar.backgroundImage = imageWithColor(color: UIColor.white)
        self.view.backgroundColor = UIColor.white
        //self.tabBar.selectedImageTintColor = UIColor.whiteColor()
        
        
        let homevc:HomeVC=HomeVC(nibName: "HomeVC", bundle: nil)
        homevc.tabBarItem.title = NSLocalizedString("家", comment: "")
        homevc.tabBarItem.image = homeIcon
        homevc.tabBarItem.selectedImage = homeIconSelected
    homevc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.gray,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.normal)
    homevc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:systemColor,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.selected)
        
        let homeNav:UINavigationController = UINavigationController(rootViewController: homevc)
        
        
        let setModelVC:BusinessAreaVC = BusinessAreaVC()
        setModelVC.tabBarItem.title=NSLocalizedString("商圈", comment: "")
        setModelVC.tabBarItem.image=modelIcon
        setModelVC.tabBarItem.selectedImage=modelIconSelected
    setModelVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.gray,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.normal)
    setModelVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:systemColor,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.selected)
        let setModelNav:UINavigationController = UINavigationController(rootViewController: setModelVC)
        
        
        let blankVC:MallViewController=MallViewController()
        
        let blankNav:UINavigationController = UINavigationController(rootViewController: blankVC)
        
        //       let mallvc:MallViewController=MallViewController()
        //        mallvc.strUrl = "http://mall.znhome.co"
        //        mallvc.strNavTitle = NSLocalizedString("商城", comment: "")
        //        //let mallvc:MallVC=MallVC(nibName: "MallVC", bundle: nil)
        //        mallvc.tabBarItem.title=NSLocalizedString("商城", comment: "")
        //        mallvc.tabBarItem.image=mallIcon
        //        mallvc.tabBarItem.selectedImage=mallIconSelected
        //        let mallNav:UINavigationController = UINavigationController(rootViewController:mallvc)
        
        let mallvc:MallVCViewController = MallVCViewController()
        mallvc.tabBarItem.title=NSLocalizedString("商城", comment: "")
        mallvc.tabBarItem.image=mallIcon
        mallvc.tabBarItem.selectedImage=mallIconSelected
    mallvc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.gray,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.normal)
    mallvc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:systemColor,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.selected)
        let mallNav:UINavigationController = UINavigationController(rootViewController:mallvc)
        
        let commvc:CommunityVC=CommunityVC()
        commvc.tabBarItem.title=NSLocalizedString("社区", comment: "")
        commvc.tabBarItem.image=commIcon
        commvc.tabBarItem.selectedImage=commIconSelected
    commvc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.gray,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.normal)
    commvc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:systemColor,NSAttributedStringKey.font:UIFont(name: "Chalkduster", size: 12)!], for: UIControlState.selected)
        let commNav:UINavigationController = UINavigationController(rootViewController: commvc)
        
        self.viewControllers=[homeNav,setModelNav,blankNav,mallNav,commNav];
        
        self.tabBar.bringSubview(toFront: self.btn)
        self.tabBar.tintColor=mainColor
        
        // Do any additional setup after loading the view.
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let index = tabBar.items?.index(of: item)
        //        print(index)
        if(index == 2){
            self.navigationController?.tabBarController?.selectedIndex = 0
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configBtn()
    {
        
        self.tabBar.addSubview(self.btn)
        
        self.btn.addTarget(self, action: #selector(TabbarC.tap), for:UIControlEvents.touchUpInside)
        
    }
    @objc func tap()
    {
//        yytool?.parentView = UIWindow.visibleViewController().view
//        yytool?.yyfuwu()
        let tool = HBYYTool()
        self.present(tool, animated: true, completion: nil)
        
        
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
