//
//  ApprovalModelViewController.swift
//  SmartHome
//
//  Created by Smart house on 2018/4/9.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class ApprovalModelViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    var modelData = [EditChainModel]()
    
    typealias sendModelBlock = ([EditChainModel])->()
    var modelblock:sendModelBlock?
    func callBlock(block:sendModelBlock?){
        self.modelblock = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "情景权限"
        self.view.backgroundColor = mygrayColor
        
        tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
        let backBtn = UIButton.init(frame: CGRect(x: 0, y: 35, width: 40, height: 40))
        backBtn.setImage(UIImage(named: "fanhui(b)"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(ApprovalModelViewController.backClick), for: UIControlEvents.touchUpInside)
        
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }

    @objc func backClick(){
        
        if let block  =  self.modelblock {
            block(modelData)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelData.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row >= modelData.count){
            let whiteCell = UITableViewCell.init(style: .default, reuseIdentifier: "whitecell")
            return whiteCell
        }
        
        let model = modelData[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if !(cell != nil){
            cell = RoomApprovalTableViewCell.init(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        (cell as! RoomApprovalTableViewCell).mytextLabel.text = model.modelName
        (cell as! RoomApprovalTableViewCell).myswitchBtn.isOn = model.isApproval
        (cell as! RoomApprovalTableViewCell).myswitchBtn.tag = indexPath.row
        (cell as! RoomApprovalTableViewCell).myswitchBtn.addTarget(self, action: #selector(RoomApprovalViewController.switchClick(sender:)), for: .valueChanged)
        // Configure the cell...
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    
    @objc func switchClick(sender:UISwitch){
        
        modelData[sender.tag].isApproval = !(modelData[sender.tag].isApproval)
        print("------情景权限")
        
        if sender.isOn {
            print("switch is on")
        } else {
            print("switch is off")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
