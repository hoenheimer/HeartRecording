//
//  GuideViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/6/1.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class GuideViewController: UIViewController {
	var ana_gradient: 				CAGradientLayer!
	var ana_titleLabel: 			UILabel!
	var ana_imageView: 				UIImageView!
	var ana_contentLabel: 			UILabel!
	var ana_buttonBackView:         UIView!
	var ana_buttonShadowView:       UIView!
	var ana_buttonGradientView:		UIView!
	var ana_buttonGradientLayer: 	CAGradientLayer!
	var ana_button:                 UIButton!
	
	var ana_index = 1
	
	
	convenience init(index: Int) {
		self.init()
		self.ana_index = index
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tabBarController?.tabBar.isHidden = true
		navigationController?.navigationBar.isHidden = true
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		tabBarController?.tabBar.isHidden = false
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		EventManager.log(name: "GuideVC_\(ana_index)_Show")
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		configure()
    }
	
	
	func configure() {
		ana_gradient = CAGradientLayer()
		ana_gradient.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
		ana_gradient.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradient.endPoint = CGPoint(x: 0.5, y: 1)
		view.layer.addSublayer(ana_gradient)
		
		ana_titleLabel = UILabel()
		ana_titleLabel.layer.zPosition = 2
		ana_titleLabel.text = ana_index == 1 ? "Welcome to Angel!" : "Share your joy :)"
		ana_titleLabel.textColor = .color(hexString: "#263238")
		ana_titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 26)
		view.addSubview(ana_titleLabel)
		
		ana_imageView = UIImageView()
		ana_imageView.layer.zPosition = 2
		ana_imageView.image = UIImage(named: "Guide_Image\(ana_index)")
		view.addSubview(ana_imageView)
		
		ana_contentLabel = UILabel()
		ana_contentLabel.layer.zPosition = 2
		ana_contentLabel.numberOfLines = 0
		let string = ana_index == 1 ? "Use your phone to record your baby's heartbeat" : "Share the magic sounds with your family"
		let pStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		pStyle.alignment = .center
		pStyle.lineSpacing = 10
		ana_contentLabel.attributedText = NSAttributedString(string: string,
														 attributes: [NSAttributedString.Key.foregroundColor : UIColor.color(hexString: "#FF725E"),
																	  NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20),
																	  NSAttributedString.Key.paragraphStyle : pStyle.copy()])
		view.addSubview(ana_contentLabel)
		
		ana_buttonBackView = UIView()
		ana_buttonBackView.backgroundColor = .clear
		view.addSubview(ana_buttonBackView)
		
		ana_buttonGradientView = UIView()
		ana_buttonGradientView.backgroundColor = .clear
		ana_buttonBackView.addSubview(ana_buttonGradientView)
		
		ana_buttonShadowView = UIView()
		ana_buttonShadowView.layer.cornerRadius = 24
		ana_buttonShadowView.layer.borderWidth = 1
		ana_buttonShadowView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
		ana_buttonShadowView.backgroundColor = .color(hexString: "#FF5E5E")
		ana_buttonShadowView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24)
		ana_buttonBackView.addSubview(ana_buttonShadowView)
		
		ana_buttonGradientLayer = CAGradientLayer()
		ana_buttonGradientLayer.cornerRadius = 24
		ana_buttonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		ana_buttonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		ana_buttonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF474747").cgColor]
		ana_buttonGradientView.layer.addSublayer(ana_buttonGradientLayer)
		
		ana_button = UIButton()
		ana_button.backgroundColor = .clear
		ana_button.setTitle("Continue", for: .normal)
		ana_button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
		ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
		ana_button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] button in
			guard let self = self else { return }
			EventManager.log(name: "Guidebutton_\(self.ana_index)_tapped")
			if self.ana_index == 1 {
				self.navigationController?.pushViewController(GuideViewController(index: 2), animated: true)
			} else {
				let vc = SubscriptionViewController()
				vc.modalPresentationStyle = .fullScreen
				vc.ana_scene = .guide
				self.navigationController?.present(vc, animated: true, completion: {
					self.navigationController?.navigationBar.isHidden = false
					self.navigationController?.viewControllers = [RecordViewController()]
					UserDefaults.standard.setValue(true, forKey: "Have_Start_Once")
				})
			}
		}
		ana_buttonBackView.addSubview(ana_button)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_gradient.frame = view.bounds
		ana_titleLabel.sizeToFit()
		ana_titleLabel.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.16)
		let imageWidth = min(385, view.width() - 29)
		ana_imageView.bounds = CGRect(origin: .zero, size: CGSize(width: imageWidth, height: imageWidth))
		ana_imageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.43)
		let size = ana_contentLabel.sizeThatFits(CGSize(width: view.width() - 40, height: .greatestFiniteMagnitude))
		ana_contentLabel.bounds = CGRect(origin: .zero, size: size)
		ana_contentLabel.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.74)
		ana_buttonBackView.frame = CGRect(x: 42, y: view.height() * 0.86 - 24, width: view.width() - 84, height: 48)
		ana_buttonShadowView.frame = ana_buttonBackView.bounds
		ana_buttonGradientView.frame = ana_buttonShadowView.frame
		ana_buttonGradientLayer.frame = ana_buttonGradientView.bounds
		ana_button.frame = ana_buttonGradientView.frame
	}
}
