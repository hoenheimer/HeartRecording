//
//  AppDelegate.swift
//  HeartRecording
//
//  Created by 张子恒 on 2021/4/15.
//

import UIKit
import AppsFlyerLib


@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerLibDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Thread.sleep(forTimeInterval: 0.5)
        NBNewStoreManager.shard.completeTransactions()
		configureBugly()
		configureAF()
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
	
	
	//MARK: -GCD
	func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
		print("onConversionDataSuccess data:")
		for (key, value) in installData {
			print(key, ":", value)
		}
		if let status = installData["af_status"] as? String {
			if (status == "Non-organic") {
				if let sourceID = installData["media_source"],
				   let campaign = installData["campaign"] {
					print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
				}
			} else {
				print("This is an organic install.")
			}
			if let is_first_launch = installData["is_first_launch"] as? Bool,
			   is_first_launch {
				print("First Launch")
			} else {
				print("Not First Launch")
			}
		}
	}
	
	func onConversionDataFail(_ error: Error) {
		print(error)
	}
			
	func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
		print("\(attributionData)")
	}
			
	func onAppOpenAttributionFailure(_ error: Error) {
		print(error)
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
	
	
	func configureAF() {
		AppsFlyerLib.shared().appsFlyerDevKey = "b22easoNpiqr3mDqFyvshB"
		AppsFlyerLib.shared().appleAppID = "1564099404"
		AppsFlyerLib.shared().delegate = self
		AppsFlyerLib.shared().isDebug = true
		NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
	}
	
	
	@objc func sendLaunch() {
		AppsFlyerLib.shared().start()
	}
}
