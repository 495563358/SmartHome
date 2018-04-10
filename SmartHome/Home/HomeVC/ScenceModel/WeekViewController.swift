//
//  WeekViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/7/7.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    var setArr = ["周一","周二","周三","周四","周五","周六","周日"]
    var BoolArr = ["0","0","0","0","0","0","0"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("重复", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.backgroundColor = UIColor.white
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.tableView!.backgroundColor = UIColor.groupTableViewBackground
        self.tableView!.tableFooterView = UIView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.view.addSubview(self.tableView!)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WeekViewController.leftbut))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "celltimercreate")
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "celltimercreate")
        }
        cell?.textLabel?.text = NSLocalizedString(self.setArr[indexPath.row], comment: "")
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        if self.BoolArr[indexPath.row] == "1"{
            cell?.accessoryType=UITableViewCellAccessoryType.checkmark;
        }else{
            cell?.accessoryType=UITableViewCellAccessoryType.none
        }
        //cell?.accessoryType=UITableViewCellAccessoryType.Checkmark;
        return cell!
    }

    typealias boola = (AnyObject)->()
    
    var aa:boola?
    func getweek(_ aa:@escaping boola){
        self.aa = aa
        
    }
    
    @objc func leftbut(){
//        let alert = UIAlertView(title: "提示", message: "是否保存", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
//        alert.show()
        self.aa!(self.BoolArr as AnyObject)
        self.getweek(aa!)
        
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            if BoolArr[indexPath.row] == "1"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                BoolArr[indexPath.row] = "0"
            }else{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                BoolArr[indexPath.row] = "1"
            } 
            break
        case 1:
            if BoolArr[indexPath.row] == "1"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                BoolArr[indexPath.row] = "0"
            }else{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                BoolArr[indexPath.row] = "1"
            }
              break
        case 2:
            if BoolArr[indexPath.row] == "1"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                BoolArr[indexPath.row] = "0"
            }else{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                BoolArr[indexPath.row] = "1"
            }
            break
        case 3:
            if BoolArr[indexPath.row] == "1"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                BoolArr[indexPath.row] = "0"
            }else{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                BoolArr[indexPath.row] = "1"
            }
            break
        case 4:
            if BoolArr[indexPath.row] == "1"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                BoolArr[indexPath.row] = "0"
            }else{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                BoolArr[indexPath.row] = "1"
            }
            break
        case 5:
            if BoolArr[indexPath.row] == "1"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                BoolArr[indexPath.row] = "0"
            }else{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                BoolArr[indexPath.row] = "1"
            }
            break
        case 6:
            if BoolArr[indexPath.row] == "1"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                BoolArr[indexPath.row] = "0"
            }else{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                BoolArr[indexPath.row] = "1"
            }
            break
        default:
            break
        
        }
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
