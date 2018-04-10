//
//  CommunityVC.swift
//  SmartHome
//
//  Created by Smart house on 2017/12/27.
//  Copyright © 2017年 sunzl. All rights reserved.
//

import UIKit

class CommunityVC: UIViewController {
    
    var centerTitle:UIButton!
    let percent = ScreenWidth/375
    var hh:CGFloat = 0
    
    var btn1:UIButton!
    var btn2:UIButton!
    var btn3:UIButton!
    var btn4:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "shequ_dianhua"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CommunityVC.telephone(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "shequ_qiandao"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CommunityVC.signin(_:)))
        
        centerTitle = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height: 44))
        centerTitle.set(image: UIImage(named: "zhankai-bai"), title: "智能社区", titlePosition: .left, additionalSpacing: 5, state:UIControlState())
        centerTitle.addTarget(self, action: #selector(CommunityVC.commClick(_:)), for: .touchUpInside)
        navigationItem.titleView = centerTitle
        
        setupView()
    }
    
    func setupView(){
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 154*percent))
        imageV.image = UIImage(named: "shequ_banner")
        
        hh += imageV.frame.height
        
        let back1 = UIView(frame: CGRect(x: 0,y: hh,width: ScreenWidth,height: 104*percent))
        back1.backgroundColor = UIColor.white
        let btnW:CGFloat = 50.0
        let spaceX = (ScreenWidth - 50*percent - 4*50)/3 + btnW
        
        
        btn1 = UIButton(frame: CGRect(x: 25*percent,y: 5*percent,width: btnW,height: 74*percent))
        btn1.setTitleColor(UIColor.black, for: UIControlState())
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn1.set(image: UIImage(named: "menjing"), title: "门禁", titlePosition: .bottom, additionalSpacing: 9, state: UIControlState())
        
        btn2 = UIButton(frame: CGRect(x: 25*percent+spaceX,y: 5*percent,width: btnW,height: 74*percent))
        btn2.setTitleColor(UIColor.black, for: UIControlState())
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn2.set(image: UIImage(named: "tingche"), title: "停车", titlePosition: .bottom, additionalSpacing: 9, state: UIControlState())
        
        btn3 = UIButton(frame: CGRect(x: 25*percent+2*spaceX,y: 5*percent,width: btnW,height: 74*percent))
        btn3.setTitleColor(UIColor.black, for: UIControlState())
        btn3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn3.set(image: UIImage(named: "wuye"), title: "物业", titlePosition: .bottom, additionalSpacing: 9, state: UIControlState())
        
        btn4 = UIButton(frame: CGRect(x: 25*percent+3*spaceX,y: 5*percent,width: btnW,height: 74*percent))
        btn4.setTitleColor(UIColor.black, for: UIControlState())
        btn4.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn4.set(image: UIImage(named: "zulin"), title: "租赁", titlePosition: .bottom, additionalSpacing: 9, state: UIControlState())
        
        
        hh += back1.frame.height + 10
        
        //常用工具
        let usualTool = UIButton(frame: CGRect(x: 0,y: hh,width: ScreenWidth,height: 39))
        usualTool.backgroundColor = UIColor.white
        let lab1 = UILabel(frame: CGRect(x: 10,y: 0,width: 100,height: 39))
        lab1.text = "常用工具"
        lab1.font = UIFont.systemFont(ofSize: 15)
        let img1 = UIImageView(frame: CGRect(x: ScreenWidth - 17,y: 13,width: 7,height: 13))
        img1.image = UIImage(named: "gengduo")
        
        hh += usualTool.frame.height + 1
        
        
        let back2 = UIView(frame: CGRect(x: 0,y: hh,width: ScreenWidth,height: 150*percent))
        back2.backgroundColor = UIColor.white
        
        let names:[String] = ["小区开门","账单缴费","通知公告","房屋出租","送水","快递","报修","酒店"]
        var btag = 0
        for var i in 0...1{
            for var j in 0...3{
                let btn = UIButton(frame: CGRect(x: 15*percent+spaceX * (CGFloat)(Float(j)),y: 0*percent + (CGFloat)(Float(i)) * 75*percent,width: btnW+20*percent,height: 65*percent))
                
                btn.setTitleColor(UIColor.black, for: UIControlState())
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.set(image: UIImage(named: names[btag]), title: names[btag], titlePosition: .bottom, additionalSpacing: 5, state: UIControlState())
                btn.addTarget(self, action: #selector(CommunityVC.usuToolTouched(_:)), for: .touchUpInside)
                back2.addSubview(btn)
                btag += 1
                btn.tag = btag
            }
        }
        
        self.view.addSubview(imageV)
        self.view.addSubview(back1)
        self.view.addSubview(usualTool)
        self.view.addSubview(back2)
        
        back1.addSubview(btn1)
        back1.addSubview(btn2)
        back1.addSubview(btn3)
        back1.addSubview(btn4)
        usualTool.addSubview(lab1)
        usualTool.addSubview(img1)
    }
    //常用工具
    @objc func usuToolTouched(_ sender:UIButton){
        showMsg(msg: "暂未开放")
        switch sender.tag{
        case 0:
            break
        default:
            break
        }
    }
    
    //小区
    @objc func commClick(_ sender:UIButton){
        
    }
    //电话
    @objc func telephone(_ barbutton:UIBarButtonItem){
        
    }
    //签到
    @objc func signin(_ barbutton:UIBarButtonItem){
        
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
