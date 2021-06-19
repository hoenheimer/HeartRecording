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
	var gradient: 				CAGradientLayer!
	var titleLabel: 			UILabel!
	var imageView: 				UIImageView!
	var contentLabel: 			UILabel!
	var buttonBackView:         UIView!
	var buttonShadowView:       UIView!
	var buttonGradientView:		UIView!
	var buttonGradientLayer: 	CAGradientLayer!
	var button:                 UIButton!
	
	var index = 1
	
	
	convenience init(index: Int) {
		self.init()
		self.index = index
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
		EventManager.log(name: "GuideVC_\(index)_Show")
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		configure()
    }
	
	
	func configure() {
		gradient = CAGradientLayer()
		gradient.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
		view.layer.addSublayer(gradient)
		
		titleLabel = UILabel()
		titleLabel.layer.zPosition = 2
		titleLabel.text = index == 1 ? "Welcome to Angel!" : "Share your joy :)"
		titleLabel.textColor = .color(hexString: "#263238")
		titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 26)
		view.addSubview(titleLabel)
		
		imageView = UIImageView()
		imageView.layer.zPosition = 2
		imageView.image = UIImage(named: "Guide_Image\(index)")
		view.addSubview(imageView)
		
		contentLabel = UILabel()
		contentLabel.layer.zPosition = 2
		contentLabel.numberOfLines = 0
		let string = index == 1 ? "Use your phone to record your baby's heartbeat" : "Share the magic sounds with your family"
		let pStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		pStyle.alignment = .center
		pStyle.lineSpacing = 10
		contentLabel.attributedText = NSAttributedString(string: string,
														 attributes: [NSAttributedString.Key.foregroundColor : UIColor.color(hexString: "#FF725E"),
																	  NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20),
																	  NSAttributedString.Key.paragraphStyle : pStyle.copy()])
		view.addSubview(contentLabel)
		
		buttonBackView = UIView()
		buttonBackView.backgroundColor = .clear
		view.addSubview(buttonBackView)
		
		buttonGradientView = UIView()
		buttonGradientView.backgroundColor = .clear
		buttonBackView.addSubview(buttonGradientView)
		
		buttonShadowView = UIView()
		buttonShadowView.layer.cornerRadius = 24
		buttonShadowView.layer.borderWidth = 1
		buttonShadowView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
		buttonShadowView.backgroundColor = .color(hexString: "#FF5E5E")
		buttonShadowView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24)
		buttonBackView.addSubview(buttonShadowView)
		
		buttonGradientLayer = CAGradientLayer()
		buttonGradientLayer.cornerRadius = 24
		buttonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		buttonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		buttonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF474747").cgColor]
		buttonGradientView.layer.addSublayer(buttonGradientLayer)
		
		button = UIButton()
		button.backgroundColor = .clear
		button.setTitle("Continue", for: .normal)
		button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
		button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
		button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] button in
			guard let self = self else { return }
			EventManager.log(name: "Guidebutton_\(self.index)_tapped")
			if self.index == 1 {
				self.navigationController?.pushViewController(GuideViewController(index: 2), animated: true)
			} else {
				let vc = SubscriptionViewController()
				vc.modalPresentationStyle = .fullScreen
				vc.scene = .guide
				self.navigationController?.present(vc, animated: true, completion: {
					self.navigationController?.navigationBar.isHidden = false
					self.navigationController?.viewControllers = [RecordViewController()]
					UserDefaults.standard.setValue(true, forKey: "Have_Start_Once")
				})
			}
		}
		buttonBackView.addSubview(button)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		gradient.frame = view.bounds
		titleLabel.sizeToFit()
		titleLabel.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.16)
		let imageWidth = min(385, view.width() - 29)
		imageView.bounds = CGRect(origin: .zero, size: CGSize(width: imageWidth, height: imageWidth))
		imageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.43)
		let size = contentLabel.sizeThatFits(CGSize(width: view.width() - 40, height: .greatestFiniteMagnitude))
		contentLabel.bounds = CGRect(origin: .zero, size: size)
		contentLabel.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.74)
		buttonBackView.frame = CGRect(x: 42, y: view.height() * 0.86 - 24, width: view.width() - 84, height: 48)
		buttonShadowView.frame = buttonBackView.bounds
		buttonGradientView.frame = buttonShadowView.frame
		buttonGradientLayer.frame = buttonGradientView.bounds
		button.frame = buttonGradientView.frame
	}
}
