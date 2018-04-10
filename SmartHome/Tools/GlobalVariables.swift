//
//  GlobalVariables.swift
//  SmartHome
//
//  Created by kincony on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
//常用

var tableSideViewDataSource:NSMutableArray = NSMutableArray(capacity: 10)

var ScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
var ScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var ScreenFrame: CGRect {
    return UIScreen.main.bounds
}

let systemColor = UIColor.init(red: 69/255.0, green: 167/255.0, blue: 251/255.0, alpha: 1.0)

let mygrayColor = UIColor.groupTableViewBackground

let themeColors = UIColor(RGB: 0x2fceaa, alpha: 1)

let app = (UIApplication.shared.delegate) as! AppDelegate
//let mainColor=UIColor(RGB: 0x2fceaa,alpha: 1)
let mainColor=UIColor(patternImage: navBgImage!)
//app.deviceToken 手机的cid
//图片
//输入框背景
let textImage:UIImage? = UIImage(named: "输入框背景.png")
//保证图片拉伸不变形
let textBgImage:UIImage?=textImage!.stretchableImage(withLeftCapWidth: (Int)(textImage!.size.width/2), topCapHeight:(Int)(textImage!.size.height/2))
//导航栏背景
let navBgImage:UIImage? = UIImage(named: "导航栏L")
//登陆界面背景
let loginBgImage:UIImage? = UIImage(named: "loginBg.png")
//登陆注册等按钮背景
let btnBgImage:UIImage? = UIImage(named: "登陆.png")
 //首页
let homeIcon:UIImage? = UIImage(named: "首页未按.png")
let homeIconSelected:UIImage? = UIImage(named: "首页.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//情景模式
let modelIcon:UIImage? = UIImage(named: "商圈未按.png")
let modelIconSelected:UIImage? = UIImage(named: "商圈.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//语音
let voiceIcon:UIImage? = UIImage(named: "maikefeng.png")
let voiceIconSelected:UIImage? = UIImage(named: "maikefeng.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//商城
let mallIcon:UIImage? = UIImage(named: "购物未按.png")
let mallIconSelected:UIImage? = UIImage(named: "购物.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//社区
let commIcon:UIImage? = UIImage(named: "shequmoren")
let commIconSelected:UIImage? = UIImage(named: "shequxuanz")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)

public enum SetUserType:Int{
    case Reg
    case Reset
    case Modify
}
