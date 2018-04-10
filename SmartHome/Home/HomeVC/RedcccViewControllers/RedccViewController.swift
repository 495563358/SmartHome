//
//  RedcccViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/6/16.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RedccViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    var arr = ["新红外1","新红外2","新红外3","背景音乐4","变色灯模块5"]
    var equip:Equip?
    var isMoni = false
    let table = UITableView()
    var cellArr = [UITableViewCell]()
    var indexqj:IndexPath?
    override func viewDidLoad() {
        
         //app.infArr = ["A2","B1","C0"]
        
        super.viewDidLoad()
        self.table.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.navigationItem.title = NSLocalizedString("模块选择", comment: "")
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: "selectRightAction:")
        //请求服务器该模板信息 1 abc 2 dict【“键值”：“名字” ，。。。】
        self.table.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(self.table)
        // Do any additional setup after loading the view.
       
        self.table.frame.size.height=self.table.frame.size.height-64
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
        // Do any additional setup after loading the view.
    }
    func selectRightAction(_ butt:UIButton)->Void{
        
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "First1TableViewCell"+String(indexPath.row))
        if cell == nil{
        
            cell = First1TableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "First1TableViewCell"+String(indexPath.row))
            (cell as! First1TableViewCell).setimg(UIImage(named: arr[indexPath.row])!)
            (cell as! First1TableViewCell).setinit()
            (cell as! First1TableViewCell).but.isHidden = true
        }
        cellArr.append(cell!)
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
        
//        switch indexPath.row{
//            
//        case 0:
//            var cell:UITableViewCell?
//            cell = tableView.dequeueReusableCellWithIdentifier("First1TableViewCell")
//            if cell == nil{
//                
//                cell = First1TableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "First1TableViewCell"+String(indexPath.row))
//                (cell as! First1TableViewCell).setinit()
//            }
//            
//            cell!.selectionStyle = UITableViewCellSelectionStyle.None
//            cellArr.append(cell!)
//            return cell!
//        case 1:
//            var cell:UITableViewCell?
//            cell = tableView.dequeueReusableCellWithIdentifier("Second1TableViewCell"+String(indexPath.row))
//            if cell == nil{
//                cell = Second1TableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "Second1TableViewCell"+String(indexPath.row))
//                 (cell as! Second1TableViewCell).setinit()
//            }
//            cell!.selectionStyle = UITableViewCellSelectionStyle.None
//           cellArr.append(cell!)
//            return cell!
//        case 2:
//            var cell:UITableViewCell?
//            cell = tableView.dequeueReusableCellWithIdentifier("Third1TableViewCell"+String(indexPath.row))
//            if cell == nil{
//                
//                cell = Third1TableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "Third1TableViewCell"+String(indexPath.row))
//                 (cell as! Third1TableViewCell).setinit()
//            }
//            cell!.selectionStyle = UITableViewCellSelectionStyle.None
//            cellArr.append(cell!)
//            return cell!
//        default :
//            return UITableViewCell()
//        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         print(UIScreen.main.bounds.size.height/5)
        return UIScreen.main.bounds.size.height/5
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
      //
        let arr = ["A","B","C","D","E"]
        
    
        app.infArr  = getCurrentTemplet(app.infArr, choseTemplet: arr[indexPath.row])
        print("-----------\(app.infArr)")
    }

    func getCurrentTemplet(_ lastTemplets:[String],choseTemplet:String)->[String]{
        
        var i = 0
        if lastTemplets.count != 0{
            for  var j in 0...lastTemplets.count-1
            {
                if !lastTemplets.contains(choseTemplet+String(j)){
                    break
                }
                i += 1
            }
        }
        
        
        var arr = lastTemplets
    
        switch choseTemplet{
        case "A":
            let cell = FirstTableViewCell()
            cell.index = i
            cell.equip = self.equip
            cell.detajson({[unowned self] () -> () in
                
                arr.append(choseTemplet+String(i))
                print("回调添加\(arr)")
                app.infArr = arr
                self.navigationController?.popViewController(animated: true)
            })
            break
        case "B":
            let cell = SecondTableViewCell()
            cell.index = i
            cell.equip = self.equip
            cell.detajson({[unowned self] () -> () in
                arr.append(choseTemplet+String(i))
                 print("回调添加\(arr)")
                app.infArr = arr
                self.navigationController?.popViewController(animated: true)
            })
            break
        case "C":
            let cell = ThirdTableViewCell()
            cell.index = i
            cell.equip = self.equip
            cell.detajson({[unowned self] () -> () in
                arr.append(choseTemplet+String(i))
                 print("回调添加\(arr)")
                app.infArr = arr
                self.navigationController?.popViewController(animated: true)
            })
            break
        case "D":
            let cell = FourthTableViewCell()
            cell.index = i
            cell.equip = self.equip
            cell.detajson({[unowned self] () -> () in
                
                arr.append(choseTemplet+String(i))
                print("回调添加\(arr)")
                app.infArr = arr
                self.navigationController?.popViewController(animated: true)
                })
            break
        case "E":
            let cell = FifthTableViewCell()
            cell.index = i
            cell.equip = self.equip
            cell.detajson({[unowned self] () -> () in
                arr.append(choseTemplet+String(i))
                print("回调添加\(arr)")
                app.infArr = arr
                self.navigationController?.popViewController(animated: true)
                })
            break
        default:
            break
        }
    return  arr
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
