//
//  SettingTableViewCell.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/3/18.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
	var iconImageView: UIImageView!
	var titleLabel: UILabel!
	var arrowImageView: UIImageView!
	var separateLine: UIView!
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		backgroundColor = .clear
		contentView.backgroundColor = .clear
		selectionStyle = .none
		
		iconImageView = UIImageView()
		contentView.addSubview(iconImageView)
		
		titleLabel = UILabel()
		titleLabel.textColor = .color(hexString: "#504278")
		titleLabel.font = UIFont(name: "Poppins-Regular", size: 14)
		contentView.addSubview(titleLabel)
		
		arrowImageView = UIImageView(image: UIImage(named: "Setting_Arrow"))
		contentView.addSubview(arrowImageView)
		
		separateLine = UIView()
		separateLine.backgroundColor = UIColor.color(hexString: "#8059f3").withAlphaComponent(0.2)
		contentView.addSubview(separateLine)
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let margin: CGFloat = 24
		iconImageView.sizeToFit()
		iconImageView.center = CGPoint(x: margin + iconImageView.halfWidth(), y: contentView.halfHeight())
		titleLabel.sizeToFit()
		titleLabel.center = CGPoint(x: iconImageView.maxX() + 14 + titleLabel.halfWidth(), y: contentView.halfHeight())
		arrowImageView.sizeToFit()
		arrowImageView.center = CGPoint(x: contentView.width() - margin - arrowImageView.halfWidth(), y: contentView.halfHeight())
		separateLine.frame = CGRect(x: margin, y: contentView.height() - 0.4, width: contentView.width() - margin * 2, height: 0.4)
	}
	
	
	public func set(imageName: String, title: String?) {
		iconImageView.image = UIImage(named: imageName)
		titleLabel.text = title
		layoutNow()
	}
}
