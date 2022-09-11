//
//  AppDelegate.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/9.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import UserNotifications
import ARKit
import FacebookCore
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    var firstEnterApp = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        guard ARObjectScanningConfiguration.isSupported, ARWorldTrackingConfiguration.isSupported else {
//            fatalError("""
//                ARKit is not available on this device. For apps that require ARKit
//                for core functionality, use the `arkit` key in the key in the
//                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
//                the app from installing. (If the app can't be installed, this error
//                can't be triggered in a production scenario.)
//                In apps where AR is an additive feature, use `isSupported` to
//                determine whether to show UI for launching AR experiences.
//            """) // For details, see https://developer.apple.com/documentation/arkit
//        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        //進入畫面做選擇
        let mainStoryBoard = UIStoryboard(name:"Main" , bundle: nil)
        let loginStoryBoard = UIStoryboard(name:"Login" , bundle: nil)
        if(firstEnterApp){
            self.window?.rootViewController = loginStoryBoard.instantiateInitialViewController()
            // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
                if granted {
                    print("推播允許")
                } else {
                    print("推播不允許")
                }
            })
            // 代理 UNUserNotificationCenterDelegate，這麼做可讓 App 在前景狀態下收到通知
            UNUserNotificationCenter.current().delegate = self
        }else{
            self.window?.rootViewController = mainStoryBoard.instantiateInitialViewController()
        }
        
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
        //AppEventsLogger.activate(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // 在前景收到通知時所觸發的 function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("在前景收到通知...")
        completionHandler([.badge, .sound, .alert])
    }
    // 點擊通知觸發的事件
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("HiHI")
        //        let content: UNNotificationContent = response.notification.request.content
        let mainStoryBoard = UIStoryboard(name:"Warn" , bundle: nil)
        completionHandler()
        self.window?.rootViewController = mainStoryBoard.instantiateInitialViewController()
        // 取出userInfo的link並開啟Facebook
        //        let requestUrl = URL(string: content.userInfo["link"]! as! String)
        //        UIApplication.shared.open(requestUrl!, options: [:], completionHandler: nil)
    }
    
    


        
    
    
}

