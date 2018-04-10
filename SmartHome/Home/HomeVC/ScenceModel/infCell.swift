//
//  infCell.swift
//  SmartHome
//
//  Created by Komlin on 16/4/18.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

protocol pusView:NSObjectProtocol{

    func pus(_ id:Int)
}

class infCell: UICollectionViewCell ,UIActionSheetDelegate,UIAlertViewDelegate {

    //代理
    weak var delegate:pusView?

    //设备属性类
    var inf:Infrared?
    //判断添加还是开关
    var JudgeI:Int?
    //var model:<type>?
    //---------------
    //声明一个闭包
    var myClosure:callbackfunc?
    //块
    typealias callbackfunc = (Int)->()

    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func completeBlock(_ chName:callbackfunc)->Void{
        
    }
    //--------------------
    //修改
    typealias xiu = (Int,String)->()
    var xiugai:xiu?
    func revisions(_ name:xiu)->Void{
    }
    //--------------
    var longPressGR:UILongPressGestureRecognizer?
    @IBOutlet weak var but: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        but.addTarget(self,action:#selector(infCell.tapped(_:)),for:.touchUpInside)
     
        // Initialization code
    }
    func addLongPass()
    {
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(infCell.longPress(_:)))
        
        longPressGR!.minimumPressDuration = 0.5;
        self.addGestureRecognizer(longPressGR!)
        
    }
    
    //func setModel--- change view
    func setinf(_ inf:Infrared){
        self.inf = inf
        self.but.setTitle(inf.name, for: UIControlState())
        self.but.setTitleColor(UIColor.black, for: UIControlState())
        self.but.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        
    }
   
    //单击
    @objc func tapped(_ button:UIButton){
        print("aacc")
        if self.JudgeI == 1{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "a"), object: nil)
        }else{
            self.delegate?.pus(self.tag)
        }
       
    }

    //按钮长按事件
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
             if sender.state == UIGestureRecognizerState.began{
        
        print("bbcc")
        // NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timer:"), userInfo: nil, repeats: false)
        
        let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("删除", comment: ""), NSLocalizedString("修改", comment: ""))
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
            print(self.tag)
            self.myClosure?(self.tag)
            //删除
            break
        case 2:
            let alert = UIAlertView(title:NSLocalizedString("提示", comment: ""),message:"请输入名字",delegate:self,cancelButtonTitle:NSLocalizedString("确定", comment: ""),otherButtonTitles:NSLocalizedString("取消", comment: ""))
            alert.alertViewStyle = UIAlertViewStyle.plainTextInput
            
            alert.show()
            //修改
            break
        default:
            break
        }
       
    }
    //修改
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        //self.but.setTitle(alertView.textFieldAtIndex(0)!.text, forState: UIControlState.Normal)
        if buttonIndex == 0{
            inf?.name = alertView.textField(at: 0)!.text!
            self.xiugai?(self.tag,(inf?.name)!)
        }
        
    }
    //键盘消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
