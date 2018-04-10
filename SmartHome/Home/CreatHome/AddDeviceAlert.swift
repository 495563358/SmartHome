//
//  AddDeviceAlert.swift
//  SmartHome
//
//  Created by kincony on 15/12/23.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class AddDeviceAlert: UIView {

    var alertImage: UIView = UIView() {
        didSet {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                alertImage.frame = CGRect(x: ScreenWidth / 10 * 3, y: ScreenHeight * 0.3, width: ScreenWidth / 10 * 4, height: ScreenWidth / 10 * 4 * 0.65)
            default:
                alertImage.frame = CGRect(x: ScreenWidth / 7, y: ScreenHeight * 0.352, width: ScreenWidth / 7 * 5, height: ScreenWidth / 7 * 5 * 0.65)
            }
            
        }
    }
    var alert: UIImageView = UIImageView()
    var alertText: UILabel = UILabel()
    
    var exitBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    convenience init(success: Bool) {
        self.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.backgroundColor = UIColor(RGB: 0xb1b1b1, alpha: 0.4)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            alertImage.frame = CGRect(x: ScreenWidth / 10 * 3, y: ScreenHeight * 0.3, width: ScreenWidth / 10 * 4, height: ScreenWidth / 10 * 4 * 0.65)
        default:
            alertImage.frame = CGRect(x: ScreenWidth / 7, y: ScreenHeight * 0.352, width: ScreenWidth / 7 * 5, height: ScreenWidth / 7 * 5 * 0.65)
        }
        if success {
            alert.image = UIImage(named: "添加设备成功")
            alertText.text = NSLocalizedString("添加设备成功", comment: "")
        } else {
            alert.image = UIImage(named: "添加设备失败")
            alertText.text = NSLocalizedString("添加设备失败", comment: "")
        }
        alert.frame = CGRect(x: 0, y: 0, width: alertImage.frame.height * 0.3, height: alertImage.frame.height * 0.3)
        alert.center = CGPoint(x: alertImage.frame.width / 2, y: alertImage.frame.height / 2 - alert.bounds.height / 4)
        alertText.frame = CGRect(x: 0, y: 0, width: alertImage.frame.width * 0.45, height: alertImage.frame.height * 0.16)
        alertText.center = CGPoint(x: alertImage.frame.width / 2, y: alertImage.frame.height / 2 +  alertText.bounds.height)
        alertText.textColor = UIColor.white
        alertImage.addSubview(alert)
        alertImage.addSubview(alertText)
        
        exitBtn.frame = CGRect(x: alertImage.frame.size.width - 43, y: 2, width: 40, height: 40)
        exitBtn.setImage(UIImage(named: "添加设备提示X号普通"), for: UIControlState())
        exitBtn.setImage(UIImage(named: "添加设备提示X号按下"), for: UIControlState.highlighted)
        exitBtn.addTarget(self, action: #selector(AddDeviceAlert.handleExit(_:)), for: UIControlEvents.touchUpInside)
        alertImage.backgroundColor = UIColor(RGB: 0x2fceaa, alpha: 1)
        alertImage.addSubview(exitBtn)
        self.addSubview(alertImage)
    }
    
    @objc func handleExit(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2
        animation.toValue = 1
        animation.duration = 0.125
        animation.isRemovedOnCompletion = true
        self.layer.add(animation, forKey: "show")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            alertImage.frame = CGRect(x: ScreenWidth / 7, y: ScreenHeight * 0.352, width: ScreenWidth / 7 * 5, height: ScreenWidth / 7 * 5 * 0.65)
            exitBtn.frame = CGRect(x: alertImage.frame.size.width - 43, y: 2, width: 40, height: 40)
        case .landscapeLeft, .landscapeRight:
            alertImage.frame = CGRect(x: ScreenWidth / 10 * 3, y: ScreenHeight * 0.3, width: ScreenWidth / 10 * 4, height: ScreenWidth / 10 * 4 * 0.65)
            exitBtn.frame = CGRect(x: alertImage.frame.size.width - 43, y: 2, width: 40, height: 40)
        default:
            break
        }
        
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
