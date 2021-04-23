//
//  AppDelegate.swift
//  HeartRecording
//
//  Created by 张子恒 on 2021/4/15.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NBNewStoreManager.shard.completeTransactions()
        configFirebase()
        return true
    }
    
    
    func configFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        NBRemoteConfigTool.shard.start()
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: -
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            print("FCM registration token: %@", fcmToken)
            let dataDict = ["token" : fcmToken]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FCMToken"), object: nil, userInfo: dataDict)
        }
    }
}

