//
//  SetSenCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/23.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SetSenCelScene: UITableViewCell {
    var nameLeab:UILabel!
 
    var setName:UIButton!
    var studyBut:UIButton!
    
    var  model:SensorModel?
    
    func setinit(){
        self.nameLeab.text = self.model?.SensorName
    }
    
     var dic1 = [String:[String:[String]]]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "a")
        let scalew = ScreenWidth / 320
        let scaleh = ScreenHeight / 568
        let imag = UIImageView(image: UIImage(named: "安防"))
        imag.frame = CGRect(x: 5*scalew, y: 5*scaleh, width: 35*scalew, height: 40*scaleh)
        
        nameLeab = UILabel(frame: CGRect(x: imag.frame.size.width + 10*scalew, y: 5*scaleh, width: 65*scalew, height: 40*scaleh))
        nameLeab.text = " "
        nameLeab.font = UIFont.systemFont(ofSize: 15)
        nameLeab.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        
        var setNameX = nameLeab.frame.size.width + imag.frame.size.width + 5*scalew
        setNameX += 10*scalew
        let setNameY = nameLeab.frame.size.height+5*scaleh-20*scaleh
        setName = UIButton(frame:CGRect(x: setNameX, y: setNameY, width: 40*scalew, height: 20*scaleh))
        setName.setTitle(NSLocalizedString("修改名称", comment: ""), for: UIControlState())
        setName.addTarget(self, action: #selector(SetSenCelScene.setName(_:)), for: .touchUpInside)
        //setName.backgroundColor = UIColor.redColor()
        setName.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        setName.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0), for: UIControlState())
        let setNameleb = UILabel(frame:CGRect(x: setNameX, y: nameLeab.frame.size.height+5*scaleh-3*scaleh, width: 40*scalew, height: 1*scaleh))
        setNameleb.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        
        studyBut = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-60*scalew,y: 10*scaleh,width: 40*scalew, height: 30*scaleh))
        studyBut.setTitle(NSLocalizedString("学习", comment: ""), for: UIControlState())
        studyBut.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0), for: UIControlState())
        studyBut.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        studyBut.backgroundColor = UIColor.green
        studyBut.layer.cornerRadius = 10.0
        studyBut.tag = 7
        studyBut.addTarget(self, action: #selector(SetSenCelScene.butswith(_:)), for: .touchUpInside)
        
        
        self.addSubview(imag)
        self.addSubview(nameLeab)
        
        self.addSubview(setNameleb)
        self.addSubview(setName)
        self.addSubview(studyBut)
        
        setName.isHidden = true
        setNameleb.isHidden = true
    }
    
    @objc func butswith(_ but:UIButton){
    
        let dic = ["deviceAddress":self.model!.SensorID,"deviceCode":self.model!.sensorhost]
        BaseHttpService.sendRequestAccess(studysensor, parameters: dic as NSDictionary) { (back) -> () in
            
        }
    }
    
    @objc func setName(_ but:UIButton){
        let alertController = UIAlertController(title:NSLocalizedString("请输入名称", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "名称"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("好的",comment:""), style: .default,
            handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let login = alertController.textFields!.first! as UITextField
                let data = ["deviceCode":self.model!.sensorhost,
                            "deviceAddress":self.model!.SensorID,
                            "sensorName":login.text! ]
                BaseHttpService.sendRequestAccess(setSensorName, parameters: data as NSDictionary, success: { (arr) -> () in
                    self.nameLeab.text = login.text
               })
                print("用户名：\(login.text)")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.parentController()?.present(alertController, animated: true, completion: nil)
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
       required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
