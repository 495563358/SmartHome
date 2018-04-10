//
//  SHAlertView.swift
//  SHAlertView
//
//  Created by kincony on 15/12/17.
//  Copyright © 2015年 Kincony. All rights reserved.
//

import UIKit




var l_ScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
var l_ScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

class SHAlertView: UIView {
    
    var themeClolor: UIColor = UIColor.gray
    
    fileprivate var titleView: UIView?
    fileprivate var titleLabel: UILabel?
    fileprivate var detailLabel: UILabel?
    fileprivate var cancleBtn: UIButton?
    fileprivate var confirmBtn: UIButton?
    
    fileprivate var alertView: UIView = UIView()
    fileprivate var background: UIView = UIView(frame: CGRect(x: 0, y: 0, width: l_ScreenWidth, height: l_ScreenHeight))
    
    fileprivate override init(frame: CGRect) {
         super.init(frame: frame)
    }
    
    convenience init(title: String?, message: String?, cancleButtonTitle: String?, confirmButtonTitle: String?) {
        self.init(frame: CGRect(x: 0, y: 0, width: l_ScreenWidth, height: l_ScreenHeight))
        
        self.backgroundColor = UIColor.clear
        
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        background.addSubview(alertView)
        
        alertView.backgroundColor = UIColor.white
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            alertView.frame = CGRect(x: 0, y: 0, width: l_ScreenHeight * 0.77, height: l_ScreenHeight * 0.77 * 0.64)
        default:
            alertView.frame = CGRect(x: 0, y: 0, width: l_ScreenWidth * 0.77, height: l_ScreenWidth * 0.77 * 0.64)
        }
         
        alertView.center = CGPoint(x: l_ScreenWidth / 2, y: l_ScreenHeight / 2)
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height * 0.234))
        titleView!.tag = 477
        titleView!.backgroundColor = themeClolor
        titleLabel = UILabel(frame: CGRect(x: 15, y: 2, width: titleView!.frame.width - 30, height: titleView!.frame.height - 4))
        titleLabel!.tag = 477
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.text = title
        titleLabel!.font = UIFont.systemFont(ofSize: 20)
        titleLabel!.textColor = UIColor.white
        titleView!.addSubview(titleLabel!)
        alertView.addSubview(titleView!)
        
        detailLabel = UILabel(frame: CGRect(x: alertView.frame.width * 0.05, y: alertView.frame.height * 0.281, width: alertView.frame.width * 0.9, height: alertView.frame.height * 0.390))
        detailLabel!.tag = 478
        detailLabel!.textAlignment = NSTextAlignment.center
        detailLabel!.text = message
        detailLabel!.font = UIFont.systemFont(ofSize: 17)
        detailLabel!.textColor = UIColor.lightGray
        alertView.addSubview(detailLabel!)
        
        cancleBtn = UIButton(type: UIButtonType.custom)
        cancleBtn!.frame = CGRect(x: alertView.frame.width * 0.09, y: alertView.frame.height * 0.718, width: alertView.frame.width * 0.32, height: alertView.frame.height * 0.188)
        cancleBtn?.backgroundColor = themeClolor
        if cancleButtonTitle != nil {
            cancleBtn!.setTitle(cancleButtonTitle, for: UIControlState())
        } else {
            cancleBtn!.setTitle(NSLocalizedString("取消", comment: ""), for: UIControlState())
        }
        
        cancleBtn!.layer.cornerRadius = 4
        cancleBtn!.layer.masksToBounds = true
        cancleBtn!.addTarget(self, action: #selector(SHAlertView.touchButton(_:)), for: UIControlEvents.touchUpInside)
        alertView.addSubview(cancleBtn!)
        
        confirmBtn = UIButton(type: UIButtonType.custom)
        confirmBtn!.frame = CGRect(x: alertView.frame.width * 0.6, y: alertView.frame.height * 0.718, width: alertView.frame.width * 0.32, height: alertView.frame.height * 0.188)
        confirmBtn?.backgroundColor = themeClolor
        
        if confirmButtonTitle != nil {
            confirmBtn!.setTitle(confirmButtonTitle, for: UIControlState())
        } else {
            confirmBtn!.setTitle(NSLocalizedString("确定", comment: ""), for: UIControlState())
        }
        confirmBtn!.layer.cornerRadius = 4
        confirmBtn!.layer.masksToBounds = true
        confirmBtn!.addTarget(self, action: #selector(SHAlertView.touchButton(_:)), for: UIControlEvents.touchUpInside)
        alertView.addSubview(confirmBtn!)
        
        
        self.addSubview(background)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func touchButton(_ sender: UIButton) {
        if sender == cancleBtn {
            dismiss()
            action?(self, 0)
        } else if sender == confirmBtn {
            action?(self, 1)
            dismiss()
        }
    }
    
    fileprivate var action: ((_ alert: SHAlertView, _ buttonIndex: Int) -> ())?
    
    func alertAction(_ action: @escaping ((_ alert: SHAlertView, _ buttonIndex: Int) -> ())) {
        self.action = action
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func dismiss() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
        
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2
        animation.toValue = 1
        animation.duration = 0.125
        background.layer.add(animation, forKey: "show")
        
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        background.frame = CGRect(x: 0, y: 0, width: l_ScreenWidth, height: l_ScreenHeight)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            alertView.frame = CGRect(x: 0, y: 0, width: l_ScreenHeight * 0.77, height: l_ScreenHeight * 0.77 * 0.64)
        default:
            alertView.frame = CGRect(x: 0, y: 0, width: l_ScreenWidth * 0.77, height: l_ScreenWidth * 0.77 * 0.64)
        }
        alertView.center = CGPoint(x: l_ScreenWidth / 2, y: l_ScreenHeight / 2)
        titleView!.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height * 0.234)
        titleLabel!.frame = CGRect(x: 15, y: 2, width: titleView!.frame.width - 30, height: titleView!.frame.height - 4)
        detailLabel!.frame = CGRect(x: alertView.frame.width * 0.05, y: alertView.frame.height * 0.281, width: alertView.frame.width * 0.9, height: alertView.frame.height * 0.390)
        cancleBtn!.frame = CGRect(x: alertView.frame.width * 0.09, y: alertView.frame.height * 0.718, width: alertView.frame.width * 0.32, height: alertView.frame.height * 0.188)
        confirmBtn!.frame = CGRect(x: alertView.frame.width * 0.6, y: alertView.frame.height * 0.718, width: alertView.frame.width * 0.32, height: alertView.frame.height * 0.188)
        
    }
    
}
