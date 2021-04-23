//
//  NBRCValues.swift
//  MeditationDiary
//
//  Created by luoyue on 2020/4/8.
//  Copyright © 2020 Novabeyond. All rights reserved.
//

import UIKit
import Firebase

class NBRemoteConfigTool: NSObject {
    /**是否是审核版本*/
    let NBISReviewVersion = "ISReviewVersion"
    static let shard = NBRemoteConfigTool()
    private override init() {}
    
    @objc public class func shardInstance() -> NBRemoteConfigTool{
        return shard
    }
    
    @objc public func start() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    @objc public func isReviewVersion() -> Bool{
        return NBRemoteConfigTool.shard.getConfig(NBISReviewVersion) == "1"
    }
    
    @objc public func getConfig(_ key: String) -> String {
        let value = RemoteConfig.remoteConfig()
            .configValue(forKey: key).stringValue ?? "1"
        print(value)
        return value
    }
    
    private func loadDefaultValues() {
        let dic: [String: Any] = [NBISReviewVersion: "1"]
        RemoteConfig.remoteConfig().setDefaults(dic as? [String : NSObject])
    }
    
    private func fetchCloudValues() {
        #if DEBUG
        print("aaaaaaaaa")
        let fetchDuration: TimeInterval =  0
        #else
        print("bbbbbbbbbb")
        let fetchDuration: TimeInterval =  24 * 60 * 60
        #endif
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in
            if error == nil{
                RemoteConfig.remoteConfig().activate(completion: nil)
            } else {
				print(error!.localizedDescription)
            }
        }
    }
}
