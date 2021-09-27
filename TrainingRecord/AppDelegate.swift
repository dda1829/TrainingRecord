//
//  AppDelegate.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/5/17.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds
import UserNotifications
import FBSDKCoreKit
import GoogleSignIn
@main
class AppDelegate: UIResponder, UIApplicationDelegate{



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {(grant,error) in
            if let e = error {
                print( "error \(e)")
                return
            }
         })
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    
    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if GIDSignIn.sharedInstance.handle(url){
            return true
        } else if ApplicationDelegate.shared.application(app,open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation]){
            return true
        }
       return false
        
        }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //如何顯示通知
        let userInfo = notification.request.content.userInfo
        print("willPresent userInfo:\(userInfo)")
        completionHandler([ .sound, .alert])
    }
    // 2.App is suspended in backgrond, and user click remote notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //點開了通知處理
        let userInfo = response.notification.request.content.userInfo
        print("didReceive userInfo: \(userInfo)")
//        guard let aps = userInfo["aps"] as? [String: [String: String]], let alert = aps["alert"] else {
//            return
//        }
        NotificationCenter.default.post(name: Notification.Name("ReceivedNotification"), object: nil)
        
        completionHandler()
    }
}
