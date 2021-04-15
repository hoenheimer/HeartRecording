//
//  UIColor+Addition.swift
//  totowallet
//
//  Created by Yuan Ana on 2020/12/28.
//

import Foundation
import UIKit


public extension UIColor {
	class func color(hexString: String) -> UIColor {
		if !hexString.hasPrefix("#") || !(hexString.count == 7 || hexString.count == 9) {
			assert(false, "色值字符串错误：\(hexString)")
		}
		
		func getHex(range: Range<String.Index>) -> CGFloat {
			let subString = hexString[range]
			let hexValue = CGFloat(strtoul(String(subString), nil, 16)) / 255.0
			return hexValue
		}
		
		let alpha 	= hexString.count == 7 ? 1 : getHex(range: hexString.index(hexString.startIndex, offsetBy: 1)..<hexString.index(hexString.startIndex, offsetBy: 3))
		let blue 	= getHex(range: hexString.index(hexString.endIndex, offsetBy: -2)..<hexString.endIndex)
		let green	= getHex(range: hexString.index(hexString.endIndex, offsetBy: -4)..<hexString.index(hexString.endIndex, offsetBy: -2))
		let red		= getHex(range: hexString.index(hexString.endIndex, offsetBy: -6)..<hexString.index(hexString.endIndex, offsetBy: -4))
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}
