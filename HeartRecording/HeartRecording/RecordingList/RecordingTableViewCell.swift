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
        ana_backView.layer.cornerRadius = 12
        ana_backView.layer.borderWidth = 1
        ana_backView.layer.borderColor = UIColor.color(hexString: "#80FFFFFF").cgColor
        ana_backView.backgroundColor = .color(hexString: "#CDFFFFFF")
        ana_backView.setShadow(color: .color(hexString: "#1E6E7191"), offset: CGSize(width: 0, height: 8), radius: 32)
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
        ana_backView.addSubview(ana_startImageView)
        
        ana_labelsBackView = UIView()
        ana_labelsBackView.backgroundColor = .clear
        ana_backView.addSubview(ana_labelsBackView)
        
        ana_nameLabel = UILabel()
        ana_nameLabel.textColor = .color(hexString: "#14142B")
        ana_nameLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        ana_labelsBackView.addSubview(ana_nameLabel)
        
        ana_dateLabel = UILabel()
        ana_dateLabel.textColor = .color(hexString: "#6E7191")
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
        
        ana_backView.frame = CGRect(x: 24, y: 0, width: contentView.width() - 48, height: 104)
        ana_gradientView.frame = ana_backView.bounds
        ana_gradientLayer.frame = ana_gradientView.bounds
        ana_startImageView.sizeToFit()
        ana_startImageView.setOrigin(x: 0, y: ana_backView.halfHeight() - 35)
        ana_nameLabel.sizeToFit()
        ana_nameLabel.setOrigin(x: 0, y: 0)
        ana_dateLabel.sizeToFit()
        ana_dateLabel.setOrigin(x: 0, y: ana_nameLabel.maxY() + 4)
        ana_labelsBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(ana_nameLabel.width(), ana_dateLabel.width()), height: ana_dateLabel.maxY()))
        ana_labelsBackView.center = CGPoint(x: ana_startImageView.maxX() + 7 + ana_labelsBackView.halfWidth(), y: ana_backView.halfHeight())
        ana_likeButton.sizeToFit()
        ana_likeButton.center = CGPoint(x: ana_backView.width() - 24 - ana_likeButton.halfWidth(), y: ana_backView.halfHeight())
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
