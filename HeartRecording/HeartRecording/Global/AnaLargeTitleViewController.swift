//
//  AnaLargeTitleViewController.swift
//  totowallet
//
//  Created by Yuan Ana on 2021/1/21.
//

import Foundation
import UIKit


class AnaLargeTitleViewController: UIViewController, UIScrollViewDelegate {
	var ana_rightBarButton: UIButton?
	var ana_scrollView: LargeTitleScrollView!
    var ana_gradient: CAGradientLayer!
	var ana_shapeImageView: UIImageView!
	var ana_titleBackView: UIView!
	var ana_titleLabel: UILabel!
	var ana_titleRightBarButton: UIButton?
	var ana_contentView: UIView!
	
	
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
        
        ana_gradient = CAGradientLayer()
        ana_gradient.colors = [UIColor.color(hexString: "#fff5fb").cgColor, UIColor.white.cgColor]
        ana_gradient.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradient.endPoint = CGPoint(x: 0.5, y: 0.23)
        view.layer.addSublayer(ana_gradient)
		
		ana_shapeImageView = UIImageView(image: UIImage(named: "Global_Shape"))
		view.addSubview(ana_shapeImageView)
		
		ana_scrollView = LargeTitleScrollView()
        ana_scrollView.backgroundColor = .clear
		ana_scrollView.delegate = self
		view.addSubview(ana_scrollView)
		
		ana_titleBackView = UIView()
		ana_titleBackView.backgroundColor = .clear
        ana_titleBackView.layer.masksToBounds = false
		ana_scrollView.addSubview(ana_titleBackView)
		
		ana_titleLabel = UILabel()
		ana_titleLabel.font = UIFont(name: "Merriweather-Regular", size: 28)
		ana_titleLabel.textColor = .color(hexString: "#6a515e")
		ana_titleLabel.text = "Title"
		ana_titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 1)
		ana_titleBackView.addSubview(ana_titleLabel)
		
		ana_contentView = UIView()
		ana_contentView.backgroundColor = .clear
		ana_scrollView.addSubview(ana_contentView)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
        
        ana_gradient.frame = view.bounds
		ana_shapeImageView.sizeToFit()
		ana_shapeImageView.setOrigin(x: view.width() - ana_shapeImageView.width(), y: view.height() - ana_shapeImageView.height())
		ana_scrollView.frame = CGRect(x: 0, y: topSpacing(), width: view.bounds.width, height: view.bounds.height - topSpacing())
		ana_titleLabel.sizeToFit()
		if let titleRightBarButton = ana_titleRightBarButton {
			titleRightBarButton.center = CGPoint(x: view.width() - 25 - titleRightBarButton.halfWidth(),
												 y: max(ana_titleLabel.maxY() - ana_titleLabel.halfHeight(), titleRightBarButton.halfHeight()))
		}
		ana_titleBackView.frame = CGRect(x: 0, y: 0, width: ana_scrollView.bounds.width, height: ana_titleLabel.bounds.height)
		ana_titleLabel.center = CGPoint(x: AnaNavigationController.margin, y: ana_titleLabel.bounds.height + 3.5)
		let contentHeight = layoutContentView()
		ana_contentView.frame = CGRect(x: 0, y: ana_titleBackView.frame.maxY, width: ana_scrollView.bounds.width, height: contentHeight)
		ana_scrollView.contentSize = CGSize(width: ana_scrollView.bounds.width, height: ana_contentView.frame.maxY)
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
		let hidden = ana_scrollView.contentOffset.y < 52 - 7.5
		let textAttributes = [NSAttributedString.Key.foregroundColor : hidden ? UIColor.clear : UIColor.black]
		ana_titleBackView.isHidden = !hidden
		ana_rightBarButton?.isHidden = hidden
		navigationController?.navigationBar.titleTextAttributes = textAttributes
	}
	
	
	//返回contentView高度
	func layoutContentView() -> CGFloat {
		assert(false, "need to be overwrited")
		return 0
	}
	
	
	func setTitle(title: String) {
		navigationItem.title = title
		ana_titleLabel.text = title
	}
	
	
	func setRightBarItem(topButton: UIButton?, bottomButton: UIButton?, action: @escaping () -> Void) {
		ana_rightBarButton = topButton
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
		
		if ana_titleRightBarButton != bottomButton {
			ana_titleRightBarButton?.removeFromSuperview()
			ana_titleRightBarButton = bottomButton
			if let bottomButton = bottomButton {
				bottomButton.reactive.controlEvents(.touchUpInside).observeValues {
					_ in
					action()
				}
				ana_titleBackView.addSubview(bottomButton)
			}
		}
	}
	
	
	func setProRightBarItemIfNeeded() {
		if NBUserVipStatusManager.shard.getVipStatus() {
			setRightBarItem(topButton: nil, bottomButton: nil) {
				return
			}
		} else if ana_titleRightBarButton == nil {
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
		if scrollView == self.ana_scrollView {
			judgmentTrueTitleHidden()
			if scrollView.contentOffset.y < 0 {
				let scale: CGFloat = min(1 - scrollView.contentOffset.y * 0.001, 1.1)
				ana_titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
			} else {
				ana_titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
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
