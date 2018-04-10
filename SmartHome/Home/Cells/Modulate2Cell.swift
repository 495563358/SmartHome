//
//  ModulateCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class Modulate2Cell: UITableViewCell {
  @IBOutlet var delayBtn: UIButton!
    @IBOutlet var iconImg: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var slider: UISlider!
    var index:IndexPath?
    var equip:Equip?
    var isMoni:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.setThumbImage(UIImage(named: "silder"), for: UIControlState())
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func valueChangeTap(_ sender: UISlider) {
       print("------\(self.index?.row)")
       var commad = Int(sender.value * 100)
        print(sender.value)
        print(commad)
        
        if commad > 0 && commad <= 25
        {
            commad = 25
            sender.value = 25 * 0.01
        }
        else if commad > 25 && commad <= 50
        {
            commad = 50
            sender.value = 50 * 0.01
        }
        else if commad > 50 && commad <= 75
        {
            commad = 75
            sender.value = 75 * 0.01
        }
        else if commad > 75 && commad <= 100
        {
            commad = 100
            sender.value = 100 * 0.01
        }
        else if commad == 0
        {
            commad = 100
            sender.value = 0 * 0.01
        }
        if isMoni
        {
             (app.modelEquipArr[(self.index?.row)!] as! Equip).status = String(commad)
            return
        }
        let address = self.equip?.equipID
        let dic = ["deviceAddress":address!,"command":commad/*,"keyvalue":1,"":""*/] as [String : Any]
        print("2=\(dic)")
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic as NSDictionary) { (back) -> () in
            print(back)
        }
    }
    func setModel(_ e:Equip){
        self.equip = e
        self.iconImg.image = UIImage(named: e.icon)
        self.iconImg.contentMode = .bottom
        
        self.nameLabel.text = e.name
      
        if isMoni
        {  print("------\(self.index?.row)")
            if e.status != ""{
                self.slider.value = Float(e.status)! * 0.01
            }
            self.equip?.status = String(Int(slider.value * 100))
             app.modelEquipArr.replaceObject(at: (self.index?.row)!, with: self.equip!)
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
            self.delayBtn.isHidden = false
            return
        }
        if e.status != ""{
            self.slider.value = Float(e.status)! * 0.01
        }
        self.delayBtn.isHidden = true
        
       
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
    
}
