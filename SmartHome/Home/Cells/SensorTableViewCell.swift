//
//  SensorTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/6/7.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell,UIActionSheetDelegate {
    
    @IBOutlet weak var Sjg: UILabel!
    @IBOutlet weak var Simg: UIButton!
    @IBOutlet weak var Sname: UILabel!
    var equip:Equip?
    var longPressGR:UILongPressGestureRecognizer?
    override func awakeFromNib() {
        super.awakeFromNib()
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(SensorTableViewCell.longPress(_:)))
        
        longPressGR!.minimumPressDuration = 0.5;
        self.Simg.addGestureRecognizer(longPressGR!)
        self.Sjg.isHidden = true
        // Initialization code
    }
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
         if sender.state == UIGestureRecognizerState.began{
        let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("学习", comment: ""))
        actionSheet?.show(in: self.superview!)
        }
    }
    
    //长按事件
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //取消
            break
        case 1:
            let dic = ["deviceAddress":self.equip!.equipID,"deviceCode":self.equip!.hostDeviceCode]
            BaseHttpService.sendRequestAccess(studysensor, parameters: dic as NSDictionary) { (back) -> () in
                
            }
            //学习
            break

        default:
            break
        }
       
    }

    func setModel(_ e:Equip){
        self.equip = e
        self.Simg.setImage(UIImage.init(imageLiteralResourceName:self.equip!.icon), for: UIControlState())
        self.Sname.text = self.equip?.name
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
