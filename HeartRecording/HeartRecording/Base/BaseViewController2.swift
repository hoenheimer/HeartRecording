//
//  BaseViewController2.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/3.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class BaseViewController2: BaseViewController {
	override func configure() {
		super.configure()
		
		ana_primaryLabel.text = "Pre Eggers"
		
		ana_secondaryLabel.text = "Record and Share Baby Sounds "
		
		ana_imageView.image = UIImage(named: "Base_2_Image")
		
		ana_button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.navigationController?.pushViewController(BaseViewController3(), animated: true)
		}
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_imageView.sizeToFit()
		ana_imageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.51)
	}
}
