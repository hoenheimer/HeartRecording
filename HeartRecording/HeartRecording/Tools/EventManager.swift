//
//  EventManager.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/6/19.
//

import UIKit
import AppsFlyerLib


class EventManager: NSObject {
	class func log(name: String) {
		AppsFlyerLib.shared().logEvent(name, withValues: [:])
	}
}
