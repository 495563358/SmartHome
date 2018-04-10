//
//  LightCell.swift
//  SmartHome
//
//  Created by sunzl on 16/1/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SmartLockCell: UITableViewCell {
    @IBOutlet var delayBtn: UIButton!
    @IBOutlet var btn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var kai: UIButton!
    @IBOutlet weak var guan: UIButton!
    
    var commad =  0
    var isMoni:Bool = false
    var index:IndexPath?
    var equip:Equip?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.kai.layer.cornerRadius = 12.0
        self.kai.layer.masksToBounds = true
        self.kai.layer.borderWidth = 3
        self.kai.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.guan.layer.cornerRadius = 12.0
        self.guan.layer.masksToBounds = true
        self.guan.layer.borderWidth = 3
        self.guan.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.kai.setTitle(NSLocalizedString("开", comment: ""), for: UIControlState())
        self.guan.setTitle(NSLocalizedString("关", comment: ""), for: UIControlState())
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
  
 
    @IBAction func open(_ sender: AnyObject) {
        self.commad =  100
        let address = self.equip?.equipID
        if isMoni
            {
                self.equip?.status = String(self.commad )
              //  self.delayBtn.setTitle(self.equip?.delay, forState: UIControlState.Normal)
                  app.modelEquipArr[(self.index?.row)!] = self.equip!
               // app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
                self.kai.layer.borderColor = UIColor.green.cgColor
                self.guan.layer.borderColor = UIColor.white.cgColor
                return
            }
        let dic = ["deviceAddress":address!,"command":self.commad] as [String : Any]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { (back) -> () in
                self.btn.isSelected = true
                print(back)
            }
        self.kai.backgroundColor = UIColor.init(red: 14.0/255.0, green: 173.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.kai.setTitleColor(UIColor.white, for: UIControlState())
        self.guan.backgroundColor = UIColor.white
        self.guan.setTitleColor(UIColor.black, for: UIControlState())
        
    }
    
    @IBAction func shut(_ sender: AnyObject) {
        self.commad =  0
        let address = self.equip?.equipID
        if isMoni
        {
            self.equip?.status = String(self.commad )
            app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
          //  self.delayBtn.setTitle(self.equip?.delay, forState: UIControlState.Normal)
            self.guan.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            self.guan.layer.borderColor = UIColor.green.cgColor
            self.kai.layer.borderColor = UIColor.white.cgColor
            return
        }
        let dic = ["deviceAddress":address!,"command":self.commad ] as [String : Any]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { (back) -> () in
            
            self.btn.isSelected = false
            print(back)
        }
        self.guan.backgroundColor = UIColor.init(red: 14.0/255.0, green: 173.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.guan.setTitleColor(UIColor.white, for: UIControlState())
        self.kai.backgroundColor = UIColor.white
        self.kai.setTitleColor(UIColor.black, for: UIControlState())
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ e:Equip){
        
        self.equip = e
        self.nameLabel.text = e.name
        btn.setImage(UIImage.init(imageLiteralResourceName:self.equip!.icon), for: UIControlState())
        if e.icon == "门锁"{
            btn.setImage(UIImage.init(imageLiteralResourceName:"智能门锁"), for: UIControlState())
        }
        
       // btn.setImage(UIImage(named:"dark"), forState: UIControlState.Selected)

        if isMoni
        {
            if self.equip?.status == "0"{
                self.guan.layer.borderColor = UIColor.green.cgColor
                self.commad = 0
            }else{
                self.kai.layer.borderColor = UIColor.green.cgColor
                self.commad = 100
            }
            self.equip?.status = String(self.commad)
             app.modelEquipArr[(self.index?.row)!] = self.equip!
          // app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
            self.delayBtn.isHidden = false
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
    }
    

}
