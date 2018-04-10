//
//  LightCell.swift
//  SmartHome
//
//  Created by sunzl on 16/1/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LightCell: UITableViewCell {
    @IBOutlet var delayBtn: UIButton!
    
    @IBOutlet var btn: UIButton!

    @IBOutlet var iswitch: UISwitch!

    @IBOutlet var nameLabel: UILabel!
    
    var isMoni:Bool = false
    var index:IndexPath?
    var equip:Equip?
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.setImage(UIImage.init(imageLiteralResourceName: "普通灯泡"), for: UIControlState())
        btn.setImage(UIImage(named:"dark"), for: UIControlState.selected)
//        btn.setImage(UIImage(named:"普通灯泡"), forState: UIControlState.Selected)
        
        // Initialization code
    }

    @IBAction func delayChoseTap(_ sender: AnyObject) {
      let parent =  self.parentController() as! CreateModelVC
        parent.sunData?.setNumberOfComponents(1, set:[NSLocalizedString("立即执行", comment: ""),"\(NSLocalizedString("延迟", comment: ""))0.5\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))1\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))2\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))3\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))4\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))5\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))10\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))15\(NSLocalizedString("秒", comment: ""))","\(NSLocalizedString("延迟", comment: ""))30\(NSLocalizedString("秒", comment: ""))"], addTarget:parent.navigationController!.view , complete: { [unowned self](one, two, three) -> Void in
            let a = one!
            self.delayBtn.setTitle(a, for: UIControlState())
            switch(a){
            case NSLocalizedString("立即执行", comment: ""):self.equip?.delay = "300"//ms
                break
            case "\(NSLocalizedString("延迟", comment: ""))0.5\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "600"
                break
            case "\(NSLocalizedString("延迟", comment: ""))1\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "1000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))2\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "2000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))3\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "3000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))4\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "4000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))5\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "5000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))10\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "10000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))15\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "15000"
                break
            case "\(NSLocalizedString("延迟", comment: ""))30\(NSLocalizedString("秒", comment: ""))":self.equip?.delay = "30000"
                break
            default:break
                
            }
     app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
            print(a)
        })
      }
    //找到当前视图
    func parentController()->UIViewController?
    {
        var next = self.superview
        while next != nil {
            let nextr = next?.next
            if nextr!.isKind(of: UIViewController.classForCoder()){
                return (nextr as! UIViewController)
            }
            next = next?.superview
        }
        return nil
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ e:Equip){
        
        self.equip = e
        self.nameLabel.text = e.name
        //self.delayBtn.setTitle(e.delay, forState: UIControlState.Normal)
        
        if isMoni
        {
            self.iswitch.setOn(e.status == "100", animated: true)
           self.equip?.status = String(Int(iswitch.isOn ? 100 : 0))
            app.modelEquipArr[(self.index?.row)!] = self.equip!
            btn.isSelected = Float(e.status)! < 50
         // app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
            self.delayBtn.isHidden = false
            /// delay
            var str = ""
            switch(self.equip!.delay){
            case "300":str = NSLocalizedString("立即执行", comment: "")//ms
                break
            case "600":str = "\(NSLocalizedString("延迟", comment: ""))0.5\(NSLocalizedString("秒", comment: ""))"
                break
            case "1000":str =  "\(NSLocalizedString("延迟", comment: ""))1\(NSLocalizedString("秒", comment: ""))"
                break
            case "2000":str =  "\(NSLocalizedString("延迟", comment: ""))2\(NSLocalizedString("秒", comment: ""))"
                break
            case "3000":str =  "\(NSLocalizedString("延迟", comment: ""))3\(NSLocalizedString("秒", comment: ""))"
                break
            case "4000":str =  "\(NSLocalizedString("延迟", comment: ""))4\(NSLocalizedString("秒", comment: ""))"
                break
            case "5000":str =  "\(NSLocalizedString("延迟", comment: ""))5\(NSLocalizedString("秒", comment: ""))"
                break
            case "10000":str =  "\(NSLocalizedString("延迟", comment: ""))10\(NSLocalizedString("秒", comment: ""))"
                break
            case "15000":str =  "\(NSLocalizedString("延迟", comment: ""))15\(NSLocalizedString("秒", comment: ""))"
                break
            case "30000":str =  "\(NSLocalizedString("延迟", comment: ""))30\(NSLocalizedString("秒", comment: ""))"
                break
            default:break
            }
            self.delayBtn.setTitle(str, for: UIControlState())
            
           
            
            return
        }
        self.delayBtn.isHidden = true
        if e.status != ""{
              iswitch.isOn = Float(e.status)! > 50
            print("iswitch.on = \(iswitch.isOn) , \(e.status)")
            btn.isSelected = Float(e.status)! < 50
        }else{
      iswitch.isOn = false
       btn.isSelected = true
        }
   
    }
    
    //块
    typealias setStat = (String)->()
    
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    
    func completeBlock(_ chName:setStat)->Void{
        
    }
    //回调
    var CallbackStat:setStat?
    
    @IBAction func valueChangeTap(_ sender: UISwitch) {
       
        print(sender.isOn)
       
        let commad = sender.isOn ? 100 : 0
         self.btn.isSelected = !sender.isOn
        let address = self.equip?.equipID
        if isMoni
        {
            self.equip?.status = String(commad)
            app.modelEquipArr[(self.index?.row)!] = self.equip!
            return
        }
         
        let dic = ["deviceAddress":address!,"command":commad] as [String : Any]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { (back) -> () in
           
           
            print(back)
            self.CallbackStat!("\(commad)")
        }
    }
}
