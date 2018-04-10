//
//  SHSegement.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class SHSegement: UIView {
    
    enum Click {
        case left, right
    }
    
    fileprivate let selectLayer = CALayer()
    fileprivate let separa = CALayer()
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    override func layoutSubviews() {
//        super.layoutSubviews()
        selectLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width / 2 , height: self.bounds.height)
        selectLayer.backgroundColor = UIColor.white.cgColor
        self.layer.addSublayer(selectLayer)
        
        separa.frame = CGRect(x: self.bounds.width / 2, y: 0, width: 1, height: self.bounds.height)
        separa.backgroundColor = UIColor.gray.cgColor
        self.layer.addSublayer(separa)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        leftLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width / 2, height: self.bounds.height)
        leftLabel.textAlignment = NSTextAlignment.center
        leftLabel.font = UIFont.systemFont(ofSize: 13)
        leftLabel.textColor = UIColor.gray
        self.addSubview(leftLabel)
        
        rightLabel.frame = CGRect(x: self.bounds.width / 2, y: 0, width: self.bounds.width / 2, height: self.bounds.height)
        rightLabel.textAlignment = NSTextAlignment.center
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        rightLabel.textColor = UIColor.gray
        self.addSubview(rightLabel)
        
    }

    fileprivate var leftAction: (()->())?
    fileprivate var rightAction: (()->())?
    
    func selectAction(_ click: Click, action: @escaping ()->()) {
        switch click {
        case .left:
            leftAction = action
        case .right:
            rightAction = action
        }
    }
    func selected(_ index:Int) {
          selectLayer.frame = CGRect( x: self.bounds.width / 2 * CGFloat( index), y: 0, width: self.bounds.width / 2 , height: self.bounds.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        let point = touch?.location(in: self)
        if point?.x < self.bounds.width / 2 {
            selectLayer.frame = CGRect(x: 0, y: 0, width: frame.width / 2, height: frame.height)
            leftAction?()
        } else {
            selectLayer.frame = CGRect(x: frame.width / 2, y: 0, width: frame.width / 2, height: frame.height)
            rightAction?()
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
