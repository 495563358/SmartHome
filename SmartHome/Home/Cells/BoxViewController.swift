//
//  BoxViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/8/16.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class BoxViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate {

    var collectionView:UICollectionView?
    var cDataSource = [boxx]()
    var indexqj:IndexPath?
    var isMoni:Bool = false
    var equip:Equip?
   // var sender:UILongPressGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = "控制盒"
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ScreenWidth / 3 - 1, height: ScreenWidth / 3 - 1)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-60), collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
        self.collectionView!.register(UINib(nibName: "BoxCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "boxCollectionViewCell")
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellReuse")

        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.view.addSubview(self.collectionView!)
        
//       self.collectionView!.addLegendHeader { [unowned self]() -> Void in
//
//            print("刷新界面")
//            self.setData()
//      }
        
        // Do any additional setup after loading the view.
    }
    func setData(){
        BaseHttpService.sendRequestAccess(dropDownControlEnclosureRelayStatus, parameters: ["deviceAddress":self.equip!.equipID]) { (arr) -> () in
            print(arr)
            var box:boxx?
            self.cDataSource = []
            
            for var i in 0...arr.count-1
            {
                box = boxx()
                let dict:NSDictionary = ((arr as! NSArray)[i] as! NSDictionary)
                box!.setvale(name: dict["nickName"] as! String, stat: dict["state"] as! String, id: dict["deviceAddress"] as! String,deviceCode: self.equip!.hostDeviceCode)
                self.cDataSource.append(box!)
            }
            self.collectionView?.reloadData()
            self.collectionView!.mj_header.endRefreshing()
        }
    }
    // MARK: - UICollectionView data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cDataSource.count < 15 {
            return 15
        }
        let temp = cDataSource.count % 3
        return cDataSource.count + (3-temp)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= cDataSource.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellReuse", for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boxCollectionViewCell", for: indexPath) as! BoxCollectionViewCell
        cell.name.text = self.cDataSource[indexPath.row].name
        cell.box = self.cDataSource[indexPath.row]
        cell.isMoni = self.isMoni
        cell.state.isOn = self.cDataSource[indexPath.row].state == "1" ? true:false
        cell.state.addTarget(self, action: #selector(BoxViewController.switchDidChange(_:)), for:  UIControlEvents.valueChanged )
        cell.state.tag = indexPath.row
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(BoxViewController.longPress(_:)))
        longPressGR.minimumPressDuration = 0.5;
        if BaseHttpService.GetAccountOperationType() == "2"{
            
            
        }else{
            cell.addGestureRecognizer(longPressGR)
        }
        
        longPressGR.view?.tag = indexPath.row
        
        return cell
    }
    //按钮长按事件
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        if  sender.state == UIGestureRecognizerState.began{
            if sender.view?.tag < cDataSource.count {
                let actionsheet = UIActionSheet()
                actionsheet.addButton(withTitle: NSLocalizedString("修改名称", comment: ""))
                actionsheet.cancelButtonIndex=0
                actionsheet.delegate = self
                actionsheet.show(in: self.view);
                actionsheet.tag = sender.view!.tag
            }
            
        }
        
    }
    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        
        let alert = UIAlertView(title: NSLocalizedString("修改名称", comment: ""), message: "", delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), otherButtonTitles: NSLocalizedString("确定", comment: ""))
        alert.tag = actionSheet.tag
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.show()
    }
    
    func alertView(_ alertView:UIAlertView, clickedButtonAt buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
           
        }
        else
        {
             print("ok")
            print(alertView.textField(at: 0)?.text)
            BaseHttpService.sendRequestAccess(updateControlEnclosureName, parameters: ["deviceCode":self.cDataSource[alertView.tag].deviceCode,"deviceAddress":self.cDataSource[alertView.tag].id,"nickName":alertView.textField(at: 0)!.text!], success: { (arr) -> () in
                self.cDataSource[alertView.tag].name = alertView.textField(at: 0)!.text!
                self.collectionView?.reloadData()
            })
        }
    }
    
    @objc func switchDidChange(_ state:UISwitch)->Void{
        print(state.isOn)
        if isMoni{
//            self.equip?.status = cDataSource[state.tag].id+","+cDataSource[state.tag].name+","+"\(state.on)"
//            print(cDataSource[state.tag].id+","+cDataSource[state.tag].name+","+"\(state.on)")
//            app.modelEquipArr.replaceObjectAtIndex((indexqj?.row)!, withObject: self.equip!)
//            self.navigationController?.popViewControllerAnimated(true)
            self.cDataSource[state.tag].state = state.isOn ? "1":"0"
        }
        else
        {
            
            if state.isOn{
                print(["deviceCode":self.cDataSource[state.tag].deviceCode,"deviceAddress":cDataSource[state.tag].id,"controlAction":"1"])
                BaseHttpService.sendRequestAccess(control_ControlEnclosure, parameters: ["deviceCode":self.cDataSource[state.tag].deviceCode,"deviceAddress":cDataSource[state.tag].id,"controlAction":"1"]) { (arr) -> () in
                    
                }
            }else{
                print(["deviceCode":self.cDataSource[state.tag].deviceCode,"deviceAddress":cDataSource[state.tag].id,"controlAction":"0"])
                BaseHttpService.sendRequestAccess(control_ControlEnclosure, parameters: ["deviceCode":self.cDataSource[state.tag].deviceCode,"deviceAddress":cDataSource[state.tag].id,"controlAction":"0"]) { (arr) -> () in
                    
                }
            }

        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cDataSource.count > indexPath.row{
            if isMoni{
                self.equip?.status = cDataSource[indexPath.row].id+","+cDataSource[indexPath.row].name+","+cDataSource[indexPath.row].state
                print(cDataSource[indexPath.row].id+","+cDataSource[indexPath.row].name+","+cDataSource[indexPath.row].state)
                      app.modelEquipArr[(indexqj?.row)!] = self.equip!
               // app.modelEquipArr.replaceObjectAtIndex(, withObject: self.equip!)
                self.navigationController?.popViewController(animated: true)
            }
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
