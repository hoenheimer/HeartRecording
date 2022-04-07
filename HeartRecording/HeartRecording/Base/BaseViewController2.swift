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
		
		shapeImageView.image = UIImage(named: "Base_2_Shape")
		
		primaryLabel.text = "Baby Care"
		
		secondaryLabel.text = "Record and Share Baby Sounds "
		
		imageView.image = UIImage(named: "Base_2_Image")
		
		pageImageView1.setHighlighted(false)
		pageImageView2.setHighlighted(true)
		pageImageView3.setHighlighted(false)
		
		button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.navigationController?.pushViewController(BaseViewController3(), animated: true)
		}
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		shapeImageView.sizeToFit()
		shapeImageView.setOrigin(x: view.width() - shapeImageView.width(), y: view.height() - shapeImageView.height())
		imageView.sizeToFit()
		if imageView.width() > 0 {
			let scale = view.width() / imageView.width()
			imageView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: imageView.height() * scale)
		}
		imageView.center = CGPoint(x: view.halfWidth(), y: view.halfHeight())
	}
}
