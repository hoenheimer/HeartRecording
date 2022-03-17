//
//  AnaLargeTitleTableViewController.swift
//  totowallet
//
//  Created by Yuan Ana on 2021/1/22.
//

import Foundation
import UIKit


class AnaLargeTitleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
	var ana_rightBarButton: UIButton?
    var ana_gradientLayer: CAGradientLayer!
	var ana_shapeImageView: UIImageView!
	public var ana_tableView: LargeTitleTableView!
	var ana_titleBackView: UIView!
	var ana_titleLabel: UILabel!
	var ana_titleRightBarButton: UIButton?
	var ana_subTitleLabel: UILabel!
	
	public var ana_titleText: String?
	public var ana_titleColor: UIColor?
	var ana_rightButtonIsForPro = false
	
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
        
        ana_gradientLayer = CAGradientLayer()
		ana_gradientLayer.colors = [UIColor.color(hexString: "#fff5fb").cgColor, UIColor.white.cgColor]
		ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.23)
        view.layer.addSublayer(ana_gradientLayer)
		
		ana_shapeImageView = UIImageView(image: UIImage(named: "Global_Shape"))
		view.addSubview(ana_shapeImageView)
		
		ana_tableView = LargeTitleTableView(frame: .zero, style: .grouped)
		ana_tableView.separatorStyle = .none
		ana_tableView.backgroundColor = .clear
		ana_tableView.delegate = self
		ana_tableView.dataSource = self
		ana_tableView.estimatedRowHeight = 0
		ana_tableView.estimatedSectionHeaderHeight = 0
		ana_tableView.estimatedSectionFooterHeight = 0
		view.addSubview(ana_tableView)
		
		ana_titleBackView = UIView()
		ana_titleBackView.backgroundColor = .clear
		
		ana_titleLabel = UILabel()
		ana_titleLabel.font = UIFont(name: "Didot", size: 36)
		ana_titleLabel.textColor = .color(hexString: "#504278")
		ana_titleLabel.text = "Title"
		ana_titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 1)
		ana_titleBackView.addSubview(ana_titleLabel)
		
		ana_subTitleLabel = UILabel()
		ana_subTitleLabel.textColor = .black
		ana_subTitleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 14)
		ana_titleBackView.addSubview(ana_subTitleLabel)
		
		if ana_titleText != nil {
			setTitle(title: ana_titleText!)
		}
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
        ana_gradientLayer.frame = view.bounds
		ana_shapeImageView.sizeToFit()
		ana_shapeImageView.setOrigin(x: view.width() - ana_shapeImageView.width(), y: view.height() - ana_shapeImageView.height())
		ana_tableView.frame = CGRect(x: 0, y: topSpacing(), width: view.bounds.width, height: (view.height() - 13 - bottomSpacing() - 82) - topSpacing())
	}
	
	
	func judgmentTrueTitleHidden() {
		let hidden = ana_tableView.contentOffset.y < 52 - 7.5
		let textAttributes = [NSAttributedString.Key.foregroundColor : hidden ? UIColor.clear : (ana_titleColor ?? UIColor.black)]
		ana_titleBackView.isHidden = !hidden
		ana_rightBarButton?.isHidden = hidden
		navigationController?.navigationBar.titleTextAttributes = textAttributes
	}
	
	
	func setTitle(title: String) {
		setTitle(title: title, subTitle: nil)
	}
	
	
	func setTitle(title: String, subTitle: String?) {
		navigationItem.title = title
		ana_titleLabel.text = title
		if let subTitle = subTitle {
			ana_subTitleLabel.text = "(" + subTitle + ")"
			ana_subTitleLabel.isHidden = subTitle.count == 0
		}
	}
	
	
	func setRightBarItem(topButton: UIButton?, bottomButton: UIButton?, forPro: Bool = false, action: @escaping () -> Void) {
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
		
		ana_rightButtonIsForPro = forPro
	}
	
	
	func setProRightBarItemIfNeeded() {
		if NBUserVipStatusManager.shard.getVipStatus() {
			setRightBarItem(topButton: nil, bottomButton: nil) {
				return
			}
		} else if !ana_rightButtonIsForPro {
			let topButton = UIButton()
			topButton.setImage(UIImage(named: "NavigationBar_Pro_Top")?.reSizeImage(reSize: CGSize(width: 18, height: 18)), for: .normal)
			let bottomButton = UIButton()
			bottomButton.setImage(UIImage(named: "NavigationBar_Pro_Bottom"), for: .normal)
			bottomButton.sizeToFit()
			bottomButton.setShadow(color: .color(hexString: "#33bdaaa0"), offset: CGSize(width: 0, height: 7), radius: 20, opacity: 1)
			setRightBarItem(topButton: topButton, bottomButton: bottomButton, forPro: true) {
				[weak self]	in
				self?.showSubscriptionIfNeeded(handle: nil)
			}
		}
	}
	
	
	func setHeaderView(headerView: UIView?) {
		let backView = UIView()
		backView.backgroundColor = .clear
		backView.addSubview(ana_titleBackView)
		ana_titleLabel.sizeToFit()
		ana_subTitleLabel.sizeToFit()
		ana_titleBackView.bounds = CGRect(x: 0, y: 0, width: ana_tableView.bounds.width, height: ana_titleLabel.bounds.height)
		ana_titleLabel.center = CGPoint(x: AnaNavigationController.margin, y: ana_titleLabel.bounds.height + 3.5)
		if let titleRightBarButton = ana_titleRightBarButton {
			titleRightBarButton.center = CGPoint(x: view.width() - 25 - titleRightBarButton.halfWidth(),
												 y: max(ana_titleLabel.maxY() - ana_titleLabel.halfHeight(), titleRightBarButton.halfHeight()))
		}
		ana_subTitleLabel.center = CGPoint(x: ana_titleLabel.maxX() + 8 + ana_subTitleLabel.halfWidth(), y: ana_titleLabel.maxY() - ana_subTitleLabel.halfHeight())
		ana_titleBackView.center = CGPoint(x: ana_titleBackView.halfWidth(), y: ana_titleBackView.halfHeight())
		if let headerView = headerView {
			backView.addSubview(headerView)
			headerView.center = CGPoint(x: headerView.halfWidth(), y: ana_titleBackView.maxY() + 16 + headerView.halfHeight())
			backView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: headerView.maxY())
		} else {
			backView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: ana_titleBackView.maxY() + 56)
		}
		ana_titleBackView.frame = CGRect(x: 0, y: 0, width: backView.width(), height: ana_titleBackView.height())
		ana_tableView.tableHeaderView = backView
        ana_tableView.sendSubviewToBack(backView)
	}
	
	
	// MARK: - UIScrollViewDelegate
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView == self.ana_tableView {
			judgmentTrueTitleHidden()
			if scrollView.contentOffset.y < 0 {
				let scale: CGFloat = min(1 - scrollView.contentOffset.y * 0.001, 1.1)
				ana_titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
			} else {
				ana_titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
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
