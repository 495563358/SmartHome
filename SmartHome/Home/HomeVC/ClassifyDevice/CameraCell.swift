//
//  CameraCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell ,UIAlertViewDelegate{
    @IBOutlet var offlineIcon: UIImageView!
    var equip:Equip?
    var passWord:UITextField?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCameraInfo(_ cameraInfo:EZCameraInfo)
    {
    
    
    if (cameraInfo.isOnline)
    {
     self.offlineIcon.isHidden = true
    }
    else
    {
     self.offlineIcon.isHidden = false
    }
    
        
        self.nameLabel.text = cameraInfo.cameraName
  
    self.icon.sd_setImage(with: URL(string: cameraInfo.picUrl))

    }
    func setModel(_ e:Equip){
    self.equip = e
    }

   
    @IBAction func tap(_ sender: AnyObject) {
        let alert  = UIAlertView(title: "请输入验证码", message: "", delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), otherButtonTitles: NSLocalizedString("确定", comment: ""))
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
    
 
    passWord = alert.textField(at: 0)
    passWord?.keyboardType = UIKeyboardType.numbersAndPunctuation
    alert.show()
    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
       if passWord?.text!.trimString() == ""
       {
        showMsg(msg: NSLocalizedString("密码", comment: ""))
        return
        }
        if buttonIndex == 1{
            let dic:NSDictionary = ["roomCode":self.equip!.roomCode,
                "deviceAddress":self.equip!.equipID,
                "nickName":self.equip!.name,
                "ico":"list_camera",
                "validationCode":passWord!.text!,
                "deviceType":"101",
                "deviceCode":"commonsxt"]
            BaseHttpService.sendRequestAccess(addEq_do, parameters:dic) { (response) -> () in
                print("获取用户信息=\(response)")
                self.equip!.hostDeviceCode = "commonsxt";
                self.equip!.num = self.passWord!.text!;
                self.equip!.saveEquip()
                EZOpenSDK.addDevice(self.equip!.num, deviceCode:  self.equip?.equipID, completion: { (err) -> Void in
                    
                })
                EZOpenSDK.setValidateCode(self.equip!.num, forDeviceSerial: self.equip?.equipID)
                showMsg(msg: NSLocalizedString("添加成功", comment: ""))
            }
        }

    }
    

}
