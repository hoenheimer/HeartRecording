//
//  KickCounterViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/5/17.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SafariServices


class KickCounterViewController: AnaLargeTitleTableViewController, UITextViewDelegate {
	var hintImageView: UIImageView!
	var ana_emptyView: UIView!
	var ana_emptyImageView: UIImageView!
	var ana_emptyLabel: UILabel!
	var emptyButton: UIButton!
	
	var linkView: UIView!
	var linkGradientLayer: CAGradientLayer!
	var linkImageView: UIImageView!
	var linkTextView: UITextView!
	var linkCloseButton: UIButton!
	
	var ana_models: [DbKicksModel]!
	
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if ana_models.count == 0 {
			setProRightBarItemIfNeeded()
		}
	}
	
	
	override func configure() {
		super.configure()
		
		NotificationCenter.default.addObserver(self, selector: #selector(dbDidChanged), name: NotificationName.DbKicksChange, object: nil)
		
		ana_models = DbManager.manager.kickModels()
		
		setTitle(title: "BabyHear")
		if ana_models.count > 0 {
			let topButton = UIButton()
			topButton.setImage(UIImage(named: "Kick_Add_Small"), for: .normal)
			let bottomButton = UIButton()
			bottomButton.setImage(UIImage(named: "Kick_Add"), for: .normal)
			bottomButton.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
			bottomButton.backgroundColor = .color(hexString: "#9dc379")
			bottomButton.layer.cornerRadius = 24
			bottomButton.setShadow(color: .color(hexString: "#70f8e6e6"), offset: CGSize(width: 0, height: 5), radius: 25, opacity: 1)
			setRightBarItem(topButton: topButton, bottomButton: bottomButton) {
				[weak self] in
				guard let self = self else { return }
				FeedbackManager.feedback(type: .light)
				self.navigationController?.pushViewController(AddKickCounterViewController(), animated: true)
			}
		} else {
			setProRightBarItemIfNeeded()
		}
		setHeaderView(headerView: nil)
		
		hintImageView = UIImageView(image: UIImage(named: "Kick_Background"))
		view.addSubview(hintImageView)
		view.sendSubviewToBack(hintImageView)
		
		ana_tableView.backgroundColor = .clear
		ana_tableView.register(KickCounterTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(KickCounterTableViewCell.self)))
		ana_tableView.rowHeight = 112
		
		ana_emptyView = UIView()
		ana_emptyView.backgroundColor = .clear
		ana_emptyView.isHidden = ana_models.count > 0
		ana_tableView.addSubview(ana_emptyView)
		
		ana_emptyImageView = UIImageView()
		ana_emptyImageView.image = UIImage(named: "Kick_Empty")
		ana_emptyView.addSubview(ana_emptyImageView)
		
		ana_emptyLabel = UILabel()
		ana_emptyLabel.text = "No Data!"
		ana_emptyLabel.textColor = .color(hexString: "#504278")
		ana_emptyLabel.font = UIFont(name: "Didot", size: 16)
		ana_emptyView.addSubview(ana_emptyLabel)
		
		emptyButton = UIButton()
		emptyButton.isHidden = ana_models.count > 0
		emptyButton.layer.cornerRadius = 27
		emptyButton.backgroundColor = .color(hexString: "#8059f3")
		emptyButton.setTitle("Add", for: .normal)
		emptyButton.setTitleColor(.white, for: .normal)
		emptyButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
		emptyButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			self.navigationController?.pushViewController(AddKickCounterViewController(), animated: true)
		}
		ana_tableView.addSubview(emptyButton)
		
		linkView = UIView()
		linkView.isHidden = UserDefaults.standard.bool(forKey: "Have_Closed_Link")
		view.addSubview(linkView)
		
		linkGradientLayer = CAGradientLayer()
		linkGradientLayer.cornerRadius = 14
		linkGradientLayer.colors = [UIColor.color(hexString: "#d0c0ff").withAlphaComponent(0.3).cgColor, UIColor.color(hexString: "#f9f8ff").withAlphaComponent(0.3).cgColor]
		linkGradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
		linkGradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
		linkView.layer.addSublayer(linkGradientLayer)
		
		linkImageView = UIImageView(image: UIImage(named: "Kick_Link"))
		linkView.addSubview(linkImageView)
		
		linkTextView = UITextView()
		linkTextView.backgroundColor = .clear
		linkTextView.delegate = self
		linkTextView.isEditable = false
		let attributedString = NSMutableAttributedString(string: "Health information source: Baby Movement, (Nati-onal Health Service).",
														 attributes: [.font : UIFont(name: "Poppins-Regular", size: 12)!,
															.foregroundColor : UIColor.color(hexString: "#504278")])
		attributedString.addAttribute(.link, value: "https://www.nhs.uk/pregnancy/keeping-well/your-babys-movements/", range: NSRange(location: 27, length: 41))
		linkTextView.attributedText = attributedString
		linkTextView.textContainer.lineFragmentPadding = 0
		linkTextView.textContainerInset = .zero
		linkView.addSubview(linkTextView)
		
		linkCloseButton = UIButton()
		linkCloseButton.setImage(UIImage(named: "Kick_Link_Close"), for: .normal)
		linkCloseButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.linkView.isHidden = true
			UserDefaults.standard.set(true, forKey: "Have_Closed_Link")
		}
		linkView.addSubview(linkCloseButton)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		hintImageView.sizeToFit()
		hintImageView.setOrigin(x: 0, y: 0)
		ana_emptyImageView.sizeToFit()
		ana_emptyImageView.setOrigin(x: 0, y: 0)
		ana_emptyLabel.sizeToFit()
		ana_emptyLabel.center = CGPoint(x: ana_emptyImageView.halfWidth(), y: ana_emptyImageView.maxY() + 6 + ana_emptyLabel.halfHeight())
		ana_emptyView.bounds = CGRect(origin: .zero, size: CGSize(width: ana_emptyImageView.width(), height: ana_emptyLabel.maxY()))
		ana_emptyView.center = CGPoint(x: ana_tableView.halfWidth(), y: ana_tableView.halfHeight())
		emptyButton.bounds = CGRect(x: 0, y: 0, width: 250, height: 54)
		emptyButton.center = CGPoint(x: ana_tableView.halfWidth(), y: ana_tableView.height() * 0.8)
		linkView.frame = CGRect(x: 24, y: view.height() - bottomSpacing() - 12 - 52, width: view.width() - 24 * 2, height: 52)
		linkGradientLayer.frame = linkView.bounds
		linkImageView.sizeToFit()
		linkImageView.setOrigin(x: 10, y: 8)
		linkCloseButton.sizeToFit()
		linkCloseButton.setOrigin(x: linkView.width() - 7 - linkCloseButton.width(), y: 7)
		let size = linkTextView.sizeThatFits(CGSize(width: linkCloseButton.minX() - 7 - linkImageView.maxX() - 4, height: .greatestFiniteMagnitude))
		linkTextView.frame = CGRect(x: linkImageView.maxX() + 4, y: 7, width: size.width, height: size.height)
	}
	
	
	@objc func dbDidChanged() {
		ana_models = DbManager.manager.kickModels()
		ana_tableView.reloadData()
		ana_emptyView.isHidden = ana_models.count > 0
		emptyButton.isHidden = ana_models.count > 0
		
		if ana_models.count > 0 {
			let topButton = UIButton()
			topButton.setImage(UIImage(named: "Kick_Add"), for: .normal)
			let bottomButton = UIButton()
			bottomButton.setImage(UIImage(named: "Kick_Add"), for: .normal)
			bottomButton.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
			bottomButton.backgroundColor = .white
			bottomButton.layer.cornerRadius = 24
			bottomButton.setShadow(color: .color(hexString: "#70f8e6e6"), offset: CGSize(width: 0, height: 5), radius: 25, opacity: 1)
			setRightBarItem(topButton: topButton, bottomButton: bottomButton) {
				[weak self] in
				guard let self = self else { return }
				FeedbackManager.feedback(type: .light)
				self.navigationController?.pushViewController(AddKickCounterViewController(), animated: true)
			}
		} else {
			setProRightBarItemIfNeeded()
		}
		setHeaderView(headerView: nil)
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
	
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.1
	}
	
	
	// MARK: - UITextViewDelegate
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = SFSafariViewController(url: URL)
        present(vc, animated: true)
		return false
	}
}


class KickCounterTableViewCell: UITableViewCell {
	var ana_backView: UIView!
	var ana_backContentView: UIView!
	var ana_dateView: UIView!
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
		ana_backView.layer.cornerRadius = 14
		ana_backView.backgroundColor = .white
		ana_backView.setShadow(color: .color(hexString: "#079732fc"), offset: CGSize(width: 0, height: 8), radius: 18, opacity: 1)
		addSubview(ana_backView)
		
		ana_backContentView = UIView()
		ana_backContentView.layer.cornerRadius = 14
		ana_backContentView.layer.masksToBounds = true
		ana_backView.addSubview(ana_backContentView)
		
		ana_dateView = UIView()
		ana_dateView.layer.cornerRadius = 14
		ana_dateView.backgroundColor = .color(hexString: "#fff5fb")
		ana_backContentView.addSubview(ana_dateView)
		
		ana_dateLabel = UILabel()
		ana_dateLabel.textColor = .color(hexString: "#8059f3")
		ana_dateLabel.font = UIFont(name: "Poppins-Regular", size: 12)
		ana_dateView.addSubview(ana_dateLabel)
		
		func newTitleLabel(title: String?) -> UILabel {
			let label = UILabel()
			label.text = title
			label.textColor = .color(hexString: "#808059f3")
			label.font = UIFont(name: "Poppins-Medium", size: 16)
			ana_backContentView.addSubview(label)
			return label
		}
		
		func newValueLabel() -> UILabel {
			let label = UILabel()
			label.textColor = .color(hexString: "#504278")
			label.font = UIFont(name: "Inter-Regular", size: 14)
			ana_backContentView.addSubview(label)
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
		
		ana_backView.frame = CGRect(x: margin, y: 0, width: contentView.width() - margin * 2, height: 90)
		ana_backContentView.frame = ana_backView.bounds
		ana_dateView.frame = CGRect(x: -14, y: -14, width: 104 + 14, height: 24 + 14)
		ana_dateLabel.sizeToFit()
		ana_dateLabel.center = CGPoint(x: ana_dateView.halfWidth() + 7, y: ana_dateView.halfHeight() + 7)
		ana_timeTitleLabel.sizeToFit()
		ana_timeTitleLabel.center = CGPoint(x: 46, y: 42)
		ana_timeValueLabel.sizeToFit()
		ana_timeValueLabel.center = CGPoint(x: ana_timeTitleLabel.centerX(), y: ana_timeTitleLabel.maxY() + 6 + ana_timeValueLabel.halfHeight())
		ana_durationTitleLabel.sizeToFit()
		ana_durationTitleLabel.center = CGPoint(x: ana_backView.halfWidth(), y: ana_timeTitleLabel.centerY())
		ana_durationValueLabel.sizeToFit()
		ana_durationValueLabel.center = CGPoint(x: ana_durationTitleLabel.centerX(), y: ana_timeValueLabel.centerY())
		ana_kicksTitleLabel.sizeToFit()
		ana_kicksTitleLabel.center = CGPoint(x: ana_backView.width() - 46, y: ana_timeTitleLabel.centerY())
		ana_kicksValueLabel.sizeToFit()
		ana_kicksValueLabel.center = CGPoint(x: ana_kicksTitleLabel.centerX(), y: ana_timeValueLabel.centerY())
	}
	
	
	public func set(date: String, time: String, duration: String, kicks: String) {
		ana_dateLabel.text = date
		ana_timeValueLabel.text = time
		ana_durationValueLabel.text = duration
		ana_kicksValueLabel.text = kicks
		layoutNow()
	}
}
