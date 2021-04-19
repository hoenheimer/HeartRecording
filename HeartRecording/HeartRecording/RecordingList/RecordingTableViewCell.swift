//
//  RecordingTableViewCell.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit
import SwipeCellKit


class RecordingTableViewCell: SwipeTableViewCell {
    var backView: UIView!
    var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    var startImageView: UIImageView!
    var labelsBackView: UIView!
    var nameLabel: UILabel!
    var dateLabel: UILabel!
    var likeButton: UIButton!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    func configure() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        backView = UIView()
        backView.layer.cornerRadius = 12
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.color(hexString: "#80FFFFFF").cgColor
        backView.backgroundColor = .color(hexString: "#CDFFFFFF")
        backView.setShadow(color: .color(hexString: "#1E6E7191"), offset: CGSize(width: 0, height: 8), radius: 32)
        contentView.addSubview(backView)
        
        gradientView = UIView()
        gradientView.layer.cornerRadius = 12
        backView.addSubview(gradientView)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 12
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [UIColor.color(hexString: "#E6FFFFFF").cgColor, UIColor.color(hexString: "#B3FFFFFF").cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        startImageView = UIImageView()
        startImageView.image = UIImage(named: "RecordingList_Start")
        backView.addSubview(startImageView)
        
        labelsBackView = UIView()
        labelsBackView.backgroundColor = .clear
        backView.addSubview(labelsBackView)
        
        nameLabel = UILabel()
        nameLabel.textColor = .color(hexString: "#14142B")
        nameLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        labelsBackView.addSubview(nameLabel)
        
        dateLabel = UILabel()
        dateLabel.textColor = .color(hexString: "#6E7191")
        dateLabel.font = UIFont(name: "Inter-Regular", size: 13)
        labelsBackView.addSubview(dateLabel)
        
        likeButton = UIButton()
        likeButton.setImage(UIImage(named: "RecordingList_Like"), for: .normal)
        backView.addSubview(likeButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.frame = CGRect(x: 24, y: 0, width: contentView.width() - 48, height: 104)
        gradientView.frame = backView.bounds
        gradientLayer.frame = gradientView.bounds
        startImageView.sizeToFit()
        startImageView.setOrigin(x: 0, y: backView.halfHeight() - 35)
        nameLabel.sizeToFit()
        nameLabel.setOrigin(x: 0, y: 0)
        dateLabel.sizeToFit()
        dateLabel.setOrigin(x: 0, y: nameLabel.maxY() + 4)
        labelsBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(nameLabel.width(), dateLabel.width()), height: dateLabel.maxY()))
        labelsBackView.center = CGPoint(x: startImageView.maxX() + 7 + labelsBackView.halfWidth(), y: backView.halfHeight())
        likeButton.sizeToFit()
        likeButton.center = CGPoint(x: backView.width() - 24 - likeButton.halfWidth(), y: backView.halfHeight())
    }
    
    
    func setModel(_ model: DbModel) {
        nameLabel.text = model.name
        let date = DbManager.manager.dateFormatter.date(from: String(model.id!))!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy at h:mm a"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        layoutNow()
    }
}
