//
//  SubscriptionProductView.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/3.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class SubscriptionProductView: UIView {
	var imageView: UIImageView!
	var label: UILabel!
	
	let pipe = Signal<Int, Never>.pipe()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		layer.cornerRadius = 12
		backgroundColor = .white
		setShadow(color: .color(hexString: "#33c37682"), offset: CGSize(width: 0, height: 1), radius: 2, opacity: 1)
		
		let tap = UITapGestureRecognizer()
		tap.reactive.stateChanged.observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.pipe.input.send(value: 1)
		}
		addGestureRecognizer(tap)
		
		imageView = UIImageView()
		addSubview(imageView)
		
		label = UILabel()
		label.textColor = .black
		label.font = UIFont(name: "Poppins-Medium", size: 14)
		addSubview(label)
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		imageView.sizeToFit()
		imageView.center = CGPoint(x: 16 + imageView.halfWidth(), y: halfHeight())
		label.sizeToFit()
		label.center = CGPoint(x: imageView.maxX() + 9 + label.halfWidth(), y: halfHeight())
	}
	
	
	func set(price: String, freeDays: Int, durationString: String) {
		var string = ""
		if freeDays > 0 {
			string.append("\(freeDays) Days Free Trial,then ")
		}
		string.append("\(price)/\(durationString)")
		label.text = string
		layoutNow()
	}
	
	
	func setSelected(_ selected: Bool) {
		imageView.image = UIImage(named: "Subscription_Product_" + (selected ? "Selected" : "Default"))
	}
}
