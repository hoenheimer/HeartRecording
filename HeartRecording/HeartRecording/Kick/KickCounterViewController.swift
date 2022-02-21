//
//  KickCounterViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/5/17.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class KickCounterViewController: AnaLargeTitleTableViewController {
	var ana_emptyView: UIView!
	var ana_emptyImageView: UIImageView!
	var ana_emptyLabel: UILabel!
	
	var ana_models: [DbKicksModel]!
	
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	
	override func configure() {
		super.configure()
		
		NotificationCenter.default.addObserver(self, selector: #selector(dbDidChanged), name: NotificationName.DbKicksChange, object: nil)
		
		ana_models = DbManager.manager.kickModels()
		
		setTitle(title: "Kick Counter")
		setHeaderView(headerView: nil)
		
		tableView.backgroundColor = .clear
		tableView.register(KickCounterTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(KickCounterTableViewCell.self)))
		tableView.rowHeight = 100
		
		ana_emptyView = UIView()
		ana_emptyView.backgroundColor = .clear
		ana_emptyView.isHidden = ana_models.count > 0
		tableView.addSubview(ana_emptyView)
		
		ana_emptyImageView = UIImageView()
		ana_emptyImageView.image = UIImage(named: "Kick_Empty")
		ana_emptyView.addSubview(ana_emptyImageView)
		
		ana_emptyLabel = UILabel()
		ana_emptyLabel.text = "No Data！"
		ana_emptyLabel.textColor = .black
		ana_emptyLabel.font = .systemFont(ofSize: 16)
		ana_emptyView.addSubview(ana_emptyLabel)
		
		let button = UIButton()
		button.setImage(UIImage(named: "Kick_Add"), for: .normal)
		button.sizeToFit()
		button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			let vc = AddKickCounterViewController()
			vc.modalPresentationStyle = .fullScreen
			self.present(vc, animated: true, completion: nil)
		}
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_emptyImageView.sizeToFit()
		ana_emptyImageView.setOrigin(x: 0, y: 0)
		ana_emptyLabel.sizeToFit()
		ana_emptyLabel.center = CGPoint(x: ana_emptyImageView.halfWidth(), y: ana_emptyImageView.maxY() - 2 + ana_emptyLabel.halfHeight())
		ana_emptyView.bounds = CGRect(origin: .zero, size: CGSize(width: ana_emptyImageView.width(), height: ana_emptyLabel.maxY()))
		ana_emptyView.center = CGPoint(x: tableView.halfWidth(), y: 265)
	}
	
	
	@objc func dbDidChanged() {
		ana_models = DbManager.manager.kickModels()
		tableView.reloadData()
		ana_emptyView.isHidden = ana_models.count > 0
	}
	
	
	// MARK: - UITableViewDelegate & UITableViewDataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ana_models.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(NSStringFromClass(KickCounterTableViewCell.self)), for: indexPath) as! KickCounterTableViewCell
		let model = ana_models[indexPath.row]
		if let date = DbManager.manager.dateFormatter.date(from: model.date!) {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd MMM yyyy"
			let dayString = dateFormatter.string(from: date)
			dateFormatter.dateFormat = "h:mm a"
			let timeString = dateFormatter.string(from: date)
			var seconds = model.duration ?? 0
			var minutes = 0
			while seconds >= 60 {
				seconds -= 60
				minutes += 1
			}
			var durationString = ""
			if minutes > 0 {
				durationString.append("\(minutes)m")
			}
			durationString.append("\(seconds)s")
			cell.set(date: dayString, time: timeString, duration: durationString, kicks: "\(model.kicks ?? 0)")
		}
		
		
		return cell
	}
}


class KickCounterTableViewCell: UITableViewCell {
	var backView: UIView!
	var gradientLayer: CAGradientLayer!
	var backContentView: UIView!
	var dateLabel: UILabel!
	var timeTitleLabel: UILabel!
	var timeValueLabel: UILabel!
	var durationTitleLabel: UILabel!
	var durationValueLabel: UILabel!
	var kicksTitleLabel: UILabel!
	var kicksValueLabel: UILabel!
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		backView = UIView()
		backView.layer.cornerRadius = 12
		backView.layer.borderWidth = 1
		backView.layer.borderColor = UIColor.color(hexString: "#80FFFFFF").cgColor
		backView.backgroundColor = .color(hexString: "#CCFFFFFF")
		backView.setShadow(color: .color(hexString: "#1e6e7191"), offset: CGSize(width: 0, height: 8), radius: 32, opacity: 1)
		addSubview(backView)
		
		gradientLayer = CAGradientLayer()
		gradientLayer.colors = [UIColor.color(hexString: "#e6ffffff").cgColor, UIColor.color(hexString: "#b3ffffff").cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.cornerRadius = 12
		backView.layer.addSublayer(gradientLayer)
		
		backContentView = UIView()
		backContentView.backgroundColor = .clear
		backContentView.layer.zPosition = 2
		backView.addSubview(backContentView)
		
		dateLabel = UILabel()
		dateLabel.textColor = .color(hexString: "#6e7191")
		dateLabel.font = UIFont(name: "Inter-Regular", size: 13)
		backContentView.addSubview(dateLabel)
		
		func newTitleLabel(title: String?) -> UILabel {
			let label = UILabel()
			label.text = title
			label.textColor = .color(hexString: "#14142b")
			label.font = UIFont(name: "Poppins-SemiBold", size: 16)
			backContentView.addSubview(label)
			return label
		}
		
		func newValueLabel() -> UILabel {
			let label = UILabel()
			label.textColor = .color(hexString: "#6e7191")
			label.font = UIFont(name: "Inter-Regular", size: 13)
			backContentView.addSubview(label)
			return label
		}
		
		timeTitleLabel = newTitleLabel(title: "Time")
		durationTitleLabel = newTitleLabel(title: "Duration")
		kicksTitleLabel = newTitleLabel(title: "Kicks")
		timeValueLabel = newValueLabel()
		durationValueLabel = newValueLabel()
		kicksValueLabel = newValueLabel()
	}
	
	
	override func layoutSubviews() {
		let margin = AnaNavigationController.margin
		
		backView.frame = CGRect(x: margin, y: 0, width: contentView.width() - margin * 2, height: 85)
		gradientLayer.frame = backView.bounds
		backContentView.frame = backView.bounds
		dateLabel.sizeToFit()
		dateLabel.setOrigin(x: 24, y: 8)
		timeTitleLabel.sizeToFit()
		timeTitleLabel.setOrigin(x: 24, y: dateLabel.maxY() + 4)
		timeValueLabel.sizeToFit()
		timeValueLabel.center = CGPoint(x: max(24 + timeValueLabel.halfWidth(), timeTitleLabel.centerX()), y: timeTitleLabel.maxY() + 2 + timeValueLabel.halfHeight())
		durationTitleLabel.sizeToFit()
		durationTitleLabel.center = CGPoint(x: backContentView.halfWidth(), y: timeTitleLabel.centerY())
		durationValueLabel.sizeToFit()
		durationValueLabel.center = CGPoint(x: durationTitleLabel.centerX(), y: timeValueLabel.centerY())
		kicksTitleLabel.sizeToFit()
		kicksTitleLabel.setOrigin(x: backContentView.width() - 24 - kicksTitleLabel.width(), y: timeTitleLabel.minY())
		kicksValueLabel.sizeToFit()
		kicksValueLabel.center = CGPoint(x: min(backContentView.width() - 24 - kicksValueLabel.halfWidth(), kicksTitleLabel.centerX()), y: timeValueLabel.centerY())
	}
	
	
	public func set(date: String, time: String, duration: String, kicks: String) {
		dateLabel.text = date
		timeValueLabel.text = time
		durationValueLabel.text = duration
		kicksValueLabel.text = kicks
		layoutNow()
	}
}
