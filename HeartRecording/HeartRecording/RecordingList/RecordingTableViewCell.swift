//
//  RecordingTableViewCell.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit
import SwipeCellKit


class RecordingTableViewCell: SwipeTableViewCell {
    var ana_backView: UIView!
    var ana_gradientView: UIView!
    var ana_gradientLayer: CAGradientLayer!
    var ana_startImageView: UIImageView!
    var ana_labelsBackView: UIView!
    var ana_nameLabel: UILabel!
    var ana_dateLabel: UILabel!
    var ana_likeButton: UIButton!
    
    var model: DbRecordModel!
    
    
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
        
        ana_backView = UIView()
        ana_backView.layer.cornerRadius = 25
        ana_backView.backgroundColor = .color(hexString: "#CDFFFFFF")
        ana_backView.setShadow(color: .color(hexString: "#0f933c49"), offset: CGSize(width: 0, height: 8), radius: 25)
        contentView.addSubview(ana_backView)
        
        ana_gradientView = UIView()
        ana_gradientView.layer.cornerRadius = 12
        ana_backView.addSubview(ana_gradientView)
        
        ana_gradientLayer = CAGradientLayer()
        ana_gradientLayer.cornerRadius = 12
        ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        ana_gradientLayer.colors = [UIColor.color(hexString: "#E6FFFFFF").cgColor, UIColor.color(hexString: "#B3FFFFFF").cgColor]
        ana_gradientView.layer.addSublayer(ana_gradientLayer)
        
        ana_startImageView = UIImageView()
        ana_startImageView.image = UIImage(named: "RecordingList_Start")
		ana_startImageView.setShadow(color: .color(hexString: "#35d74b61"), offset: CGSize(width: 0, height: 12), radius: 38, opacity: 1)
        ana_backView.addSubview(ana_startImageView)
        
        ana_labelsBackView = UIView()
        ana_labelsBackView.backgroundColor = .clear
        ana_backView.addSubview(ana_labelsBackView)
        
        ana_nameLabel = UILabel()
        ana_nameLabel.textColor = .color(hexString: "#6a515e")
        ana_nameLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        ana_labelsBackView.addSubview(ana_nameLabel)
        
        ana_dateLabel = UILabel()
		ana_dateLabel.textColor = UIColor.color(hexString: "#6a515e").withAlphaComponent(0.5)
        ana_dateLabel.font = UIFont(name: "Inter-Regular", size: 13)
        ana_labelsBackView.addSubview(ana_dateLabel)
        
        ana_likeButton = UIButton()
        ana_likeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
            DbManager.manager.changeFavoriteModel(self.model)
        }
        ana_backView.addSubview(ana_likeButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ana_backView.frame = CGRect(x: 25, y: 0, width: contentView.width() - 50, height: 90)
        ana_gradientView.frame = ana_backView.bounds
        ana_gradientLayer.frame = ana_gradientView.bounds
        ana_startImageView.sizeToFit()
		ana_startImageView.center = CGPoint(x: 20 + ana_startImageView.halfWidth(), y: ana_backView.halfHeight())
        ana_nameLabel.sizeToFit()
        ana_nameLabel.setOrigin(x: 0, y: 0)
        ana_dateLabel.sizeToFit()
        ana_dateLabel.setOrigin(x: 0, y: ana_nameLabel.maxY() + 2)
        ana_labelsBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(ana_nameLabel.width(), ana_dateLabel.width()), height: ana_dateLabel.maxY()))
        ana_labelsBackView.center = CGPoint(x: ana_startImageView.maxX() + 15 + ana_labelsBackView.halfWidth(), y: ana_backView.halfHeight())
        ana_likeButton.sizeToFit()
        ana_likeButton.center = CGPoint(x: ana_backView.width() - 26 - ana_likeButton.halfWidth(), y: ana_backView.halfHeight())
    }
    
    
    func setModel(_ model: DbRecordModel) {
        self.model = model
        ana_nameLabel.text = model.name
        let date = DbManager.manager.dateFormatter.date(from: String(model.id!))!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy at h:mm a"
        let dateString = dateFormatter.string(from: date)
        ana_dateLabel.text = dateString
        ana_likeButton.setImage(UIImage(named: "RecordingList_" + ((model.favorite ?? false) ? "Favorite" : "Like")), for: .normal)
        layoutNow()
    }
}
