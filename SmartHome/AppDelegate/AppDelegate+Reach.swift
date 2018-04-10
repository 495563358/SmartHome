//
//  AppDelegate+Reach.swift
//  SmartHome
//
//  Created by sunzl on 15/12/29.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

extension AppDelegate{
    func registerRemoteNotification()
    {
        if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            UIApplication.shared.registerForRemoteNotifications(matching: types)
        }
    }
   
}
