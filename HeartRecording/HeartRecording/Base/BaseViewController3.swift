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
	var starImageView: UIImageView!
	var starsView: StarsView!
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		starsView.startAnimation()
	}
	
	
	override func configure() {
		super.configure()
		
		starImageView = UIImageView(image: UIImage(named: "Base_3_Star"))
		view.addSubview(starImageView)
		view.sendSubviewToBack(starImageView)
		
		shapeImageView.image = UIImage(named: "Base_3_Shape")
		
		primaryLabel.text = "Rate Us"
		
		secondaryLabel.text = "If you like our app, please rate us on the App Store. This is a great support for our team. Thank you!"
		
		starsView = StarsView()
		view.addSubview(starsView)
		
		imageView.image = UIImage(named: "Base_3_Image")
		
		pageImageView1.setHighlighted(false)
		pageImageView2.setHighlighted(false)
		pageImageView3.setHighlighted(true)
		
		button.reactive.controlEvents(.touchUpInside).observeValues {
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
		
		starImageView.sizeToFit()
		starImageView.center = CGPoint(x: view.halfWidth(), y: topSpacing() + 6 + starImageView.halfHeight())
		shapeImageView.sizeToFit()
		shapeImageView.setOrigin(x: 0, y: view.height() - shapeImageView.height())
		starsView.layoutNow()
		starsView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.33)
		imageView.sizeToFit()
		imageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.58)
	}
}
