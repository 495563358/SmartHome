//
//  Helper.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MyAlert : UIAlertView{
    override func dismiss(withClickedButtonIndex buttonIndex: Int, animated: Bool) {
        
    }
    func dismiss(){
        super.dismiss(withClickedButtonIndex: 0, animated: true)
    }
}
//根据颜色返回图片
func imageWithColor(color:UIColor)->UIImage
 {
    let rect:CGRect = CGRect(x:0.0, y:0.0, width:1.0, height:1.0)
    UIGraphicsBeginImageContext(rect.size);
    let context:CGContext = UIGraphicsGetCurrentContext()!;
    context.setFillColor(color.cgColor);
    context.fill(rect);
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;

}

//颜色的便利构造器
extension UIColor {
    convenience init(RGB: Int, alpha: Float) {
        self.init(red: CGFloat((RGB & 0xFF0000) >> 16) / CGFloat(255), green: CGFloat((RGB & 0xFF00) >> 8) / CGFloat(255), blue: CGFloat(RGB & 0xFF) / CGFloat(255), alpha: CGFloat(alpha))
    }
}
extension String{

    func trimString()->String!
    {
        let str:String!=self.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return str;
    }
    var md5 : String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);

        CC_MD5(str!, strLen, result);

        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deinitialize();

        return String(format: hash as String)
    }
 


}


func setDefault(phone:String,pwd:String){

    var userlist:[String:String]? = UserDefaults.standard.object(forKey: "userList") as? [String:String]
    if userlist == nil {
         userlist = [:]
    }
     userlist![phone] = pwd
    UserDefaults.standard.set(userlist, forKey: "userList")
    print(userlist as Any)
   
    
}

func getRemoveIndex<AnyObject: Equatable>(value: AnyObject, array: [AnyObject]) -> [Int]{
    var indexArray = [Int]()
    
    var correctArray = [Int]()
    
    //获取指定值在数组中的索引
    
    for (index,_) in array.enumerated() {
        
        if array[index] == value {
            
            indexArray.append(index)
            
        }
        
    }
    //计算正确的删除索引
    
    for (index, originIndex) in indexArray.enumerated(){
        
        //指定值索引减去索引数组的索引
        
        let correctIndex = originIndex - index
        
        
        
        //添加到正确的索引数组中
        
        correctArray.append(correctIndex)
        
    }
    
    return correctArray
    
}
func getIconByType(type:String)->String
{
    var icon :String = "未知"
    switch type{
    case "1":
        icon = "开关灯泡"
        break
    case "2":
        icon = "窗帘"
        break
    case "4":
        icon = "调光灯泡"
        break
    default:break
        
    }
    return icon


}
typealias CompleteUpdateDeviceInfo = () -> ()
func updateDeviceInfo(complete:@escaping CompleteUpdateDeviceInfo){
    
     print("更新设备信息")

    BaseHttpService.sendRequestAccess(classifyEquip_do, parameters: [:]) { (data) -> () in
        dataDeal.clearEquipTable()
        print(data)

        if data.count != 0{
           //设备
            let arr = data as! [[String : AnyObject]]
            for e in arr {
                let equip = Equip(equipID: e["deviceAddress"] as! String)
                equip.name = e["nickName"] as! String
                equip.roomCode = e["roomCode"] as! String
                equip.userCode = e["userCode"] as! String
                equip.type = e["deviceType"] as! String
              //  equip.num  = e["deviceNum"] as! String
                equip.icon  = e["icon"] as! String
                equip.hostDeviceCode = e["deviceCode"] == nil ? "" : e["deviceCode"] as!String
                equip.num  =  e["validationCode"] == nil ? "" : e["validationCode"]as!String


                if equip.icon == ""{
                    equip.icon = getIconByType(type: equip.type)
                }
                equip.saveEquip()

            }

        }
        complete()
    }

}



typealias CompleteUpdateRoomInfo = () -> ()
func updateRoomInfo(complete:@escaping CompleteUpdateRoomInfo){
    
    
    print("更新房间信息")
    
    
    let parameters=["userPhone":BaseHttpService.getUserPhoneType()];
    BaseHttpService .sendRequestAccess(getroom_do, parameters: parameters as NSDictionary) { (anyObject) -> () in
       dataDeal.clearRoomAndFloorTable()
        if anyObject.count <= 0{
            complete()
            return
        }
        let floorInfo = ((anyObject as! NSArray)[0] as! NSDictionary)["floorInfo"]
        for dic in (floorInfo as!NSArray)
        {
            let f = Floor(floorCode:(dic as! NSDictionary)["floorCode"] as! String)
            f.name = (dic as! NSDictionary)["floorName"] as! String
            f.saveFloor()

        }
        let roomInfo = ((anyObject as! NSArray)[0] as! NSDictionary)["roomInfo"]

        for dic in (roomInfo as!NSArray)
        {
            let r = Room(roomCode:(dic as! NSDictionary)["roomCode"] as! String)
            r.name = (dic as! NSDictionary)["roomName"] as! String
            r.floorCode =  (dic as! NSDictionary)["floorCode"] as! String
            r.saveRoom()

        }
         complete()

    }
    
    
}
//typealias CompletereadRoomInfo = () -> ()
//func readRoomInfo(complete:CompletereadRoomInfo)
//{
//     //获取本地版本
//    let localnum =  NSUserDefaults.standardUserDefaults().floatForKey("\(BaseHttpService.userCode())RoomInfoVersionNumber")
//    
//    // 读取服务器版本
//    dareNetRoomInfoVersionNumber {  f in
//        if   f > localnum // 判断是否更新
//        {
//            // 更新（如需）
//            print("更新房间信息")
//            updateRoomInfo({ () -> () in
//                // 更新一个版本号上传到服务器上面
//                NSUserDefaults.standardUserDefaults().setFloat(f, forKey: "\(BaseHttpService.userCode())RoomInfoVersionNumber")
//                     complete()
//             })
//            
//        }else{
//            complete()
//            
//        }
//    }
//     //本地设置为最新的版本号
//}

//typealias CompleteNOtoNet = () -> ()
//func setNetRoomInfoVersionNumber(f:Float,andComplete complete:CompleteNOtoNet){
//    
//    let parameters=["version": Float(floatLiteral: f)];
//    //设置服务器版本号。
//    BaseHttpService .sendRequestAccess(setversion_do, parameters: parameters) { (response) -> () in
//        
//        complete()
//    }
//    
//    
//}
//
//typealias CompleteRoomInfoNumber = (Float) -> ()
//func dareNetRoomInfoVersionNumber(complete:CompleteRoomInfoNumber){
//    
//    
//    
//    let parameters=["":""]
//    
//    
//    //读取服务器版本号。
//    BaseHttpService .sendRequestAccess(getversion_do, parameters: parameters) { (response) -> () in
//      
//          complete((response["version"]!?.floatValue)!)//处理版本号
//    }
//    
//    
//}


func randomCode()->String
{
    let kNumber = 8;
    let sourceStr:NSString="0123456789";
    var resultStr = ""
    
    for   _ in  0..<kNumber
    {
        let index = arc4random() % UInt32(sourceStr.length)
        let oneStr = sourceStr.substring(with: NSMakeRange(Int(index), 1))
        resultStr += oneStr
    }
    print("随机设备号:\(resultStr)")
    return resultStr
}

