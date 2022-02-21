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
	var hintImageView: UIImageView!
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
		setRightBarItem(image: UIImage(named: "Kick_Add")) {
			[weak self] in
			guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			let vc = AddKickCounterViewController()
			vc.modalPresentationStyle = .fullScreen
			self.present(vc, animated: true, completion: nil)
		}
		setHeaderView(headerView: nil)
		
		hintImageView = UIImageView(image: UIImage(named: "Kick_Hint"))
		view.addSubview(hintImageView)
		view.sendSubviewToBack(hintImageView)
		
		tableView.backgroundColor = .clear
		tableView.register(KickCounterTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(KickCounterTableViewCell.self)))
		tableView.rowHeight = 134
		
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
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		hintImageView.sizeToFit()
		hintImageView.setOrigin(x: 0, y: 0)
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
	var dateView: UIView!
	var dateGradientLayer: CAGradientLayer!
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
		backView.layer.cornerRadius = 25
		backView.backgroundColor = .white
		backView.setShadow(color: .color(hexString: "#0f933c49"), offset: CGSize(width: 0, height: 8), radius: 25, opacity: 1)
		addSubview(backView)
		
		dateView = UIView()
		addSubview(dateView)
		
		dateGradientLayer = CAGradientLayer()
		dateGradientLayer.colors = [UIColor.color(hexString: "#fff3ed").cgColor, UIColor.color(hexString: "#ffdde4").cgColor]
		dateGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		dateGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		dateGradientLayer.cornerRadius = 14
		dateView.layer.addSublayer(dateGradientLayer)
		
		dateLabel = UILabel()
		dateLabel.textColor = .color(hexString: "#6a515e")
		dateLabel.font = UIFont(name: "Poppins-Regular", size: 13)
		dateView.addSubview(dateLabel)
		
		func newTitleLabel(title: String?) -> UILabel {
			let label = UILabel()
			label.text = title
			label.textColor = .color(hexString: "#6a515e")
			label.font = UIFont(name: "Poppins-SemiBold", size: 16)
			backView.addSubview(label)
			return label
		}
		
		func newValueLabel() -> UILabel {
			let label = UILabel()
			label.textColor = UIColor.color(hexString: "#6a515e").withAlphaComponent(0.5)
			label.font = UIFont(name: "Inter-Regular", size: 13)
			backView.addSubview(label)
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
		
		backView.frame = CGRect(x: margin, y: 14, width: contentView.width() - margin * 2, height: 90)
		dateView.frame = CGRect(x: backView.minX() + 25, y: 0, width: 109, height: 28)
		dateGradientLayer.frame = dateView.bounds
		dateLabel.sizeToFit()
		dateLabel.center = CGPoint(x: dateView.halfWidth(), y: dateView.halfHeight())
		timeTitleLabel.sizeToFit()
		timeTitleLabel.setOrigin(x: 25, y: 28)
		timeValueLabel.sizeToFit()
		timeValueLabel.center = CGPoint(x: max(25 + timeValueLabel.halfWidth(), timeTitleLabel.centerX()), y: timeTitleLabel.maxY() + 8 + timeValueLabel.halfHeight())
		durationTitleLabel.sizeToFit()
		durationTitleLabel.center = CGPoint(x: backView.halfWidth(), y: timeTitleLabel.centerY())
		durationValueLabel.sizeToFit()
		durationValueLabel.center = CGPoint(x: durationTitleLabel.centerX(), y: timeValueLabel.centerY())
		kicksTitleLabel.sizeToFit()
		kicksTitleLabel.setOrigin(x: backView.width() - 25 - kicksTitleLabel.width(), y: timeTitleLabel.minY())
		kicksValueLabel.sizeToFit()
		kicksValueLabel.center = CGPoint(x: min(backView.width() - 25 - kicksValueLabel.halfWidth(), kicksTitleLabel.centerX()), y: timeValueLabel.centerY())
	}
	
	
	public func set(date: String, time: String, duration: String, kicks: String) {
		dateLabel.text = date
		timeValueLabel.text = time
		durationValueLabel.text = duration
		kicksValueLabel.text = kicks
		layoutNow()
	}
}
