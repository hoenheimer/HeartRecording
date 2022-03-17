//
//  RotationImageView.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/17.
//

import UIKit

class RotationImageView: UIImageView {
	var duration: CFTimeInterval = 4
	let animationKey = "rotatianAnimationKey"
	 
	
	func addAnimating() {
		let animation = CABasicAnimation(keyPath: "transform.rotation.z")
		animation.toValue = CGFloat.pi * 2
		animation.timingFunction = CAMediaTimingFunction(name: .linear)
		animation.duration = duration
		animation.autoreverses = false
		animation.isRemovedOnCompletion = false
		animation.fillMode = .forwards
		animation.repeatCount = .greatestFiniteMagnitude
		layer.add(animation, forKey: animationKey)
		
		startAnimating()
	}
	
	
	override func startAnimating() {
		if layer.animation(forKey: animationKey) != nil {
			if layer.speed == 1 {
				return
			}
			layer.speed = 1
			layer.beginTime = 0
			let pausedTime = layer.timeOffset
			layer.timeOffset = 0
			layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
		} else {
			addAnimating()
		}
	}
	
	
	override func stopAnimating() {
		if layer.speed == 0 {
			return
		}
		let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
		layer.speed = 0
		layer.timeOffset = pausedTime
	}
}
