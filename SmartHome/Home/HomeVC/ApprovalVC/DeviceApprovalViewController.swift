//
//  DeviceApprovalViewController.swift
//  SmartHome
//
//  Created by Smart house on 2018/3/7.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

protocol postApprovalDevice:NSObjectProtocol {
    
        func getApprovalDeviceData(datas:[FloorOrRoomOrEquip])
}


class DeviceApprovalViewController: UITableViewController{
    
    
    
    var delegate:postApprovalDevice? = nil
    
    var tDataSource: [FloorOrRoomOrEquip] = []
    
    var choosedtDataSource: [FloorOrRoomOrEquip] = []
    
    var tDic: [String : [Equip]] = [String : [Equip]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "设备权限"
        self.view.backgroundColor = mygrayColor
        
        tableView.register(UINib(nibName: "EquipTableRoomCell", bundle: nil), forCellReuseIdentifier: "equiptableroomcell")
        tableView.register(UINib(nibName: "EquipTableEquipCell", bundle: nil), forCellReuseIdentifier: "equiptableequipcell")
        tableView.register(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        tableView.register(UINib(nibName: "EquipTableFloorCell", bundle: nil), forCellReuseIdentifier: "equiptablefloorcell")
        
        
        tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat.leastNormalMagnitude))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeviceApprovalViewController.backClick))
    }
    
    @objc func backClick(){
        
        if(self.delegate != nil){
            delegate?.getApprovalDeviceData(datas: self.tDataSource)
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
        return tDataSource.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row >= tDataSource.count){
            let whiteCell = UITableViewCell.init(style: .default, reuseIdentifier: "whitecell")
            return whiteCell
        }
        let model = tDataSource[indexPath.row]
        print("授权设备列表第 \(indexPath.row) 行 \n")
        dump(model)
        switch model.type {
        case .floor:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equiptablefloorcell", for: indexPath) as! EquipTableFloorCell
            let floor = dataDeal.searchModel(type: .Floor, byCode: (model.floor?.floorCode)!) as! Floor
            let floorName = floor.name
            cell.roomName.text = "\(floorName)"
            return cell
        case .room:
            let cell = tableView.dequeueReusableCell(withIdentifier: "equiptableroomcell", for: indexPath) as! EquipTableRoomCell
            
            
            cell.roomName.text = "\(model.room!.name)"
            if model.isUnfold {
                cell.unfoldImage.image = UIImage(named: "down_black")
            } else {
                cell.unfoldImage.image = UIImage(named: "up_black")
            }
            return cell
        case .equip:
            var cell = tableView.dequeueReusableCell(withIdentifier: "equipApprovalcell")
            if(cell == nil){
                cell = DeviceApprovalCell.init(style: .default, reuseIdentifier: "equipApprovalcell")
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
            }
            let devcell = cell as! DeviceApprovalCell
            
            devcell.titleLab.text = model.equip!.name
            devcell.centerImg = UIImageView.init(image:UIImage(named: model.equip!.icon))
            if model.equip?.icon == "list_camera"{
                devcell.centerImg = UIImageView.init(image:UIImage(named: "摄像头"))
            }
            devcell.centerImg.center = devcell.imageV.center
            
            devcell.imageV.frame = devcell.centerImg.frame
            devcell.imageV.image = devcell.centerImg.image
            
            devcell.myswitchBtn.isOn = (model.equip?.isApproval)!
            devcell.myswitchBtn.tag = indexPath.row
            devcell.myswitchBtn.addTarget(self, action: #selector(DeviceApprovalViewController.switchClick(sender:)), for: .valueChanged)
            return devcell
            
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addroomcell", for: indexPath) as! AddRoomCell
            return cell
        }
        
    }
    

    @objc func switchClick(sender:UISwitch){
    
        tDataSource[sender.tag].equip?.isApproval = !(tDataSource[sender.tag].equip?.isApproval)!
        print("------设备权限")
        
        if sender.isOn {
            print("switch is on")
        } else {
            print("switch is off")
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = tDataSource[indexPath.row]
        
        if model.type == .room{
            let cell = tableView.cellForRow(at: indexPath) as! EquipTableRoomCell
            if model.isUnfold {//收起
                model.isUnfold = false
                cell.unfoldImage.image = UIImage(named: "up_black")
                var indexPaths = [IndexPath]()
                for i in 0..<(tDic[model.room!.roomCode]?.count)! {
                    let subIndexPath = IndexPath(row: indexPath.row + 1 + i, section: 0)
                    indexPaths.append(subIndexPath)
                }
                indexPaths.append(IndexPath(row: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!, section: 0))
                tDataSource.removeSubrange(((indexPath.row + 1) ..< indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!))
                
                tableView.reloadData()
            } else {
                
                model.isUnfold = true
                cell.unfoldImage.image = UIImage(named: "down_black")
                var indexPaths = [IndexPath]()
                var equips = [FloorOrRoomOrEquip]()
                for i in 0..<(tDic[model.room!.roomCode]?.count)! {
                    let subIndexPath = IndexPath(row: indexPath.row + 1 + i, section: 0)
                    indexPaths.append(subIndexPath)
                    equips.append(FloorOrRoomOrEquip(floor:nil,room: nil, equip: tDic[model.room!.roomCode]?[i]))
                }
                tDataSource.insert(contentsOf: equips, at: indexPath.row + 1)
                indexPaths.append(IndexPath(row: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!, section: 0))
                tableView.reloadData()
            }
        }
        
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
