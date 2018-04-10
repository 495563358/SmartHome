//
//  CameraTypeTVC.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CameraTypeTVC: UITableViewController {

        let dataSource = [NSLocalizedString("智能屋摄像头", comment: ""),NSLocalizedString("萤石摄像头", comment: "")]
        var roomCode:String = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = NSLocalizedString("选择摄像头种类", comment: "")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
              navigationController?.navigationBar.tintColor = UIColor.white
            self.tableView.backgroundColor = UIColor.groupTableViewBackground
            self.tableView.tableFooterView = UIView()
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CameraTypeTVC.handleBack(_:)))
        }
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return (dataSource.count)
        }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
            
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
            }
            cell?.imageView?.image = UIImage(named: "shexiangt")
            cell?.textLabel?.text = dataSource[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
            return cell!
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch(indexPath.row){
            case 0:
                
                let cell = UITableViewCell.init()
                let floorArr = dataDeal.getModels(type: .Floor) as! [Floor]
                var codeArr = [String]()
                var nameArr = [String]()
                for floor in floorArr {
                    let roomArr = dataDeal.getRoomsByFloor(floor: floor)
                    for room in roomArr {
                        codeArr.append(room.roomCode)
                        nameArr.append("\(floor.name)   \(room.name)")
                    }
                }
                
                let chooseAlert = SHChooseAlertView(title:  NSLocalizedString("所属房间:", comment: ""), dataSource: nameArr, cancleButtonTitle: NSLocalizedString("取消", comment: ""), confirmButtonTitle: NSLocalizedString("确定", comment: ""))
                chooseAlert.alertAction({ [unowned cell, unowned self] (alert, buttonIndex) -> () in
                    switch buttonIndex {
                    case 0:
                        break
                    case 1:
                        if codeArr.count == 0{
                            return
                        }
                        self.roomCode = codeArr[alert.selectRow]
                        
                        let vc = Wrapper()
                        vc.push(self, roomCode: self.roomCode)
                    default:
                        break
                    }
                    })
                chooseAlert.show()
                
                break
            default:
//                let cell = UITableViewCell.init()
//                let floorArr = dataDeal.getModels(type: .Floor) as! [Floor]
//                var codeArr = [String]()
//                var nameArr = [String]()
//                for floor in floorArr {
//                    let roomArr = dataDeal.getRoomsByFloor(floor: floor)
//                    for room in roomArr {
//                        codeArr.append(room.roomCode)
//                        nameArr.append("\(floor.name)   \(room.name)")
//                    }
//                }
//                
//                let chooseAlert = SHChooseAlertView(title:  NSLocalizedString("所属房间:", comment: ""), dataSource: nameArr, cancleButtonTitle: NSLocalizedString("取消", comment: ""), confirmButtonTitle: NSLocalizedString("确定", comment: ""))
//                chooseAlert.alertAction({ [unowned cell, unowned self] (alert, buttonIndex) -> () in
//                    switch buttonIndex {
//                    case 0:
//                        break
//                    case 1:
//                        if codeArr.count == 0{
//                            return
//                        }
//                        self.roomCode = codeArr[alert.selectRow]
//                        
//                        BaseHttpService.sendRequestAccess(gaineztoken, parameters: [:], success: {
//                            (any) -> () in
//                            print(any)
//                            let ezToken = any["Eztoken"] as! String
//                            if ezToken=="NO_BUNDING" {
//                                let openez =  OpenEZServiceVC(nibName: "OpenEZServiceVC", bundle: nil)
//                                GlobalKit.share().accessToken = nil
//                                self.navigationController?.pushViewController(openez, animated: true)
//                                return
//                            }
//                            GlobalKit.share().accessToken = ezToken
//                            EZOpenSDK.setAccessToken(GlobalKit.share().accessToken)
//                            let cam = CameraCollectionView(nibName: "CameraCollectionView", bundle: nil)
//                            cam.roomCode = self.roomCode
//                            print("1----\(self.roomCode)")
//                            self.navigationController?.pushViewController(cam, animated: true)
//                        })
//                    default:
//                        break
//                    }
//                    })
//                chooseAlert.show()
                break
                
            }
        }
}
