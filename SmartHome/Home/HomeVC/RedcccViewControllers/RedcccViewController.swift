//
//  RedcccViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/6/16.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RedcccViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    var arr = ["新红外1","新红外2","新红外3","背景音乐4","变色灯模块5"]
    var equip:Equip?
    var isMoni = false
    let table = UITableView()
    var cellArr = [UITableViewCell]()
    var indexqj:IndexPath?
    //var AppArr = (UIApplication.sharedApplication().delegate as! AppDelegate).infArr
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.navigationItem.title = NSLocalizedString("模块调整", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("添加模块", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(RedcccViewController.selectRightAction(_:)))
        //请求服务器该模板信息 1 abc 2 dict【“键值”：“名字” ，。。。】
        self.table.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(self.table)
        // Do any additional setup after loading the view.
       
//        self.table.registerClass(First1TableViewCell.classForCoder(), forCellReuseIdentifier: "First1TableViewCell")
//        self.table.registerClass(Second1TableViewCell.classForCoder(), forCellReuseIdentifier: "Second1TableViewCell")
//        self.table.registerClass(Third1TableViewCell.classForCoder(), forCellReuseIdentifier: "Third1TableViewCell")
        self.table.frame.size.height=self.table.frame.size.height-64
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
        
        //右划
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(RedcccViewController.handleSwipeGesture(_:)))
        self.table.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(RedcccViewController.handleSwipeGesture(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left //不设置是右
        self.table.addGestureRecognizer(swipeLeftGesture)
//        //绑定对长按的响应
//        let longPress=UILongPressGestureRecognizer(target:self,action:Selector("tableviewCellLongPressed:"))
//        //代理
//        longPress.delegate = self
//        longPress.minimumPressDuration = 1.0
//        //将长按手势添加到需要实现长按操作的视图里
//        self.table.addGestureRecognizer(longPress)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWill+\(app.infArr)")
        //self.AppArr = app.infArr
        self.table.reloadData()
    }
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer){
        //划动的方向
        let direction = sender.direction
        switch (direction){
        case UISwipeGestureRecognizerDirection.right:
            print("Right")
            self.table.setEditing(true, animated:true)
            //print(self.AppArr)
            break
        case UISwipeGestureRecognizerDirection.left:
            print("Left")
            self.table.setEditing(false, animated:true)
           // (UIApplication.sharedApplication().delegate as! AppDelegate).infArr = self.AppArr
            
            var modelstr = ""
            for var str in app.infArr
            {
                modelstr = modelstr + str + ","
            }
            
           //modelstr = (modelstr as NSString).substringWithRange(NSMakeRange(0,modelstr.characters.count-1))
            let dic = ["deviceAddress":self.equip!.equipID,"classesInfo":modelstr, "deviceCode":self.equip!.hostDeviceCode]
            BaseHttpService.sendRequestAccess(adjustInfraredLocation, parameters: dic as NSDictionary, success: { (data) -> () in
                
            })
            print(modelstr)
            break
        default :
            break
        }
    }

    @objc func selectRightAction(_ butt:UIButton)->Void{
        let VC = RedccViewController()
        VC.equip = self.equip
        VC.hidesBottomBarWhenPushed=true
        VC.isMoni = self.isMoni
        VC.indexqj = self.indexqj
        self.navigationController?.pushViewController(VC, animated: true)
    }

//    //长按表格
//    func tableviewCellLongPressed(gestureRecognizer:UILongPressGestureRecognizer)
//    {
//        if (gestureRecognizer.state == UIGestureRecognizerState.Ended)
//        {
//            print("UIGestureRecognizerStateEnded");
//            //在正常状态和编辑状态之间切换
//            if(self.table.editing == false){
//                self.table.setEditing(true, animated:true)
//            }
//            else{
//                self.table.setEditing(false, animated:true)
//            }
//        }
//    }



    //在编辑状态，可以拖动设置cell位置
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //移动cell事件
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath,
        to toIndexPath: IndexPath) {
            if fromIndexPath != toIndexPath{
                //获取移动行对应的值
                let itemValue:String = app.infArr[fromIndexPath.row]
                //删除移动的值
                app.infArr.remove(at: fromIndexPath.row)
                //如果移动区域大于现有行数，直接在最后添加移动的值
                if toIndexPath.row > app.infArr.count{
                    app.infArr.append(itemValue)
                }else{
                    //没有超过最大行数，则在目标位置添加刚才删除的值
                    app.infArr.insert(itemValue, at:toIndexPath.row)
                }
            }
    }
    //删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let dic = ["deviceAddress":self.equip!.equipID,"classesInfo":app.infArr[indexPath.row],"deviceCode":self.equip!.hostDeviceCode]
        BaseHttpService.sendRequestAccess(deleteButton, parameters: dic as NSDictionary) { (data) -> () in
            app.infArr.remove(at: indexPath.row)
            print(app.infArr)
            self.table.reloadData()
            print("删除")
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.infArr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
//        cell = tableView.dequeueReusableCellWithIdentifier("First1TableViewCell"+String(indexPath.row))
//        if cell == nil{
        cell = First1TableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "First1TableViewCell"+String(indexPath.row))
            let str = (app.infArr[indexPath.row] as NSString).substring(with: NSMakeRange(0, 1))
            switch str{
            case "A":
                (cell as! First1TableViewCell).setimg(UIImage(named: arr[0])!)
                (cell as! First1TableViewCell).setinit()
                break
            case "B":
                (cell as! First1TableViewCell).setimg(UIImage(named: arr[1])!)
                (cell as! First1TableViewCell).setinit()
                break
            case "C":
                (cell as! First1TableViewCell).setimg(UIImage(named: arr[2])!)
                (cell as! First1TableViewCell).setinit()
                break
            case "D":
                (cell as! First1TableViewCell).setimg(UIImage(named: arr[3])!)
                (cell as! First1TableViewCell).setinit()
                break
            case "E":
                (cell as! First1TableViewCell).setimg(UIImage(named: arr[4])!)
                (cell as! First1TableViewCell).setinit()
                break
            default :
                break
            }
  
            (cell as! First1TableViewCell).but.isHidden = true
//        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         print(UIScreen.main.bounds.size.height/5)
        return UIScreen.main.bounds.size.height/5
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        switch indexPath.row {
        case 0:
            break
        case 1:
            
            break
        case 2:
            
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
