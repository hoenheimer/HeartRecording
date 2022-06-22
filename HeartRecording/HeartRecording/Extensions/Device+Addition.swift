//
//  Device+Addition.swift
//  AnimatePhoto
//
//  Created by MagicAna on 2021/11/2.
//

import Foundation
import DeviceKit


extension Device {
	static func isSmallScreen() -> Bool {
        return Device.current.isPad || [Device.iPhone6, .iPhone6s, .iPhone7, .iPhone8, .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus, .iPhoneSE, .iPhoneSE2, .iPhoneSE3, .simulator(.iPhone6), .simulator(.iPhone6s), .simulator(.iPhone7), .simulator(.iPhone8), .simulator(.iPhone6Plus), .simulator(.iPhone6sPlus), .simulator(.iPhone7Plus), .simulator(.iPhone8Plus), .simulator(.iPhoneSE), .simulator(.iPhoneSE2), .simulator(.iPhoneSE3)].contains(Device.current)
	}
}
