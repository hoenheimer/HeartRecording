//
//  AnaLargeTitleTableViewController.swift
//  totowallet
//
//  Created by Yuan Ana on 2021/1/22.
//

import Foundation
import UIKit


class AnaLargeTitleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var gradientView: UIView!
    var gradient: CAGradientLayer!
	public var tableView: LargeTitleTableView!
	var titleBackView: UIView!
	var titleLabel: UILabel!
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
        gradient.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(gradient)
		
		tableView = LargeTitleTableView(frame: .zero, style: .grouped)
		tableView.separatorStyle = .none
		tableView.backgroundColor = .systemBackground
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 0
		tableView.estimatedSectionHeaderHeight = 0
		tableView.estimatedSectionFooterHeight = 0
		view.addSubview(tableView)
		
		titleBackView = UIView()
		titleBackView.backgroundColor = .clear
		
		titleLabel = UILabel()
		titleLabel.font = .boldSystemFont(ofSize: 34)
		titleLabel.textColor = .black
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
		tableView.frame = CGRect(x: 0, y: topSpacing(), width: view.bounds.width, height: view.bounds.height - topSpacing())
	}
	
	
	func judgmentTrueTitleHidden() {
		let hidden = tableView.contentOffset.y < 52 - 7.5
		let textAttributes = [NSAttributedString.Key.foregroundColor : hidden ? UIColor.clear : (titleColor ?? UIColor.black)]
		titleBackView.isHidden = !hidden
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
	
	
	func setHeaderView(headerView: UIView?) {
		let backView = UIView()
		backView.backgroundColor = .clear
		backView.addSubview(titleBackView)
		titleLabel.sizeToFit()
		subTitleLabel.sizeToFit()
		titleBackView.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: titleLabel.bounds.height)
		titleLabel.center = CGPoint(x: AnaNavigationController.margin, y: titleLabel.bounds.height + 3.5)
		subTitleLabel.center = CGPoint(x: titleLabel.maxX() + 8 + subTitleLabel.halfWidth(), y: titleLabel.maxY() - subTitleLabel.halfHeight())
		titleBackView.center = CGPoint(x: titleBackView.halfWidth(), y: titleBackView.halfHeight())
		if let headerView = headerView {
			backView.addSubview(headerView)
			headerView.center = CGPoint(x: headerView.halfWidth(), y: titleBackView.maxY() + 16 + headerView.halfHeight())
			backView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: headerView.maxY())
		} else {
			backView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: titleBackView.maxY() + 56)
		}
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
