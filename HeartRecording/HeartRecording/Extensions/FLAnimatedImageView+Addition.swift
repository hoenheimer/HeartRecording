//
//  FLAnimatedImageView+Addition.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/2/23.
//

import Foundation
import FLAnimatedImage


public extension FLAnimatedImageView {
	convenience init(gifName: String) {
		self.init()
		do {
			if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
				let url = URL(fileURLWithPath: path)
				let data = try Data(contentsOf: url)
				self.animatedImage = FLAnimatedImage(gifData: data)
			}
		} catch let error {
			print(error.localizedDescription)
		}
	}
}
