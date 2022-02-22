//
//  AnaLargeTitleTableViewController.swift
//  totowallet
//
//  Created by Yuan Ana on 2021/1/22.
//

import Foundation
import UIKit


class AnaLargeTitleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
	var rightBarButton: UIButton?
    var gradientView: UIView!
    var gradient: CAGradientLayer!
	var hintShapeLayer: CAShapeLayer!
	public var tableView: LargeTitleTableView!
	var titleBackView: UIView!
	var titleLabel: UILabel!
	var titleRightBarButton: UIButton?
	var subTitleLabel: UILabel!
	
	public var titleText: String?
	public var titleColor: UIColor?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		judgmentTrueTitleHidden()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .never
		
		configure()
	}
	
	
	func configure() {
		view.backgroundColor = .systemBackground
        
        gradient = CAGradientLayer()
		gradient.colors = [UIColor.color(hexString: "#fff0f2").cgColor, UIColor.color(hexString: "#fff6f8").cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradient)
		
		hintShapeLayer = CAShapeLayer()
		gradient.mask = hintShapeLayer
		
		tableView = LargeTitleTableView(frame: .zero, style: .grouped)
		tableView.separatorStyle = .none
		tableView.backgroundColor = .systemBackground
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 0
		tableView.estimatedSectionHeaderHeight = 0
		tableView.estimatedSectionFooterHeight = 0
		view.addSubview(tableView)
		
		titleBackView = TestView()
		titleBackView.backgroundColor = .clear
		
		titleLabel = UILabel()
		titleLabel.font = UIFont(name: "Merriweather-Regular", size: 28)
		titleLabel.textColor = .color(hexString: "#6a515e")
		titleLabel.text = "Title"
		titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 1)
		titleBackView.addSubview(titleLabel)
		
		subTitleLabel = UILabel()
		subTitleLabel.textColor = .black
		subTitleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 14)
		titleBackView.addSubview(subTitleLabel)
		
		if titleText != nil {
			setTitle(title: titleText!)
		}
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
        gradient.frame = view.bounds
		hintShapeLayer.frame = view.bounds
		hintShapeLayer.path = maskLayerPath()
		tableView.frame = CGRect(x: 0, y: topSpacing(), width: view.bounds.width, height: (view.height() - 13 - bottomSpacing() - 82) - topSpacing())
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
		let hidden = tableView.contentOffset.y < 52 - 7.5
		let textAttributes = [NSAttributedString.Key.foregroundColor : hidden ? UIColor.clear : (titleColor ?? UIColor.black)]
		titleBackView.isHidden = !hidden
		rightBarButton?.isHidden = hidden
		navigationController?.navigationBar.titleTextAttributes = textAttributes
	}
	
	
	func setTitle(title: String) {
		setTitle(title: title, subTitle: nil)
	}
	
	
	func setTitle(title: String, subTitle: String?) {
		navigationItem.title = title
		titleLabel.text = title
		if let subTitle = subTitle {
			subTitleLabel.text = "(" + subTitle + ")"
			subTitleLabel.isHidden = subTitle.count == 0
		}
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
	
	
	func setHeaderView(headerView: UIView?) {
		let backView = UIView()
		backView.backgroundColor = .clear
		backView.addSubview(titleBackView)
		titleLabel.sizeToFit()
		subTitleLabel.sizeToFit()
		titleBackView.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: titleLabel.bounds.height)
		titleLabel.center = CGPoint(x: AnaNavigationController.margin, y: titleLabel.bounds.height + 3.5)
		if let titleRightBarButton = titleRightBarButton {
			titleRightBarButton.center = CGPoint(x: view.width() - 25 - titleRightBarButton.halfWidth(),
												 y: max(titleLabel.maxY() - titleLabel.halfHeight(), titleRightBarButton.halfHeight()))
		}
		subTitleLabel.center = CGPoint(x: titleLabel.maxX() + 8 + subTitleLabel.halfWidth(), y: titleLabel.maxY() - subTitleLabel.halfHeight())
		titleBackView.center = CGPoint(x: titleBackView.halfWidth(), y: titleBackView.halfHeight())
		if let headerView = headerView {
			backView.addSubview(headerView)
			headerView.center = CGPoint(x: headerView.halfWidth(), y: titleBackView.maxY() + 16 + headerView.halfHeight())
			backView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: headerView.maxY())
		} else {
			backView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: titleBackView.maxY() + 56)
		}
		titleBackView.frame = CGRect(x: 0, y: 0, width: backView.width(), height: titleBackView.height())
		tableView.tableHeaderView = backView
        tableView.sendSubviewToBack(backView)
	}
	
	
	// MARK: - UIScrollViewDelegate
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView == self.tableView {
			judgmentTrueTitleHidden()
			if scrollView.contentOffset.y < 0 {
				let scale: CGFloat = min(1 - scrollView.contentOffset.y * 0.001, 1.1)
				titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
			} else {
				titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
			}
		}
	}
	
	
	// MARK: - UITableViewDelegate & UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		assert(false, "need to be overwrited")
		return 0
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		assert(false, "need to be overwrited")
		return UITableViewCell()
	}
}


class LargeTitleTableView: UITableView, UIGestureRecognizerDelegate {
//	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//		return true
//	}
}


class TestView: UIView {
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let result = super.hitTest(point, with: event)
		return result
	}
}
