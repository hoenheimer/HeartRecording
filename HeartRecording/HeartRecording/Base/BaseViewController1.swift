//
//  BaseViewController1.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/3.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class BaseViewController1: BaseViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: false)
		if let tabBarController = tabBarController as? AnaTabBarController {
			tabBarController.simulationTabBar.isHidden = true
		}
	}
	
	
	override func configure() {
		super.configure()
		
		shapeImageView.image = UIImage(named: "Base_1_Shape")
		
		primaryLabel.text = "Baby Care"
		
		secondaryLabel.text = "Track & Count your baby kicks"
		
		imageView.image = UIImage(named: "Base_1_Image")
		
		pageImageView1.setHighlighted(true)
		pageImageView2.setHighlighted(false)
		pageImageView3.setHighlighted(false)
		
		button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.navigationController?.pushViewController(BaseViewController2(), animated: true)
		}
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		shapeImageView.sizeToFit()
		shapeImageView.setOrigin(x: 0, y: 0)
		imageView.sizeToFit()
		imageView.center = CGPoint(x: view.halfWidth(), y: view.halfHeight())
	}
}
