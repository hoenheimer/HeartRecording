//
//  AnaLargeTitleViewController.swift
//  totowallet
//
//  Created by Yuan Ana on 2021/1/21.
//

import Foundation
import UIKit


class AnaLargeTitleViewController: UIViewController, UIScrollViewDelegate {
	var rightBarButton: UIButton?
	var scrollView: LargeTitleScrollView!
    var gradient: CAGradientLayer!
	var titleBackView: UIView!
	var titleLabel: UILabel!
	var titleRightBarButton: UIButton?
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
        
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.color(hexString: "#fff5fb").cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 0.23)
        view.layer.addSublayer(gradient)
		
		scrollView = LargeTitleScrollView()
        scrollView.backgroundColor = .clear
		scrollView.delegate = self
		view.addSubview(scrollView)
		
		titleBackView = UIView()
		titleBackView.backgroundColor = .clear
        titleBackView.layer.masksToBounds = false
		scrollView.addSubview(titleBackView)
		
		titleLabel = UILabel()
		titleLabel.font = UIFont(name: "Merriweather-Regular", size: 28)
		titleLabel.textColor = .color(hexString: "#6a515e")
		titleLabel.text = "Title"
		titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 1)
		titleBackView.addSubview(titleLabel)
		
		contentView = UIView()
		contentView.backgroundColor = .clear
		scrollView.addSubview(contentView)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
        
        gradient.frame = view.bounds
		scrollView.frame = CGRect(x: 0, y: topSpacing(), width: view.bounds.width, height: view.bounds.height - topSpacing())
		titleLabel.sizeToFit()
		if let titleRightBarButton = titleRightBarButton {
			titleRightBarButton.center = CGPoint(x: view.width() - 25 - titleRightBarButton.halfWidth(),
												 y: max(titleLabel.maxY() - titleLabel.halfHeight(), titleRightBarButton.halfHeight()))
		}
		titleBackView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: titleLabel.bounds.height)
		titleLabel.center = CGPoint(x: AnaNavigationController.margin, y: titleLabel.bounds.height + 3.5)
		let contentHeight = layoutContentView()
		contentView.frame = CGRect(x: 0, y: titleBackView.frame.maxY, width: scrollView.bounds.width, height: contentHeight)
		scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: contentView.frame.maxY)
	}
	
	func maskLayerPath() -> CGPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: view.height()))
		let tabBarMinY = view.height() - 13 - bottomSpacing() - 82
		path.addLine(to: CGPoint(x: 0, y: tabBarMinY))
		path.addArc(withCenter: CGPoint(x: 80, y: tabBarMinY),
					radius: 80,
					startAngle: -1 * CGFloat.pi,
					endAngle: -0.5 * CGFloat.pi,
					clockwise: true)
		path.addLine(to: CGPoint(x: view.width() - 80, y: tabBarMinY - 80))
		path.addArc(withCenter: CGPoint(x: view.width() - 80, y: tabBarMinY - 160),
					radius: 80,
					startAngle: 0.5 * CGFloat.pi,
					endAngle: 0,
					clockwise: false)
		path.addLine(to: CGPoint(x: view.width(), y: view.height()))
		path.close()
		return path.cgPath
	}
	
	
	func judgmentTrueTitleHidden() {
		let hidden = scrollView.contentOffset.y < 52 - 7.5
		let textAttributes = [NSAttributedString.Key.foregroundColor : hidden ? UIColor.clear : UIColor.black]
		titleBackView.isHidden = !hidden
		rightBarButton?.isHidden = hidden
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
	
	
	func setRightBarItem(topButton: UIButton?, bottomButton: UIButton?, action: @escaping () -> Void) {
		rightBarButton = topButton
		if let topButton = topButton {
			topButton.isHidden = true
			topButton.reactive.controlEvents(.touchUpInside).observeValues {
				_ in
				action()
			}
			topButton.sizeToFit()
			navigationItem.rightBarButtonItem = UIBarButtonItem(customView: topButton)
		} else {
			navigationItem.rightBarButtonItem = nil
		}
		
		if titleRightBarButton != bottomButton {
			titleRightBarButton?.removeFromSuperview()
			titleRightBarButton = bottomButton
			if let bottomButton = bottomButton {
				bottomButton.reactive.controlEvents(.touchUpInside).observeValues {
					_ in
					action()
				}
				titleBackView.addSubview(bottomButton)
			}
		}
	}
	
	
	func setProRightBarItemIfNeeded() {
		if NBUserVipStatusManager.shard.getVipStatus() {
			setRightBarItem(topButton: nil, bottomButton: nil) {
				return
			}
		} else if titleRightBarButton == nil {
			let topButton = UIButton()
			topButton.setImage(UIImage(named: "NavigationBar_Pro_Top")?.reSizeImage(reSize: CGSize(width: 18, height: 18)), for: .normal)
			let bottomButton = UIButton()
			bottomButton.setImage(UIImage(named: "NavigationBar_Pro_Bottom"), for: .normal)
			bottomButton.sizeToFit()
			bottomButton.setShadow(color: .color(hexString: "#33bdaaa0"), offset: CGSize(width: 0, height: 7), radius: 20, opacity: 1)
			setRightBarItem(topButton: topButton, bottomButton: bottomButton) {
				[weak self]	in
				self?.showSubscriptionIfNeeded(handle: nil)
			}
		}
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
