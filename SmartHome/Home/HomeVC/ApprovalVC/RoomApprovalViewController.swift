//
//  RoomApprovalViewController.swift
//  SmartHome
//
//  Created by Smart house on 2018/3/7.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class RoomApprovalViewController: UITableViewController {
    
    var dataSource: [Building] = []
    
    var choosedRoomSource : [Building] = []
    
    typealias choosedRoomBlock = ([Building])->()
    var block:choosedRoomBlock?
    
    func callBlock(block:choosedRoomBlock?){
        self.block = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.navigationItem.title = "房间权限"
        self.view.backgroundColor = mygrayColor
        
        tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat.leastNormalMagnitude))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(RoomApprovalViewController.backClick))
        tableView.register(UINib(nibName: "EquipTableRoomCell", bundle: nil), forCellReuseIdentifier: "equiptableroomcell")
        
    }
    
    @objc func backClick(){
        if let block  =  self.block {
            block(choosedRoomSource)
        }
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
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row >= dataSource.count){
            let whiteCell = UITableViewCell.init(style: .default, reuseIdentifier: "whitecell")
            return whiteCell
        }
        let building = dataSource[indexPath.row]
        switch building.buildType {
        case .buildFloor:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "equiptableroomcell", for: indexPath) as! EquipTableRoomCell
            let floorName = building.buildName
            cell.roomName.text = "\(floorName)"
            cell.unfoldImage.image = UIImage(named: "down_black")
            
            return cell
            
        default:
            break
        }
        print("------------------------------------spera")
        print(building.isApproval)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if !(cell != nil){
            cell = RoomApprovalTableViewCell.init(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        (cell as! RoomApprovalTableViewCell).mytextLabel.text = building.buildName
        (cell as! RoomApprovalTableViewCell).myswitchBtn.isOn = building.isApproval
        (cell as! RoomApprovalTableViewCell).myswitchBtn.tag = indexPath.row
        (cell as! RoomApprovalTableViewCell).myswitchBtn.addTarget(self, action: #selector(RoomApprovalViewController.switchClick(sender:)), for: .valueChanged)
        // Configure the cell...
        cell?.selectionStyle = .none
        return cell!
    }
 
    @objc func switchClick(sender:UISwitch){
        
        choosedRoomSource[sender.tag].isApproval = !choosedRoomSource[sender.tag].isApproval
        
        for var building in choosedRoomSource{
            print("\(building.buildName) 状态:\(building.isApproval)")
        }
        
        if sender.isOn {
            print("switch is on")
        } else {
            print("switch is off")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
