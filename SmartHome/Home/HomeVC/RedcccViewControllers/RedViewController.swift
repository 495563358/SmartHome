//
//  RedViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/6/12.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let table = UITableView()
    var equip:Equip?
    var isMoni = false

    var dic = [String:String]()
    var indexqj:IndexPath?
    var arr = ((UIApplication.shared.delegate) as! AppDelegate).infArr
    override func viewDidLoad() {
        super.viewDidLoad()
        //请求服务器该模板信息 1 abc 2 dict【“键值”：“名字” ，。。。】
        self.table.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
       // self.navigationController?.title = "模块选择"
        self.navigationItem.title = NSLocalizedString("红外", comment: "")

        self.view.addSubview(self.table)
        // Do any additional setup after loading the view.
        //self.table.registerNib("FirstTableViewCell", forCellReuseIdentifier: "FirstTableViewCell")
//        self.table.registerClass(FirstTableViewCell.classForCoder(), forCellReuseIdentifier: "FirstTableViewCell")
//        self.table.registerClass(SecondTableViewCell.classForCoder(), forCellReuseIdentifier: "SecondTableViewCell")
//        self.table.registerClass(ThirdTableViewCell.classForCoder(), forCellReuseIdentifier: "ThirdTableViewCell")
        self.table.frame.size.height=self.table.frame.size.height-64
        self.table.delegate = self
        self.table.dataSource = self
        if !isMoni &&  BaseHttpService.GetAccountOperationType() != "2"{
            let but = UIBarButtonItem(image: UIImage(named: "添加房间"), style: .plain, target: self, action: #selector(RedViewController.handleBack(_:)))
            
            let helpBtn = UIBarButtonItem(image: UIImage(named: "deviceList"), style: .plain, target: self, action: #selector(RedViewController.helpClick))
            
            self.navigationItem.rightBarButtonItems = [but,helpBtn]
        }

    }
    
    @objc func helpClick(){
        showMsg(msg: "长按按键点击“学习”按键后，再按一下需要学习的按键，这时主机会发出“滴”一声，按下遥控器中对应的按键，学习成功后主机会再发出“滴”一声表示学习成功，“滴滴滴”三声表示学习失败")
    }
    
    @objc func handleBack(_ barButton: UIBarButtonItem) {
        let VC = RedcccViewController()
        VC.equip = self.equip
        VC.hidesBottomBarWhenPushed=true
        VC.isMoni = self.isMoni
        VC.indexqj = self.indexqj
        self.navigationController?.pushViewController(VC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        getDmodel()
      //  self.arr = ((UIApplication.sharedApplication().delegate) as! AppDelegate).infArr
        print("--self.equip---\(self.equip)");
        //self.table.reloadData()
    }
    
    func getDmodel(){
        app.infArr = []
        self.arr = []
        self.table.reloadData()
        let HttpDic = ["deviceCode":self.equip!.hostDeviceCode,"deviceAddress":self.equip!.equipID]
        BaseHttpService.sendRequestAccess(gaininfraredvalue, parameters: HttpDic as NSDictionary, success: { (response) -> () in
            print(response)
            if response.count == 0{
                (UIApplication.shared.delegate as! AppDelegate).infArr = []
            }else{
                var  shunxu = (response["shunxu"]as!NSArray) [0] as! String;
                shunxu = (shunxu as NSString).substring(with: NSMakeRange(0, shunxu.characters.count-1))
                let kv = response["button-value"];
                print("\(shunxu)---\(kv)");
                let arr = shunxu.components(separatedBy: ",")
                self.dic = kv as! [String:String]
                app.infArr = arr
                self.arr = arr
                self.table.reloadData()
                //app.infArr = ["A0","B0","C0"]
                
                print("所有数据 = \(self.arr) /n/n \(self.dic)")
            }
            
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = (app.infArr[indexPath.row] as NSString).substring(with: NSMakeRange(0, 1))
        let str1 = (app.infArr[indexPath.row] as NSString).substring(with: NSMakeRange(1, app.infArr[indexPath.row].count - 1))
     print(str1)
        switch str{
        case "A":
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell"+String(indexPath.row))
            if cell == nil{
                
                cell = FirstTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "FirstTableViewCell"+String(indexPath.row))
                
                (cell as! FirstTableViewCell).index = Int(str1)!
                //(cell as! FirstTableViewCell).index = indexPath
                // (cell as! FirstTableViewCell).dic = self.dic;
                (cell as! FirstTableViewCell).equip = self.equip
                (cell as! FirstTableViewCell).dic = self.dic
                (cell as! FirstTableViewCell).setup()
                }
            
            
            
            (cell as! FirstTableViewCell).isMoni = self.isMoni
             (cell as! FirstTableViewCell).indexqj = self.indexqj
           // (cell as! FirstTableViewCell).detajson()
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        case "B":
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell"+String(indexPath.row))
            if cell == nil{
                
                cell = SecondTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "SecondTableViewCell"+String(indexPath.row))
                }
                (cell as! SecondTableViewCell).index = Int(str1)!
                //(cell as! SecondTableViewCell).index = indexPath
                (cell as! SecondTableViewCell).equip = self.equip
                (cell as! SecondTableViewCell).dic = self.dic
                (cell as! SecondTableViewCell).setup()
            
            
    
            (cell as! SecondTableViewCell).isMoni = self.isMoni
            (cell as! SecondTableViewCell).indexqj = self.indexqj
            //(cell as! SecondTableViewCell).detajson()
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        case "C":
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "ThirdTableViewCell"+String(indexPath.row))
            if cell == nil{
                
                cell = ThirdTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ThirdTableViewCell"+String(indexPath.row))
                (cell as! ThirdTableViewCell).index = Int(str1)!
                (cell as! ThirdTableViewCell).equip = self.equip
                (cell as! ThirdTableViewCell).dic = self.dic
                (cell as! ThirdTableViewCell).setup()
            }
            print("cell")
            

           
            (cell as! ThirdTableViewCell).isMoni = self.isMoni
            (cell as! ThirdTableViewCell).indexqj = self.indexqj
            //(cell as! ThirdTableViewCell).detajson()
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        case "D":
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "FourthTableViewCell"+String(indexPath.row))
            if cell == nil{
                
                cell = FourthTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "FourthTableViewCell"+String(indexPath.row))
                
                (cell as! FourthTableViewCell).index = Int(str1)!
                //(cell as! FirstTableViewCell).index = indexPath
                // (cell as! FirstTableViewCell).dic = self.dic;
                (cell as! FourthTableViewCell).equip = self.equip
                (cell as! FourthTableViewCell).dic = self.dic
                (cell as! FourthTableViewCell).setup()
            }
            
            
            
            (cell as! FourthTableViewCell).isMoni = self.isMoni
            (cell as! FourthTableViewCell).indexqj = self.indexqj
            // (cell as! FirstTableViewCell).detajson()
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        case "E":
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "FifthTableViewCell"+String(indexPath.row))
            if cell == nil{
                
                cell = FifthTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "FifthTableViewCell"+String(indexPath.row))
                (cell as! FifthTableViewCell).index = Int(str1)!
                (cell as! FifthTableViewCell).equip = self.equip
                (cell as! FifthTableViewCell).dic = self.dic
                (cell as! FifthTableViewCell).setup()
            }
            print("cell")
            
            
            
            (cell as! FifthTableViewCell).isMoni = self.isMoni
            (cell as! FifthTableViewCell).indexqj = self.indexqj
            //(cell as! ThirdTableViewCell).detajson()
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!

        default :
            
         
            
            return UITableViewCell()
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let str = (app.infArr[indexPath.row] as NSString).substring(with: NSMakeRange(0, 1))
        if str == "B"{
            return ScreenHeight * 0.33
        }else if str == "A"{
            return UIScreen.main.bounds.size.height/2 * 1.15
        }else if str == "D"{
            return ScreenHeight/2*1.35
        }else if str == "E"{
            return ScreenHeight/2*1.25
        }
        return UIScreen.main.bounds.size.height/2 * 1.15
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
