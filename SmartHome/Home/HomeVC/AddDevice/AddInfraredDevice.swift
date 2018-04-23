//
//  AddInfraredDevice.swift
//  SmartHome
//
//  Created by Smart house on 2018/4/18.
//  Copyright © 2018年 Verb. All rights reserved.
//

import UIKit

class AddInfraredDevice: UIViewController {
    
    var infraredEquip:Equip = Equip(equipID: "infrared")
    
    var timer:Timer?
    var numtimer = 0
    @objc func timerDown(){
        numtimer += 1
        
        if numtimer == 10
        {
            numtimer = 0
            timer?.invalidate()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUnClassifyDataSource()
    }
    
    func reloadUnClassifyDataSource() {
        
        if numtimer == 0{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AutomaticDevice.timerDown), userInfo: nil, repeats: true)
            BaseHttpService.sendRequestAccess(quickscanhost, parameters: [:]) { (data) -> () in
                
            }
            print("查询了。。。。。。")
        }
        
        
        
        BaseHttpService.sendRequestAccess(unclassifyEquip_do, parameters: [:]) { (data) -> () in
            if data.count <= 0{
                
                
                return
            }
            
            let arr = data as! [[String : AnyObject]]
            print(arr)
            print("aaaaaa---\(arr.count)")
            for e in arr {
                let deviceAddress = e["deviceAddress"] as! String as NSString
                if (deviceAddress.range(of: "65535,").location != NSNotFound){
                    let equip = Equip(equipID: e["deviceAddress"] as! String)
                    equip.userCode = e["userCode"] as! String
                    equip.type = e["deviceType"] as! String
                    equip.num  = e["deviceNum"] as! String
                    equip.icon  = e["icon"] as! String
                    equip.hostDeviceCode = e["deviceCode"] as! String
                    
                    if equip.icon == ""{
                        equip.icon = getIconByType(type: equip.type)
                    }
                    self.infraredEquip = equip
                    return
                }
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = self.title
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
