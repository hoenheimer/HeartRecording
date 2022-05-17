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
			tabBarController.ana_simulationTabBar.isHidden = true
		}
	}
	
	
	override func configure() {
		super.configure()
		
		ana_primaryLabel.text = "BabyHear"
		
		ana_secondaryLabel.text = "Track & Count Your Baby Kicks"
		
		ana_imageView.image = UIImage(named: "Base_1_Image")
		
		ana_button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.navigationController?.pushViewController(BaseViewController2(), animated: true)
		}
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_imageView.sizeToFit()
		ana_imageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.51)
	}
}
