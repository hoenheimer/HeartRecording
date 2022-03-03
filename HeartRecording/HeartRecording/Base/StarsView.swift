//
//  StarView.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/3.
//

import UIKit


class StarsView: UIView {
	var starViews = [StarView]()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		for _ in 0 ..< 5 {
			let starView = StarView()
			addSubview(starView)
			starViews.append(starView)
		}
	}
	
	
	override func layoutSubviews() {
		var x: CGFloat = 0
		for starView in starViews {
			starView.sizeToFit()
			starView.setOrigin(x: x, y: 0)
			x = starView.maxX() + 14
		}
		bounds = CGRect(x: 0, y: 0, width: starViews.last?.maxX() ?? 0, height: starViews.first?.height() ?? 0)
	}
	
	
	func startAnimation() {
		let duration: TimeInterval = 0.2
		for i in starViews.indices {
			DispatchQueue.main.asyncAfter(deadline: .now() + duration * Double(i)) {
				UIView.animate(withDuration: duration) {
					self.starViews[i].ana_frontStarImageView.alpha = 1
				}
			}
		}
	}
}


class StarView: UIView {
	var ana_behindStarImageView: UIImageView!
	var ana_frontStarImageView: UIImageView!
	
	let defaultColor = UIColor.yellow
	let highlightedColor = UIColor.color(hexString: "#e84a63")
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		backgroundColor = .clear
		
		ana_behindStarImageView = UIImageView(image: UIImage(named: "Base_Star")?.withTintColor(defaultColor))
		addSubview(ana_behindStarImageView)
		
		ana_frontStarImageView = UIImageView(image: UIImage(named: "Base_Star")?.withTintColor(highlightedColor))
		ana_frontStarImageView.alpha = 0
		addSubview(ana_frontStarImageView)
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		ana_behindStarImageView.sizeToFit()
		ana_behindStarImageView.setOrigin(x: 0, y: 0)
		ana_frontStarImageView.frame = ana_behindStarImageView.frame
		bounds = ana_behindStarImageView.frame
	}
}
