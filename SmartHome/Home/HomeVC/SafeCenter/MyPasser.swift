//
//  EquipTypeChoseTVC.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MyPasser: UITableViewController {
    var roomCode:String?
    let dataSource = [NSLocalizedString("修改手势密码", comment: ""),NSLocalizedString("取消手势密码", comment: ""),NSLocalizedString("修改登录密码", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title=NSLocalizedString("安全中心", comment: "")
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = UIView()
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui(b)"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyPasser.handleBack(_:)))
        
    }
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        for temp in self.navigationController!.viewControllers {
            if temp.isKind(of: HomeVC.classForCoder()) {
                self.navigationController?.popToViewController(temp , animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 14/255.0, green: 173/255.0, blue: 254/255.0, alpha: 1)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 0:
            let vc1 = DBGViewController()
            
            vc1.isLogin = false
            self.navigationController!.pushViewController(vc1, animated:true)
            break
         case 1:
            UserDefaults.standard.set("0", forKey: "password")
            showMsg(msg: NSLocalizedString("取消成功!", comment: ""))
            break
        case 2:
            let vc1 = SetPassViewController()
            self.navigationController?.pushViewController(vc1, animated: true)
        default:
            break
            
        }
    }
    
}
