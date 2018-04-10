//
//  Tools.swift
//  SmartHome
//
//  Created by sunzl on 15/12/10.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit

//MARK:坐标和宽高
public extension UIView {
    var x : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width : CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var hight : CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}
//MARK:原点和大小
public extension UIView {
    var origin : CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
}
//MARK:位置信息
public extension UIView {
    var bottomRight : CGPoint {
        let x : CGFloat = self.x + self.width
        let y : CGFloat = self.y + self.hight
        return CGPoint(x: x, y: y)
    }
    
    var bottomLeft : CGPoint {
        let x : CGFloat = self.x
        let y : CGFloat = self.y + self.hight
        return CGPoint(x: x, y: y)
    }
    
    var topRight : CGPoint {
        let x : CGFloat = self.x + self.width
        let y : CGFloat = self.y
        return CGPoint(x: x, y: y)
    }
    var top : CGFloat {
        get {
            return self.y
        }
        set {
            self.y = newValue
        }
    }
    
    var left : CGFloat {
        get {
            return self.x
        }
        set {
            self.x = newValue
        }
    }
    
    var bottom : CGFloat {
        get {
            return self.y + self.hight
        }
        set {
            self.y = newValue - self.hight
        }
    }
    
    var right : CGFloat {
        get {
            return self.x + self.width
        }
        set {
            self.x = newValue - self.width
        }
    }
}

extension UIButton {
    //按钮位置扩展
    @objc func set(image anImage: UIImage?, title: String,
                   titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    fileprivate func positionLabelRespectToImage(_ title: String, position: UIViewContentMode,
                                                 spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}

func showMsg(msg:String){
 UIAlertView(title: msg, message: nil, delegate: nil, cancelButtonTitle: NSLocalizedString("我知道了", comment: "")).show()

}

func validateMobile(mobile:String)->Bool
{
    let regex:NSRegularExpression!
   
    do{ // - 1、创建规则
        //手机号以1开头，十个 \d 数字字符
        let pattern:String = "^((13[0-9])|(15[0-9])|(18[0-9]))\\d{8}$"
        // - 2、创建正则表达式对象
        regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex.matches(in: mobile, options:NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0,mobile.characters.count))
          return matches.count > 0
    }
    catch {
        print(error)
    }
  
    return false
}

//手机号码验证

//{
//   
//        * = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}
