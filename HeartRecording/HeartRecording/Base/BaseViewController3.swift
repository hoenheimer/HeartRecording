//
//  BaseViewController3.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/3.
//

import UIKit
import StoreKit
import ReactiveCocoa
import ReactiveSwift


class BaseViewController3: BaseViewController {
	var starsView: StarsView!
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		starsView.startAnimation()
	}
	
	
	override func configure() {
		super.configure()
		
		ana_backgroundImageView.isHidden = true
		
		ana_primaryLabel.text = "Rate Us"
		
		ana_secondaryLabel.text = "If you like our app, please rate us on the App Store. This is a great support for our team. Thank you!"
		
		starsView = StarsView()
		view.addSubview(starsView)
		
		ana_imageView.image = UIImage(named: "Base_3_Image")
		
		ana_button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			DispatchQueue.main.async {
				if #available(iOS 14.0, *) {
					if let windowScene = self.view.window?.windowScene {
						SKStoreReviewController.requestReview(in: windowScene)
					}
				} else {
					SKStoreReviewController.requestReview()
				}
			}
			let vc = SubscriptionViewController()
			vc.fromBase = true
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		starsView.layoutNow()
		starsView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.35)
		ana_imageView.sizeToFit()
		ana_imageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.56)
	}
}
