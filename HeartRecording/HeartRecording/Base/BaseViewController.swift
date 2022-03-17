//
//  BaseViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/3.
//

import UIKit

class BaseViewController: UIViewController {
	var ana_gradientLayer: CAGradientLayer!
	var ana_backgroundImageView: UIImageView!
	var ana_primaryLabel: UILabel!
	var ana_secondaryLabel: UILabel!
	var ana_imageView: UIImageView!
	var ana_button: UIButton!
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		configure()
    }
	
	
	func configure() {
		ana_gradientLayer = CAGradientLayer()
		ana_gradientLayer.colors = [UIColor.color(hexString: "#fffbf5").cgColor, UIColor.white.cgColor]
		ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.23)
		view.layer.addSublayer(ana_gradientLayer)
		
		ana_backgroundImageView = UIImageView(image: UIImage(named: "Base_Background"))
		view.addSubview(ana_backgroundImageView)
		
		ana_primaryLabel = UILabel()
		ana_primaryLabel.textColor = .color(hexString: "#504278")
		ana_primaryLabel.font = UIFont(name: "Didot", size: 36)
		view.addSubview(ana_primaryLabel)
		
		ana_secondaryLabel = UILabel()
		ana_secondaryLabel.numberOfLines = 0
		ana_secondaryLabel.textAlignment = .center
		ana_secondaryLabel.textColor = .color(hexString: "#504278")
		ana_secondaryLabel.font = UIFont(name: "PingFangHK-Light", size: 20)
		view.addSubview(ana_secondaryLabel)
		
		ana_imageView = UIImageView()
		view.addSubview(ana_imageView)
		
		ana_button = UIButton()
		ana_button.layer.cornerRadius = 27
		ana_button.backgroundColor = .color(hexString: "#8059f3")
		ana_button.setTitle("Continue", for: .normal)
		ana_button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
		ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
		view.addSubview(ana_button)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_gradientLayer.frame = view.bounds
		ana_backgroundImageView.sizeToFit()
		ana_backgroundImageView.center = CGPoint(x: view.halfWidth(), y: view.halfHeight())
		ana_primaryLabel.sizeToFit()
		ana_primaryLabel.center = CGPoint(x: view.halfWidth(), y: topSpacing() + 66 + ana_primaryLabel.halfHeight())
		let size = ana_secondaryLabel.sizeThatFits(CGSize(width: view.width() - 31 * 2, height: .greatestFiniteMagnitude))
		ana_secondaryLabel.bounds = CGRect(origin: .zero, size: size)
		ana_secondaryLabel.center = CGPoint(x: view.halfWidth(), y: ana_primaryLabel.maxY() + 9 + ana_secondaryLabel.halfHeight())
		ana_button.bounds = CGRect(x: 0, y: 0, width: view.width() - 24 * 2, height: 54)
		ana_button.center = CGPoint(x: view.halfWidth(), y: view.height() - bottomSpacing() - 74 - ana_button.halfHeight())
	}
}
