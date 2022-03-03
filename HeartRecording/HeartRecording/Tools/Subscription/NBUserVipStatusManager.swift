//
//  NBUserVipStatusManager.swift
//  Fonts
//
//  Created by luoyue on 2020/7/15.
//  Copyright © 2020 luoyue. All rights reserved.
//

import UIKit

class NBUserVipStatusManager: NSObject {

    static let shard = NBUserVipStatusManager()
    var isVip: Bool!{
        get {
            return getVipStatus()
        }
    }
    //订阅状态的过期时间
    private let NBSubscriptionExpiresDate = "NBSubscriptionExpiresDate"
    //最后一次检查订阅状态的日期  用系统时间记录
    private let NBLastCheackVipStatusDate = "NBLastCheackVipStatusDate"
    //订阅状态
    private let NBSubscriptionStatus = "NBSubscriptionStatus"
    
    //记录订阅可用时间
    private let NBCanUserMinute = "NBCanUserMinute"
    
    private let NBCanUserHour = "NBCanUserHour"
    
    //否有一次性购买
    private let NBOneTimePurchases = "NBOneTimePurchases"
    
    //记录订阅状态回调
    private var recordSubscriptionBlock: ((_ isSuccess: Bool)->())?
    
    
    @objc open class func shardInstance() -> NBUserVipStatusManager{
        return shard
    }
    
    private override init() {
        super.init()
    }
    
    @objc func getVipStatus() -> Bool{
		#if DEBUG
		return false
		#else
        var isAvailable = false
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.OneTimePurchases){
            isAvailable = true
        } else {
            if let expiresDate = UserDefaults.standard.object(forKey: UserDefaultsKey.SubscriptionExpiresDate) as? Date{
                if Date() < expiresDate{
                   isAvailable = true
                }
            }
        }
        return isAvailable
		#endif
    }
    
   
    /** 记录一次性购买状态*/
    func recordOnetimePurchase() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.OneTimePurchases)
        NotificationCenter.default.post(name: .NBUserSubscriptionStatusDidChange, object: nil)
    }
    /**记录订阅状态*/
    func recordSubscriptionStatus(_ expiresDate: Date?) {
        UserDefaults.standard.set(expiresDate, forKey: UserDefaultsKey.SubscriptionExpiresDate)
    }
}


extension Notification.Name{
    static let NBUserSubscriptionStatusDidChange = Notification.Name.init("NBUserSubscriptionStatusDidChange")
}


class UserDefaultsKey {
    static let OneTimePurchases = "OneTimePurchasesUserDefaultsKeyForPublic"
    static let SubscriptionExpiresDate = "SubscriptionExpiresDateUserDefaultsKeyForPublic"
}

