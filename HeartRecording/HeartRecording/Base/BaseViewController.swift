//
//  BaseViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/3.
//

import UIKit

class BaseViewController: UIViewController {
	var gradientLayer: CAGradientLayer!
	var shapeImageView: UIImageView!
	var primaryLabel: UILabel!
	var secondaryLabel: UILabel!
	var imageView: UIImageView!
	var button: UIButton!
	var pageImageView1: BasePageImageView!
	var pageImageView2: BasePageImageView!
	var pageImageView3: BasePageImageView!
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		configure()
    }
	
	
	func configure() {
		gradientLayer = CAGradientLayer()
		gradientLayer.colors = [UIColor.color(hexString: "#fffdfd").cgColor, UIColor.color(hexString: "#fff0f2").cgColor]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		view.layer.addSublayer(gradientLayer)
		
		shapeImageView = UIImageView()
		view.addSubview(shapeImageView)
		
		primaryLabel = UILabel()
		primaryLabel.textColor = .color(hexString: "#6a515e")
		primaryLabel.font = UIFont(name: "Merriweather-Bold", size: 36)
		view.addSubview(primaryLabel)
		
		secondaryLabel = UILabel()
		secondaryLabel.numberOfLines = 0
		secondaryLabel.textAlignment = .center
		secondaryLabel.textColor = .color(hexString: "#6a515e")
		secondaryLabel.font = UIFont(name: "PingFangHK-Regular", size: 20)
		view.addSubview(secondaryLabel)
		
		imageView = UIImageView()
		view.addSubview(imageView)
		
		button = UIButton()
		button.setImage(UIImage(named: "Base_Button"), for: .normal)
		view.addSubview(button)
		
		pageImageView1 = BasePageImageView()
		view.addSubview(pageImageView1)
		
		pageImageView2 = BasePageImageView()
		view.addSubview(pageImageView2)
		
		pageImageView3 = BasePageImageView()
		view.addSubview(pageImageView3)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		gradientLayer.frame = view.bounds
		primaryLabel.sizeToFit()
		primaryLabel.center = CGPoint(x: view.halfWidth(), y: topSpacing() + 52 + primaryLabel.halfHeight())
		let size = secondaryLabel.sizeThatFits(CGSize(width: view.width() - 30 * 2, height: .greatestFiniteMagnitude))
		secondaryLabel.bounds = CGRect(origin: .zero, size: size)
		secondaryLabel.center = CGPoint(x: view.halfWidth(), y: primaryLabel.maxY() + 9 + secondaryLabel.halfHeight())
		pageImageView2.sizeToFit()
		pageImageView2.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.86)
		pageImageView1.sizeToFit()
		pageImageView1.center = CGPoint(x: pageImageView2.centerX() - 22, y: pageImageView2.centerY())
		pageImageView3.sizeToFit()
		pageImageView3.center = CGPoint(x: pageImageView2.centerX() + 22, y: pageImageView2.centerY())
		button.sizeToFit()
		button.center = CGPoint(x: pageImageView1.centerX() - 67, y: pageImageView2.centerY())
	}
}


class BasePageImageView: UIImageView {
	func setHighlighted(_ highlighted: Bool) {
		image = UIImage(named: "Base_Page_" + (highlighted ? "Highlighted" : "Default"))
	}
}
