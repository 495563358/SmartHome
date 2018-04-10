//
//  ChainModel.swift
//  SmartHome
//
//  Created by sunzl on 16/5/9.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ChainModel: NSObject {
    @objc var modelId = ""
    @objc var modelName = ""
    var modelIcon = ""
}

class EditChainModel: NSObject {
    @objc var modelId = ""
    @objc var modelName = ""
    var modelIcon = ""
    var isApproval:Bool = false
}
