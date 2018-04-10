//
//  LightCell.swift
//  SmartHome
//
//  Created by sunzl on 16/1/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class DuYaCell: UITableViewCell {
    @IBOutlet var delayBtn: UIButton!
    @IBOutlet var btn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var kai: UIButton!
    @IBOutlet weak var guan: UIButton!
    @IBOutlet weak var studyButton: UIButton!
    
    var commad =  0
    var isMoni:Bool = false
    var index:IndexPath?
    var equip:Equip?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //重新设置按钮位置
        
        var ff = 46 * ScreenWidth/375
        
        if(ScreenWidth < 375){
            ff = 46 * ScreenWidth/375
        }
        
        
        self.studyButton.frame = CGRect(x: ScreenWidth/3 + 25, y: 19, width: ff, height: 30)
        self.guan.frame = CGRect(x: ScreenWidth - 20 - ff, y: 19, width: ff, height: 30)
        
        let maginX = (guan.x - studyButton.x - 3*ff)/3 + ff
        
        self.kai.frame = CGRect(x: studyButton.x + maginX, y: 19, width: ff, height: 30)
        
        self.butting.frame = CGRect(x: studyButton.x + 2 * maginX, y: 19, width: ff, height: 30)
        
        
        self.kai.layer.cornerRadius = 12.0
        self.kai.layer.masksToBounds = true
        self.kai.layer.borderWidth = 3
        self.kai.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.guan.layer.cornerRadius = 12.0
        self.guan.layer.masksToBounds = true
        self.guan.layer.borderWidth = 3
        self.guan.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.butting.layer.cornerRadius = 12.0
        self.butting.layer.masksToBounds = true
        self.butting.layer.borderWidth = 3
        self.butting.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.studyButton.layer.cornerRadius = 12.0
        self.studyButton.layer.masksToBounds = true
        self.studyButton.layer.borderWidth = 3
        self.studyButton.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.kai.setTitle(NSLocalizedString("开", comment: ""), for: UIControlState())
        self.guan.setTitle(NSLocalizedString("关", comment: ""), for: UIControlState())
        self.kai.setTitle(NSLocalizedString("开", comment: ""), for: UIControlState())
        self.guan.setTitle(NSLocalizedString("关", comment: ""), for: UIControlState())
        self.butting.setTitle(NSLocalizedString("停", comment: ""), for: UIControlState())
        self.studyButton.setTitle(NSLocalizedString("学习", comment: ""), for: UIControlState())
        
        
        
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
            //app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
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
    
    @IBOutlet weak var butting: UIButton!
    
    @IBAction func ting(_ sender: AnyObject) {
        self.commad =  50
        let address = self.equip?.equipID
        if isMoni
        {
            self.equip?.status = String(self.commad )
            // self.delayBtn.setTitle(self.equip?.delay, forState: UIControlState.Normal)
            app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
            self.kai.layer.borderColor = UIColor.white.cgColor
            self.studyButton.layer.borderColor = UIColor.white.cgColor
            self.guan.layer.borderColor = UIColor.white.cgColor
            self.butting.layer.borderColor = UIColor.green.cgColor
            return
        }
        let dic = ["deviceAddress":address!,"command":self.commad] as [String : Any]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { (back) -> () in
            self.btn.isSelected = true
            print(back)
        }
        self.butting.backgroundColor = UIColor.init(red: 14.0/255.0, green: 173.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.butting.setTitleColor(UIColor.white, for: UIControlState())
        self.guan.backgroundColor = UIColor.white
        self.guan.setTitleColor(UIColor.black, for: UIControlState())
        self.kai.backgroundColor = UIColor.white
        self.kai.setTitleColor(UIColor.black, for: UIControlState())
        self.studyButton.backgroundColor = UIColor.white
        self.studyButton.setTitleColor(UIColor.black, for: UIControlState())
    }
    @IBAction func open(_ sender: AnyObject) {
        self.commad =  100
        let address = self.equip?.equipID
        if isMoni
        {
            self.equip?.status = String(self.commad )
            
            app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
            self.kai.layer.borderColor = UIColor.green.cgColor
            self.guan.layer.borderColor = UIColor.white.cgColor
            self.studyButton.layer.borderColor = UIColor.white.cgColor
            self.butting.layer.borderColor = UIColor.white.cgColor
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
        self.butting.backgroundColor = UIColor.white
        self.butting.setTitleColor(UIColor.black, for: UIControlState())
        self.studyButton.backgroundColor = UIColor.white
        self.studyButton.setTitleColor(UIColor.black, for: UIControlState())
        
    }
    
    @IBAction func study(_ sender: AnyObject) {
        self.commad =  150
        let address = self.equip?.equipID
        if isMoni
        {
            self.equip?.status = String(self.commad )
            
            app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
            self.studyButton.layer.borderColor = UIColor.green.cgColor
            self.kai.layer.borderColor = UIColor.white.cgColor
            self.guan.layer.borderColor = UIColor.white.cgColor
            self.butting.layer.borderColor = UIColor.white.cgColor
            return
        }
        let dic = ["deviceAddress":address!,"command":self.commad] as [String : Any]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { (back) -> () in
            self.btn.isSelected = true
            print(back)
        }
        
        self.studyButton.backgroundColor = UIColor.init(red: 14.0/255.0, green: 173.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.studyButton.setTitleColor(UIColor.white, for: UIControlState())
        self.guan.backgroundColor = UIColor.white
        self.guan.setTitleColor(UIColor.black, for: UIControlState())
        self.kai.backgroundColor = UIColor.white
        self.kai.setTitleColor(UIColor.black, for: UIControlState())
        self.butting.backgroundColor = UIColor.white
        self.butting.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    @IBAction func shut(_ sender: AnyObject) {
        self.commad =  0
        let address = self.equip?.equipID
        if isMoni
        {
            self.equip?.status = String(self.commad )
            app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
            // self.delayBtn.setTitle(self.equip?.delay, forState: UIControlState.Normal)
            self.guan.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            self.guan.layer.borderColor = UIColor.green.cgColor
            self.kai.layer.borderColor = UIColor.white.cgColor
            self.studyButton.layer.borderColor = UIColor.white.cgColor
            self.butting.layer.borderColor = UIColor.white.cgColor
            return
        }
        let dic = ["deviceAddress":address!,"command":self.commad ] as [String : Any]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { (back) -> () in
            
            self.btn.isSelected = false
            print(back)
        }
        self.guan.backgroundColor = UIColor.init(red: 14.0/255.0, green: 173.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.guan.setTitleColor(UIColor.white, for: UIControlState())
        self.butting.backgroundColor = UIColor.white
        self.butting.setTitleColor(UIColor.black, for: UIControlState())
        self.kai.backgroundColor = UIColor.white
        self.kai.setTitleColor(UIColor.black, for: UIControlState())
        self.studyButton.backgroundColor = UIColor.white
        self.studyButton.setTitleColor(UIColor.black, for: UIControlState())
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setModel(_ e:Equip){
        
        self.equip = e
        self.nameLabel.text = e.name
        btn.setImage(UIImage.init(imageLiteralResourceName:self.equip!.icon), for: UIControlState())
        // btn.setImage(UIImage(named:"dark"), forState: UIControlState.Selected)
        
        if isMoni
        {
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
            //self.equip?.status = String(self.commad)
            if self.equip?.status == "0"{
                self.studyButton.layer.borderColor = UIColor.white.cgColor
                self.guan.layer.borderColor = UIColor.green.cgColor
                self.kai.layer.borderColor = UIColor.white.cgColor
                self.butting.layer.borderColor = UIColor.white.cgColor
                self.commad = 0
            }else if self.equip?.status == "100"{
                self.studyButton.layer.borderColor = UIColor.white.cgColor
                self.guan.layer.borderColor = UIColor.white.cgColor
                self.kai.layer.borderColor = UIColor.green.cgColor
                self.butting.layer.borderColor = UIColor.white.cgColor
                self.commad = 100
            }else if self.equip?.status == "50"{
                self.studyButton.layer.borderColor = UIColor.white.cgColor
                self.guan.layer.borderColor = UIColor.white.cgColor
                self.kai.layer.borderColor = UIColor.white.cgColor
                self.butting.layer.borderColor = UIColor.green.cgColor
                self.commad = 50
            }else if self.equip?.status == "150"{
                self.studyButton.layer.borderColor = UIColor.green.cgColor
                self.guan.layer.borderColor = UIColor.white.cgColor
                self.kai.layer.borderColor = UIColor.white.cgColor
                self.butting.layer.borderColor = UIColor.white.cgColor
                self.commad = 150
            }
            //  app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
            self.delayBtn.isHidden = false
            // self.delayBtn .setTitle(self.equip?.delay, forState: UIControlState.Normal)
            return
        }
        self.delayBtn.isHidden = true
        self.butting.isHidden = false
    }
    
    
}
