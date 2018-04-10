//
//  CreateTimerViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/7/7.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CreateTimerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView?
    var setArr = [NSLocalizedString("重复", comment: ""),NSLocalizedString("时间", comment: "")]
    var modelId:String?
    
    var modelWeek = ""
    var modelTime = ""
    
    var modelStr = ""
    var BoolArr = ["0","0","0","0","0","0","0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("时间设置", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.backgroundColor = UIColor.white
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.tableView!.backgroundColor = UIColor.groupTableViewBackground
        self.tableView!.tableFooterView = UIView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.view.addSubview(self.tableView!)
        
        let nextStep = UIButton.init(frame: CGRect(x: ScreenWidth/4, y: 50, width: ScreenWidth/2, height: 45))
        nextStep.backgroundColor = systemColor
        nextStep.layer.cornerRadius = 10
        nextStep.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStep.setTitle("保存", for: UIControlState())
        nextStep.addTarget(self, action: #selector(CreateTimerViewController.selectRightAction(_:)), for: UIControlEvents.touchUpInside)
        
        let footerView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWidth,height:100))
        footerView.addSubview(nextStep)
        self.tableView?.tableFooterView = footerView
        
        
        let dic = ["modelId":self.modelId!]
        print(dic)
        BaseHttpService.sendRequestAccess(gainModelTiming, parameters: dic as NSDictionary) { (arr) -> () in
            print(arr)
            if arr.count == 0{
                self.modelStr = ""
                return 
            }
            if (arr["modelWeek"] as! String) != "" /*&& (arr["modelTime"] as! String) != ""*/{
                let arr1 = (arr["modelWeek"] as! NSString).substring(with: NSMakeRange(0, (arr["modelWeek"] as! String).characters.count-1))
                self.modelWeek = arr["modelWeek"] as! String
                self.modelTime = arr["modelTime"] as! String
                
                let xarr = arr1.components(separatedBy: ",")
                self.modelStr = ""
                var timerI = 0
                for var str1 in xarr{
                    switch str1{
                        
                    case "星期一" :
                        self.modelStr += NSLocalizedString("周一", comment: "")
                        self.BoolArr[0] = "1"
                        timerI += 1
                        break
                    case "星期二" :
                        self.modelStr += NSLocalizedString("周二", comment: "")
                        self.BoolArr[1] = "1"
                        timerI += 1
                        break
                    case "星期三" :
                        self.modelStr += NSLocalizedString("周三", comment: "")
                        self.BoolArr[2] = "1"
                        timerI += 1
                        break
                    case "星期四" :
                        self.modelStr += NSLocalizedString("周四", comment: "")
                        self.BoolArr[3] = "1"
                        timerI += 1
                        break
                    case "星期五" :
                        self.modelStr += NSLocalizedString("周五", comment: "")
                        self.BoolArr[4] = "1"
                        timerI += 1
                        break
                    case "星期六" :
                        self.modelStr += NSLocalizedString("周六", comment: "")
                        self.BoolArr[5] = "1"
                        timerI -= 1
                        break
                    case "星期日" :
                        self.modelStr += NSLocalizedString("周日", comment: "")
                        self.BoolArr[6] = "1"
                        timerI -= 1
                        break
                    default:
                        break
                    }
                }
                if timerI == 5{
                    self.modelStr = NSLocalizedString("工作日", comment: "")
                }
                var dayTimer = 0
                if self.BoolArr.count == 0{
                    print("没有数据")
                    return
                }
                for var j in 0...self.BoolArr.count-1
                {
                    dayTimer += Int(self.BoolArr[j])!;
                }
                if dayTimer == 7{
                    self.modelStr = NSLocalizedString("每天", comment: "")
                }
               
            }else if (arr["modelTime"] as! String) != ""{
                self.modelTime = arr["modelTime"] as! String
            }
            self.tableView?.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    @objc func selectRightAction(_ but:UIButton){
        
//        if self.modelWeek == "" || self.modelTime == ""{
//            showMsg("完善时间设置")
//            return
//        }
        
        let dic = ["modelId":self.modelId!,"modelWeek":self.modelWeek,"modelTime":self.modelTime]
        print(dic)
        BaseHttpService.sendRequestAccess(setModelTiming, parameters: dic as NSDictionary) { (arr) -> () in
            self.navigationController?.popViewController(animated: true)
        }
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
            cell = UITableViewCell(style:UITableViewCellStyle.value1, reuseIdentifier: "celltimercreate")
        }
        if indexPath.row == 0{
            cell?.detailTextLabel?.text = self.modelStr
        }else{
            cell?.detailTextLabel?.text = self.modelTime
        }
        cell?.textLabel?.text = self.setArr[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        cell?.selectionStyle = UITableViewCellSelectionStyle.none;
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            
            let weekVC = WeekViewController()
            var timer = ""
            var timerI = 0
            var dayTimer = 0
            var timerx = ""
            weekVC.BoolArr = self.BoolArr
            weekVC.getweek({ (arr) -> () in
                print(arr)
                if arr.count == 0{
                    return
                }
                for var i in 0...arr.count
                {
                    switch i {
                        
                    case 0:
                        if ((arr as! NSArray) [0] as! NSString) == "1"{
                            timer += NSLocalizedString("周一", comment: "")
                            timerx += "星期一,"
                            timerI += 1
                            dayTimer += 1
                        }

                        break
                    case 1:
                        if ((arr as! NSArray) [1] as! NSString) == "1"{
                           timer += NSLocalizedString("周二", comment: "")
                            timerI += 1
                            timerx += "星期二,"
                            dayTimer += 1
                        }
                        
                        break
                    case 2:
                        if ((arr as! NSArray) [2] as! NSString) == "1"{
                        timer += NSLocalizedString("周三", comment: "")
                            timerI += 1
                            timerx += "星期三,"
                            dayTimer+=1
                        }
                        
                        break
                    case 3:
                        if ((arr as! NSArray) [3] as! NSString) == "1"{
                        timer += NSLocalizedString("周四", comment: "")
                            timerI+=1
                            timerx += "星期四,"
                            dayTimer+=1
                        }
                        
                        break
                    case 4:
                        if ((arr as! NSArray) [4] as! NSString) == "1"{
                        timer += NSLocalizedString("周五", comment: "")
                            timerx += "星期五,"
                            timerI += 1
                            dayTimer += 1
                        }
                        
                        break
                    case 5:
                        if ((arr as! NSArray) [5] as! NSString) == "1"{
                        timer += NSLocalizedString("周六", comment: "")
                            timerx += "星期六,"
                            timerI -= 1
                            dayTimer += 1
                        }
                        
                        break
                    case 6:
                        if ((arr as! NSArray) [6] as! NSString) == "1"{
                        timer += NSLocalizedString("周日", comment: "")
                            timerx += "星期日,"
                            timerI -= 1
                            dayTimer += 1
                        }
                        
                        break
                    default :
                        break
                    }

                }

                self.modelWeek = timerx
                

                if dayTimer == 7{
                    
                    timer = NSLocalizedString("每天", comment: "")
                }
                if timerI == 5{
                    timer = NSLocalizedString("工作日", comment: "")
                }
                let cell = tableView.cellForRow(at: indexPath)
                cell?.detailTextLabel?.text = timer
            })
            //weekVC.aa = getWeekVC
            self.navigationController?.pushViewController(weekVC, animated: true)
            break
        case 1:
            var dic1 = [String:[String]]()
            for var i in 0...23
            {
                var dic = [String]()
                for var j in 0...5
                {
                    for var k in 0...9
                    {
                        dic.append(String(j)+String(k))
                    }
                    
                }
                if i<10{
                    dic1["0"+String(i)] = dic
                }else{
                    dic1[String(i)] = dic
                }
            }
            print(dic1)
            let sunData = SunDataPicker.init(frame: CGRect(x: 0, y: 100,width: ScreenWidth-20 , height: (ScreenWidth-20)*3/3))
            sunData.setNumberOfComponents(2, set: dic1, addTarget:self.navigationController!.view  , complete: { (one, two, three) -> Void in
                print(one!+two!)
                let cell = tableView.cellForRow(at: indexPath)
                self.modelTime = one!+":"+two!
                cell?.detailTextLabel?.text = one!+":"+two!
                })
            break
        default:
            break
        }
    }
    
    func getWeekVC(_ aa:AnyObject){
        print(aa)
        
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
