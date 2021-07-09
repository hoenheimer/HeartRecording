//
//  EventManager.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/6/19.
//

import UIKit
import AppsFlyerLib
import StoreKit


class EventManager: NSObject {
	class func log(name: String) {
		AppsFlyerLib.shared().logEvent(name, withValues: [:])
	}
	
	
	class func income(product: SKProduct, type: String) {
		AppsFlyerLib.shared().logEvent("purchase",
		withValues: [
			AFEventParamContentId: "com.babycare.angelweekly",
			AFEventParamContentType : type,
			AFEventParamRevenue: product.price,
			AFEventParamCurrency: product.priceLocale.currencyCode ?? "USD"
		])
	}
}
