//
//  Notifications.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/9/13.
//  Copyright © 2019 sunflower. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UserNotifications

class selfNotifications{
    let account:String
    init(account:String) {
        self.account = account
    }
    convenience init() {
        self.init(account:"null")
    }
    func mealNotification(title:String,body:String,hour:Int,minute:Int) -> Void {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default
        //Date component trigger
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        content.userInfo = userInfo
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8640, repeats: true)
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
}

