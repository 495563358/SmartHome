//
//  RecTelevisionViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/6/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
class RecTelevisionViewController: UIViewController,UIActionSheetDelegate {
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var select_tag = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "电视机"
        
        //
     let scalew = width / 320
      let scaleh = height / 568
        
        let UpView = UIView()
        UpView.frame = CGRect(x: 0, y: 0, width: width*scalew, height: height/2*scaleh)
        UpView.backgroundColor = UIColor(patternImage: navBgImage!)
        let openBut = UIButton(frame:CGRect(x: 10*scalew, y: 5*scaleh, width: 50*scalew, height: 50*scaleh))
        let closBut = UIButton(frame:CGRect(x: (UpView.frame.size.width - 10 - openBut.frame.size.width)*scalew, y: 5*scaleh, width: openBut.frame.size.width, height: openBut.frame.size.height))
        
       // openBut.setImage(UIImage(named: "开电视"), forState: UIControlState.Normal)
        //closBut.setImage(UIImage(named: "关电视"), forState: UIControlState.Normal)
        openBut.setBackgroundImage(UIImage(named: "开电视"), for: UIControlState())
        openBut.setBackgroundImage(UIImage(named: "关电视"), for: UIControlState())
        
        
        UpView.addSubview(openBut)
        UpView.addSubview(closBut)
        self.view.addSubview(UpView)
    }

    func addLongPress(_ btn:UIButton){
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(RecTelevisionViewController.longPress(_:)))
        
        longPressGR.minimumPressDuration = 0.5;
        btn.addGestureRecognizer(longPressGR)
    }
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
        
        print(sender.view?.tag)
        select_tag = (sender.view?.tag)!
        
        let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("学习", comment: ""))
          actionSheet?.show(in: self.view)
        }
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //取消
            break
        case 1:
           //XUEXI
            break
    
        default:
            break
        }
        
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
