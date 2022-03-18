//
//  RecordingListDeleteView.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/18.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa


class RecordingListDeleteView: UIView {
	var contentView: UIView!
	var primaryLabel: UILabel!
	var secondaryLabel: UILabel!
	var cancelButton: UIButton!
	var deleteButton: UIButton!
	
	static let shared = RecordingListDeleteView()
	var model: DbRecordModel!
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		backgroundColor = UIColor.black.withAlphaComponent(0.6)
		
		contentView = UIView()
		contentView.layer.cornerRadius = 17
		contentView.backgroundColor = .white
		addSubview(contentView)
		
		primaryLabel = UILabel()
		primaryLabel.text = "Are You Sure"
		primaryLabel.textColor = .color(hexString: "#504278")
		primaryLabel.font = UIFont(name: "PingFangSC-Semibold", size: 24)
		contentView.addSubview(primaryLabel)
		
		secondaryLabel = UILabel()
		secondaryLabel.text = "Are You Sure You Want To Delete This Recording?"
		secondaryLabel.textColor = UIColor.color(hexString: "#504278").withAlphaComponent(0.5)
		secondaryLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
		contentView.addSubview(secondaryLabel)
		
		cancelButton = UIButton()
		cancelButton.layer.cornerRadius = 12
		cancelButton.layer.borderWidth = 1
		cancelButton.layer.borderColor = UIColor.color(hexString: "#504278").cgColor
		cancelButton.setTitle("Cancel", for: .normal)
		cancelButton.setTitleColor(.color(hexString: "#504278"), for: .normal)
		cancelButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 13)
		cancelButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.removeFromSuperview()
		}
		contentView.addSubview(cancelButton)
		
		deleteButton = UIButton()
		deleteButton.layer.cornerRadius = 12
		deleteButton.backgroundColor = .color(hexString: "#8059f3")
		deleteButton.setTitle("Delete", for: .normal)
		deleteButton.setTitleColor(.white, for: .normal)
		deleteButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 13)
		deleteButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			DbManager.manager.deleteModel(self.model)
			self.removeFromSuperview()
		}
		contentView.addSubview(deleteButton)
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		primaryLabel.sizeToFit()
		primaryLabel.setOrigin(x: 18, y: 12)
		secondaryLabel.sizeToFit()
		secondaryLabel.setOrigin(x: 18, y: primaryLabel.maxY())
		let contentViewWidth = secondaryLabel.maxX() + 11
		let buttonWidth = (contentViewWidth - 14 * 2 - 12) / 2
		cancelButton.frame = CGRect(x: 14, y: secondaryLabel.maxY() + 15, width: buttonWidth, height: 38)
		deleteButton.frame = CGRect(x: cancelButton.maxX() + 12, y: cancelButton.minY(), width: buttonWidth, height: 38)
		contentView.bounds = CGRect(x: 0, y: 0, width: contentViewWidth, height: cancelButton.maxY() + 14)
		contentView.center = CGPoint(x: halfWidth(), y: height() * 0.47)
	}
	
	
	func show(model: DbRecordModel) {
		self.model = model
		if let keyWindow = UIApplication.shared.connectedScenes
			.filter({$0.activationState == .foregroundActive})
			.map({$0 as? UIWindowScene})
			.compactMap({$0})
			.first?.windows
			.filter({$0.isKeyWindow}).first {
			self.frame = keyWindow.bounds
			layoutNow()
			keyWindow.addSubview(self)
		}
	}
}
