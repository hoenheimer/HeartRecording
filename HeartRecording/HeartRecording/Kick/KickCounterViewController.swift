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
	var ana_backView: UIView!
	var ana_dateView: UIView!
	var ana_dateGradientLayer: CAGradientLayer!
	var ana_dateLabel: UILabel!
	var ana_timeTitleLabel: UILabel!
	var ana_timeValueLabel: UILabel!
	var ana_durationTitleLabel: UILabel!
	var ana_durationValueLabel: UILabel!
	var ana_kicksTitleLabel: UILabel!
	var ana_kicksValueLabel: UILabel!
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		ana_backView = UIView()
		ana_backView.layer.cornerRadius = 25
		ana_backView.backgroundColor = .white
		ana_backView.setShadow(color: .color(hexString: "#0f933c49"), offset: CGSize(width: 0, height: 8), radius: 25, opacity: 1)
		addSubview(ana_backView)
		
		ana_dateView = UIView()
		addSubview(ana_dateView)
		
		ana_dateGradientLayer = CAGradientLayer()
		ana_dateGradientLayer.colors = [UIColor.color(hexString: "#fff3ed").cgColor, UIColor.color(hexString: "#ffdde4").cgColor]
		ana_dateGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		ana_dateGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		ana_dateGradientLayer.cornerRadius = 14
		ana_dateView.layer.addSublayer(ana_dateGradientLayer)
		
		ana_dateLabel = UILabel()
		ana_dateLabel.textColor = .color(hexString: "#6a515e")
		ana_dateLabel.font = UIFont(name: "Poppins-Regular", size: 13)
		ana_dateView.addSubview(ana_dateLabel)
		
		func newTitleLabel(title: String?) -> UILabel {
			let label = UILabel()
			label.text = title
			label.textColor = .color(hexString: "#6a515e")
			label.font = UIFont(name: "Poppins-SemiBold", size: 16)
			ana_backView.addSubview(label)
			return label
		}
		
		func newValueLabel() -> UILabel {
			let label = UILabel()
			label.textColor = UIColor.color(hexString: "#6a515e").withAlphaComponent(0.5)
			label.font = UIFont(name: "Inter-Regular", size: 13)
			ana_backView.addSubview(label)
			return label
		}
		
		ana_timeTitleLabel = newTitleLabel(title: "Time")
		ana_durationTitleLabel = newTitleLabel(title: "Duration")
		ana_kicksTitleLabel = newTitleLabel(title: "Kicks")
		ana_timeValueLabel = newValueLabel()
		ana_durationValueLabel = newValueLabel()
		ana_kicksValueLabel = newValueLabel()
	}
	
	
	override func layoutSubviews() {
		let margin = AnaNavigationController.margin
		
		ana_backView.frame = CGRect(x: margin, y: 14, width: contentView.width() - margin * 2, height: 90)
		ana_dateView.frame = CGRect(x: ana_backView.minX() + 25, y: 0, width: 109, height: 28)
		ana_dateGradientLayer.frame = ana_dateView.bounds
		ana_dateLabel.sizeToFit()
		ana_dateLabel.center = CGPoint(x: ana_dateView.halfWidth(), y: ana_dateView.halfHeight())
		ana_timeTitleLabel.sizeToFit()
		ana_timeTitleLabel.setOrigin(x: 25, y: 28)
		ana_timeValueLabel.sizeToFit()
		ana_timeValueLabel.center = CGPoint(x: max(25 + ana_timeValueLabel.halfWidth(), ana_timeTitleLabel.centerX()), y: ana_timeTitleLabel.maxY() + 8 + ana_timeValueLabel.halfHeight())
		ana_durationTitleLabel.sizeToFit()
		ana_durationTitleLabel.center = CGPoint(x: ana_backView.halfWidth(), y: ana_timeTitleLabel.centerY())
		ana_durationValueLabel.sizeToFit()
		ana_durationValueLabel.center = CGPoint(x: ana_durationTitleLabel.centerX(), y: ana_timeValueLabel.centerY())
		ana_kicksTitleLabel.sizeToFit()
		ana_kicksTitleLabel.setOrigin(x: ana_backView.width() - 25 - ana_kicksTitleLabel.width(), y: ana_timeTitleLabel.minY())
		ana_kicksValueLabel.sizeToFit()
		ana_kicksValueLabel.center = CGPoint(x: min(ana_backView.width() - 25 - ana_kicksValueLabel.halfWidth(), ana_kicksTitleLabel.centerX()), y: ana_timeValueLabel.centerY())
	}
	
	
	public func set(date: String, time: String, duration: String, kicks: String) {
		ana_dateLabel.text = date
		ana_timeValueLabel.text = time
		ana_durationValueLabel.text = duration
		ana_kicksValueLabel.text = kicks
		layoutNow()
	}
}
