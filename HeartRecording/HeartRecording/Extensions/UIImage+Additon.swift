//
//  UIImage+Additon.swift
//  totowallet
//
//  Created by Yuan Ana on 2020/12/28.
//

import Foundation
import UIKit


public extension UIImage {
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
	
	
	func reSizeImage(reSize: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
		draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
		let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return reSizeImage
	}
}
