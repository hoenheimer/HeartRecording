//
//  AnaLargeTitleViewController.swift
//  totowallet
//
//  Created by Yuan Ana on 2021/1/21.
//

import Foundation
import UIKit


class AnaLargeTitleViewController: UIViewController, UIScrollViewDelegate {
	var scrollView: LargeTitleScrollView!
    var gradient: CAGradientLayer!
	var titleBackView: UIView!
	var titleLabel: UILabel!
	var contentView: UIView!
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		judgmentTrueTitleHidden()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .never
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		
		configure()
	}
	
	
	func configure() {
		view.backgroundColor = .systemBackground
		
		scrollView = LargeTitleScrollView()
		scrollView.delegate = self
		view.addSubview(scrollView)
        
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        scrollView.layer.addSublayer(gradient)
		
		titleBackView = UIView()
		titleBackView.backgroundColor = .systemBackground
		scrollView.addSubview(titleBackView)
		
		titleLabel = UILabel()
		titleLabel.font = .boldSystemFont(ofSize: 32)
		titleLabel.textColor = .color(hexString: "#14142B")
		titleLabel.text = "Title"
		titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 1)
		titleBackView.addSubview(titleLabel)
		
		contentView = UIView()
		contentView.backgroundColor = .clear
		scrollView.addSubview(contentView)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		scrollView.frame = CGRect(x: 0, y: topSpacing(), width: view.bounds.width, height: view.bounds.height - topSpacing())
        gradient.frame = scrollView.bounds
		titleLabel.sizeToFit()
		titleBackView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: titleLabel.bounds.height)
		titleLabel.center = CGPoint(x: AnaNavigationController.margin, y: titleLabel.bounds.height + 3.5)
		let contentHeight = layoutContentView()
		contentView.frame = CGRect(x: 0, y: titleBackView.frame.maxY, width: scrollView.bounds.width, height: contentHeight)
		scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: contentView.frame.maxY)
	}
	
	
	func judgmentTrueTitleHidden() {
		let hidden = scrollView.contentOffset.y < 52 - 7.5
		let textAttributes = [NSAttributedString.Key.foregroundColor : hidden ? UIColor.clear : UIColor.black]
		titleBackView.isHidden = !hidden
		navigationController?.navigationBar.titleTextAttributes = textAttributes
	}
	
	
	//返回contentView高度
	func layoutContentView() -> CGFloat {
		assert(false, "need to be overwrited")
		return 0
	}
	
	
	func setTitle(title: String) {
		navigationItem.title = title
		titleLabel.text = title
	}
	
	
	// MARK: - UIScrollViewDelegate
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView == self.scrollView {
			judgmentTrueTitleHidden()
			if scrollView.contentOffset.y < 0 {
				let scale: CGFloat = min(1 - scrollView.contentOffset.y * 0.001, 1.1)
				titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
			} else {
				titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
			}
		}
	}
}


class LargeTitleScrollView: UIScrollView, UIGestureRecognizerDelegate {
	var hitView: UIView?
    var subViewsCanScroll = true
	
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		hitView = super.hitTest(point, with: event)
		return hitView
	}
		
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return subViewsCanScroll
	}
}
