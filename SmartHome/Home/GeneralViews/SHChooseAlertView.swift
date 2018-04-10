//
//  SHChooseAlertView.swift
//  SmartHome
//
//  Created by kincony on 15/12/31.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class SHChooseAlertView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var themeClolor = UIColor.gray
    var dataSource = [String]()
    
    fileprivate var titleView: UIView?
    fileprivate var titleLabel: UILabel?
    fileprivate var cancleBtn: UIButton?
    fileprivate var confirmBtn: UIButton?
    fileprivate var alertView: UIView = UIView()
    fileprivate var background: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    fileprivate let pickerView = UIPickerView()
    
    var selectItem: String?
    var selectRow: Int = 0
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String?, dataSource: [String], cancleButtonTitle: String?, confirmButtonTitle: String?) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.dataSource = dataSource
        self.selectItem = dataSource.first
        
        
        self.backgroundColor = UIColor.clear
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        background.addSubview(alertView)
        alertView.backgroundColor = UIColor.white
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height * 0.88, height: UIScreen.main.bounds.height * 0.88 * 0.64)
        default:
            alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.88, height: UIScreen.main.bounds.width * 0.88 * 0.64)
        }
        alertView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height * 0.234))
        titleView!.tag = 477
        titleView!.backgroundColor = themeClolor
        titleLabel = UILabel(frame: CGRect(x: 15, y: 2, width: titleView!.frame.width - 30, height: titleView!.frame.height - 4))
        titleLabel!.tag = 477
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.text = title
        titleLabel!.font = UIFont.systemFont(ofSize: 19)
        titleLabel!.textColor = UIColor.white
        titleView!.addSubview(titleLabel!)
        alertView.addSubview(titleView!)

        cancleBtn = UIButton(type: UIButtonType.custom)
        cancleBtn!.frame = CGRect(x: 0, y: 0, width: alertView.frame.width * 0.24, height: alertView.frame.height * 0.215)
        cancleBtn?.backgroundColor = themeClolor
        if cancleButtonTitle != nil {
            cancleBtn!.setTitle(cancleButtonTitle, for: UIControlState())
        } else {
            cancleBtn!.setTitle(NSLocalizedString("取消", comment: ""), for: UIControlState())
        }
        
        cancleBtn!.layer.cornerRadius = 4
        cancleBtn!.layer.masksToBounds = true
        cancleBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancleBtn!.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        cancleBtn!.addTarget(self, action: #selector(SHChooseAlertView.touchButton(_:)), for: UIControlEvents.touchUpInside)
        alertView.addSubview(cancleBtn!)
        
        confirmBtn = UIButton(type: UIButtonType.custom)
        confirmBtn!.frame = CGRect(x: alertView.frame.width * 0.76, y: 0, width: alertView.frame.width * 0.24, height: alertView.frame.height * 0.215)
        confirmBtn?.backgroundColor = themeClolor
        
        if confirmButtonTitle != nil {
            confirmBtn!.setTitle(confirmButtonTitle, for: UIControlState())
        } else {
            confirmBtn!.setTitle(NSLocalizedString("确定", comment: ""), for: UIControlState())
        }
        confirmBtn!.layer.cornerRadius = 4
        confirmBtn!.layer.masksToBounds = true
        confirmBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmBtn!.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        confirmBtn!.addTarget(self, action: #selector(SHChooseAlertView.touchButton(_:)), for: UIControlEvents.touchUpInside)
        alertView.addSubview(confirmBtn!)
        
        pickerView.frame = CGRect(x: 0, y: alertView.frame.height * 0.215, width: alertView.frame.width, height: alertView.frame.height * 0.785)
        pickerView.delegate = self
        pickerView.dataSource = self
        alertView.addSubview(pickerView)
        
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
    
    fileprivate var action: ((_ alert: SHChooseAlertView, _ buttonIndex: Int) -> ())?
    
    func alertAction(_ action: @escaping ((_ alert: SHChooseAlertView, _ buttonIndex: Int) -> ())) {
        self.action = action
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectItem = dataSource[row]
        selectRow = row
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2
        animation.toValue = 1
        animation.duration = 0.125
        self.layer.add(animation, forKey: "show")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height * 0.77, height: UIScreen.main.bounds.height * 0.77 * 0.64)
        default:
            alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.77, height: UIScreen.main.bounds.width * 0.77 * 0.64)
        }
        alertView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
