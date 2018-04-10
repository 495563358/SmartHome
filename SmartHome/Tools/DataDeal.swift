//
//  DataDeal.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
import SQLite

var dataDeal: DataDeal {
    return DataDeal.sharedDataDeal
}
class DataWrapper:NSObject {
    @objc static func getCameras()->[Equip]
    {
    return dataDeal.searchAllSXTModel()
    }
}
//


class DataDeal :NSObject{
    
    enum TableType {
        case User, Floor, Room, Equip ,OneOfModel,CtrModel
    }
    
    @objc static let sharedDataDeal = DataDeal()

    let db = try? Connection(NSHomeDirectory() + "/Documents" + "/db.sqlite")
    
    var floors = [Floor]()
    var rooms = [Room]()
    func clearRoomAndFloorTable(){
        let floor = Table("Floors")
        
        do {
            try db?.run(floor.delete())
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        let rooms = Table("Rooms")
        
        do {
            try db?.run(rooms.delete())
        } catch let error as NSError {
            print(error.localizedDescription)
        }
     
   
    }
    func clearEquipTable(){
        
        let equips = Table("Equips")
        
        do {
            try db?.run(equips.delete())
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    func creatUserTable() {
        
    }
    
    func creatFloorTable() {
        let id = Expression<Int64>("id")
        let floorCode = Expression<String>("code")
        let floorName = Expression<String>("name")
        let userCode = Expression<String>("userCode")
        let floor = Table("Floors")
        
        do {
            try db?.run(floor.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: PrimaryKey.autoincrement)
                t.column(floorCode, unique: true)
                t.column(floorName)
                t.column(userCode)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func creatRoomTable() {
        let id = Expression<Int64>("id")
        let roomCode = Expression<String>("code")
        let roomName = Expression<String>("name")
        let floorCode = Expression<String>("floorCode")
        let userCode = Expression<String>("userCode")
        let room = Table("Rooms")
        
        do {
            try db?.run(room.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: PrimaryKey.autoincrement)
                t.column(roomCode, unique: true)
                t.column(roomName)
                t.column(floorCode)
                t.column(userCode)
                })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func creatEquipTable() {
        let id = Expression<Int64>("id")
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let type = Expression<String>("type")
        let num =  Expression<String>("num")
        let hostDeviceCode = Expression<String>("hostDeviceCode")
        let equip = Table("Equips")
        do {
            try db?.run(equip.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: .autoincrement)
                t.column(equipCode, unique: true)
                t.column(equipName)
                t.column(equipIcon)
                t.column(roomCode)
                t.column(userCode)
                t.column(type)
                t.column(num)
                t.column(hostDeviceCode)
                })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    func searchSXTModel(byRoomCode code: String) ->[Equip]{
             var arr = [Equip]()
       
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let type = Expression<String>("type")
            let num =  Expression<String>("num")
            let hostDeviceCode = Expression<String>("hostDeviceCode")
            let equip = Table("Equips")
          
            for e in try! db!.prepare(equip.filter(roomCode == code && ( type  == "100"||type  == "101")))
            {
                let newEquip = Equip(equipID: e[equipCode])
                newEquip.name = e[equipName]
                newEquip.icon = e[equipIcon]
                newEquip.userCode = e[userCode]
                newEquip.roomCode = e[roomCode]
                newEquip.type = e[type]
                newEquip.num = e[num]
                 newEquip.hostDeviceCode = e[hostDeviceCode]
                arr.append(newEquip)
            }
       
        return arr
    }
   
    func searchModel(type: TableType, byCode code: String) ->AnyObject? {
        
        switch type {
        case .User:
            break
        case .Floor:
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            for f in try! db!.prepare(floor.filter(floorCode == code)) {
                let newFloor = Floor(floorCode: f[floorCode])
                newFloor.name = f[floorName]
                newFloor.userCode = f[userCode]
                return newFloor
            }

        case .Room:
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            for r in try! db!.prepare(room.filter(roomCode == code)) {
                let newRoom = Room(roomCode: r[roomCode])
                newRoom.name = r[roomName]
                newRoom.userCode = r[userCode]
                newRoom.floorCode = r[floorCode]
                return newRoom
            }
            
        case .Equip:
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let type = Expression<String>("type")
            let num =  Expression<String>("num")
            let hostDeviceCode = Expression<String>("hostDeviceCode")
            let equip = Table("Equips")
            for e in try! db!.prepare(equip.filter(equipCode == code)) {
                let newEquip = Equip(equipID: e[equipCode])
                newEquip.name = e[equipName]
                newEquip.icon = e[equipIcon]
                newEquip.userCode = e[userCode]
                newEquip.roomCode = e[roomCode]
                newEquip.type = e[type]
                newEquip.num = e[num]
                newEquip.hostDeviceCode = e[hostDeviceCode]
                return newEquip
            }
        default:
            break
        }
        
        return nil
    }
    
    func getModels(type: TableType) -> (Array<AnyObject>) {
        var arr = [AnyObject]()
        switch type {
        case .User:
            break
        case .Floor:
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            for f in try! db!.prepare(floor) {
                let newFloor = Floor(floorCode: f[floorCode])
                newFloor.name = f[floorName]
                newFloor.userCode = f[userCode]
                arr.append(newFloor)
            }
            
        case .Room:
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            for r in try! db!.prepare(room) {
                let newRoom = Room(roomCode: r[roomCode])
                newRoom.name = r[roomName]
                newRoom.userCode = r[userCode]
                newRoom.floorCode = r[floorCode]
                arr.append(newRoom)
            }
            
        case .Equip:
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let type = Expression<String>("type")
            let num =  Expression<String>("num")
            let hostDeviceCode = Expression<String>("hostDeviceCode")
            let equip = Table("Equips")
            for e in try! db!.prepare(equip) {
                let newEquip = Equip(equipID: e[equipCode])
                newEquip.name = e[equipName]
                newEquip.icon = e[equipIcon]
                newEquip.userCode = e[userCode]
                newEquip.roomCode = e[roomCode]
                newEquip.type = e[type]
                newEquip.num = e[num]
                newEquip.hostDeviceCode = e[hostDeviceCode]
                arr.append(newEquip)
            }
        default:
            break
        }
        return arr
        
    }
    
    func insertModel(type: TableType, model: AnyObject) {
        switch type {
        case .User:
            
            break
        case .Floor where model is Floor:
            let f = model as! Floor
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            do {
                try db?.run(floor.insert(or: .replace, floorCode <- f.floorCode, floorName <- f.name, userCode <- f.userCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Room where model is Room:
            let r = model as! Room
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            do {
                try db?.run(room.insert(or: .replace, roomCode <- r.roomCode, roomName <- r.name, userCode <- r.userCode, floorCode <- r.floorCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Equip where model is Equip:
            let e = model as! Equip
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let type = Expression<String>("type")
            let num = Expression<String>("num")
            let hostDeviceCode = Expression<String>("hostDeviceCode")
            let equip = Table("Equips")
            do {
                try db?.run(equip.insert(or: .replace, equipCode <- e.equipID, equipName <- e.name, userCode <- e.userCode, roomCode <- e.roomCode, equipIcon <- e.icon,type <- e.type,num <- e.num,hostDeviceCode <- e.hostDeviceCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        default:
            break
        }
    }
    func deleteModel( type:TableType, model: AnyObject)
    {
    
    switch type {
    case .User:
    
    break
    case .Floor where model is Floor:
    let f = model as! Floor
    let floor = Table("Floors")
    let floorCode = Expression<String>("code")
 
    do {
        try db?.run(floor.filter(floorCode == f.floorCode).delete())
    } catch let error as NSError {
    print(error.localizedDescription)
    }
    
    case .Room where model is Room:
    let r = model as! Room
    let roomCode = Expression<String>("code")
 
    let room = Table("Rooms")
    do {
    try db?.run(room.filter(roomCode == r.roomCode).delete())
    } catch let error as NSError {
    print(error.localizedDescription)
    }
    
    case .Equip where model is Equip:
    let e = model as! Equip
    let equipCode = Expression<String>("code")
   
    let equip = Table("Equips")
    do {
    try db?.run(equip.filter(equipCode == e.equipID).delete())
    } catch let error as NSError {
    print(error.localizedDescription)
    }
    default:
    break
    }

    
    
    
    }
    func updateModel(type: TableType, model: AnyObject) {
        switch type {
        case .User:
            
            break
        case .Floor where model is Floor:
            let f = model as! Floor
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            do {
                try db?.run(floor.filter(floorCode == f.floorCode).update(floorName <- f.name,userCode <- f.userCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Room where model is Room:
            let r = model as! Room
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            do {
                try db?.run(room.filter(roomCode == r.roomCode).update(roomName <- r.name, userCode <- r.userCode, floorCode <- r.floorCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Equip where model is Equip:
            let e = model as! Equip
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
               let type = Expression<String>("type")
                    let num = Expression<String>("num")
              let hostDeviceCode = Expression<String>("hostDeviceCode")
            let equip = Table("Equips")
            do {
                try db?.run(equip.filter(equipCode == e.equipID).update(equipName <- e.name, userCode <- e.userCode, roomCode <- e.roomCode, equipIcon <- e.icon,type <- e.type,num <- e.num,hostDeviceCode <- e.hostDeviceCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        default:
            break
        }
    }
    
    func getClassifyAndUnClassifyEquips() -> ((Array<Equip>, Array<Equip>)) {
        let arr = getModels(type: .Equip) as! [Equip]
        var classifyArr = [Equip]()
        var unClassifyArr = [Equip]()
        for equip in arr {
            if (equip.roomCode != "") {
                classifyArr.append(equip)
            } else {
                unClassifyArr.append(equip)
            }
        }
        return (classifyArr, unClassifyArr)
    }
    
    
    func getRoomsByFloor(floor: Floor) -> [Room] {
        var arr = [Room]()
        let roomCode = Expression<String>("code")
        let roomName = Expression<String>("name")
        let floorCode = Expression<String>("floorCode")
        let userCode = Expression<String>("userCode")
        let room = Table("Rooms")
        for r in try! db!.prepare(room.filter(floorCode == floor.floorCode)) {
            let newRoom = Room(roomCode: r[roomCode])
            newRoom.name = r[roomName]
            newRoom.floorCode = r[floorCode]
            newRoom.userCode = r[userCode]
            arr.append(newRoom)
        }
        return arr
    }
    func getEquipsByRoomCodeExceptSXT(currentRoomCode: String) -> [Equip] {
        print("-----\(currentRoomCode)")
        var arr = [Equip]()
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let type = Expression<String>("type")
        let num =  Expression<String>("num")
        let hostDeviceCode = Expression<String>("hostDeviceCode")
      
        let equip = Table("Equips")
            print("getEquipsByRoomExceptSXT---\(roomCode)");
        for e in try! db!.prepare(equip.filter(roomCode == currentRoomCode && type != "100" && type != "101")) {
            let newEquip = Equip(equipID: e[equipCode])
            newEquip.name = e[equipName]
            newEquip.icon = e[equipIcon]
            newEquip.roomCode = e[roomCode]
            newEquip.userCode = e[userCode]
            newEquip.type = e[type]
            newEquip.num = e[num]
            newEquip.hostDeviceCode = e[hostDeviceCode]
            arr.append(newEquip)
        }
        return arr
    }
    func getEquipsByRoomExceptSXT(room: Room) -> [Equip] {
        var arr = [Equip]()
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let type = Expression<String>("type")
        let num =  Expression<String>("num")
        let hostDeviceCode = Expression<String>("hostDeviceCode")
        let equip = Table("Equips")
        print("getEquipsByRoomExceptSXT---\(room.roomCode)");
        for e in try! db!.prepare(equip.filter(roomCode == room.roomCode && type != "100" && type != "101" )) {
            let newEquip = Equip(equipID: e[equipCode])
            newEquip.name = e[equipName]
            newEquip.icon = e[equipIcon]
            newEquip.roomCode = e[roomCode]
            newEquip.userCode = e[userCode]
            newEquip.type = e[type]
            newEquip.num = e[num]
            newEquip.hostDeviceCode = e[hostDeviceCode]
            arr.append(newEquip)
        }
        return arr
    }
    func getQJEquipsByRoomExceptSXT(room: Room) -> [Equip] {
        var arr = [Equip]()
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let type = Expression<String>("type")
        let num =  Expression<String>("num")
        let hostDeviceCode = Expression<String>("hostDeviceCode")
        let equip = Table("Equips")
        print("getEquipsByRoomExceptSXT---\(room.roomCode)");
        for e in try! db!.prepare(equip.filter(roomCode == room.roomCode && type != "100" && type != "101" && type != "998")) {
            let newEquip = Equip(equipID: e[equipCode])
            newEquip.name = e[equipName]
            newEquip.icon = e[equipIcon]
            newEquip.roomCode = e[roomCode]
            newEquip.userCode = e[userCode]
            newEquip.type = e[type]
            newEquip.num = e[num]
                 newEquip.hostDeviceCode = e[hostDeviceCode]
            arr.append(newEquip)
        }
        return arr
    }
    func getEquipsByRoom(room: Room) -> [Equip] {
        var arr = [Equip]()
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let type = Expression<String>("type")
        let num =  Expression<String>("num")
        let hostDeviceCode = Expression<String>("hostDeviceCode")
        let equip = Table("Equips")
        
        for e in try! db!.prepare(equip.filter(roomCode == room.roomCode /*&& type == "100" && type == "101"*/)) {
            let newEquip = Equip(equipID: e[equipCode])
            newEquip.name = e[equipName]
            newEquip.icon = e[equipIcon]
            newEquip.roomCode = e[roomCode]
            newEquip.userCode = e[userCode]
            newEquip.type = e[type]
            newEquip.num = e[num]
            newEquip.hostDeviceCode = e[hostDeviceCode]
            arr.append(newEquip)
        }
        return arr
    }
    @objc func searchAllSXTModel() ->[Equip]{
        var arr = [Equip]()
        
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let type = Expression<String>("type")
        let num =  Expression<String>("num")
        let hostDeviceCode = Expression<String>("hostDeviceCode")
        let equip = Table("Equips")
        
        for e in try! db!.prepare(equip.filter(type  == "100"))
        {
            let newEquip = Equip(equipID: e[equipCode])
            newEquip.name = e[equipName]
            newEquip.icon = e[equipIcon]
            newEquip.userCode = e[userCode]
            newEquip.roomCode = e[roomCode]
            newEquip.type = e[type]
            newEquip.num = e[num]
              newEquip.hostDeviceCode = e[hostDeviceCode]
            arr.append(newEquip)
        }
        
        return arr
    }
    func toJSONString(jsonSource: AnyObject) -> String {
        var data = NSData()
        do {
            try data = JSONSerialization.data(withJSONObject: jsonSource, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        } catch let error as NSError {
            print(error)
        }
        let strJson = String(data: data as Data, encoding: String.Encoding.utf8)
        return strJson!
    }
}
