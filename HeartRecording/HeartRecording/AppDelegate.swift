//
//  AppDelegate.swift
//  HeartRecording
//
//  Created by 张子恒 on 2021/4/15.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Thread.sleep(forTimeInterval: 0.5)
        NBNewStoreManager.shard.completeTransactions()
		configureBugly()
        return true
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
	
	func configureBugly() {
		let config = BuglyConfig()
		if let infoDictionary = Bundle.main.infoDictionary {
			if let version = infoDictionary["CFBundleShortVersionString"] as? String {
				var versionString = "v" + version
				if let build = infoDictionary["CFBundleVersion"] as? String {
					versionString = version + "(\(build))"
				}
				config.version = versionString
			}
		}
		config.unexpectedTerminatingDetectionEnable = true
		config.reportLogLevel = .warn
		Bugly.start(withAppId: "eba102d737", config: config)
	}
}

