//
//  SettingViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit

class SettingViewController: AnaLargeTitleViewController {
    var backView: UIView!
    var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    var itemViews = [SettingItemView]()
    var versionLabel: UILabel!
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "Setting")
        
        backView = UIView()
        backView.layer.cornerRadius = 12
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.color(hexString: "#80FFFFFF").cgColor
        backView.backgroundColor = .color(hexString: "#CDFFFFFF")
        backView.setShadow(color: .color(hexString: "#1e6e7191"), offset: CGSize(width: 0, height: 8), radius: 32)
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
        
        for model in SettingViewController.itemModels() {
            let itemView = SettingItemView(image: model.image, title: model.title, key: model.key)
            itemView.pipe.output.observeValues {
                [weak self] key in
                guard let self = self else { return }
                self.itemDidTouched(key: key)
            }
            backView.addSubview(itemView)
            itemViews.append(itemView)
        }
        
        versionLabel = UILabel()
        let infoDictionary = Bundle.main.infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"] as! String
        var versionString = "App version V" + version
        if let build = infoDictionary["CFBundleVersion"] as? String {
            versionString = versionString + "(\(build))"
        }
        versionLabel.text = versionString
        versionLabel.textColor = .color(hexString: "#6e7191")
        versionLabel.font = UIFont(name: "Inter-Regular", size: 13)
        backView.addSubview(versionLabel)
    }
    
    
    override func layoutContentView() -> CGFloat {
        let backViewWidth = view.width() - 48
        var y: CGFloat = 6
        for i in itemViews.indices {
            let itemView = itemViews[i]
            itemView.frame = CGRect(x: 0, y: y, width: backViewWidth, height: 62)
            y = itemView.maxY()
        }
        versionLabel.sizeToFit()
        versionLabel.setOrigin(x: 16, y: y + 8)
        backView.frame = CGRect(x: 24, y: 34, width: backViewWidth, height: versionLabel.maxY() + 16)
        gradientView.frame = backView.bounds
        gradientLayer.frame = gradientView.bounds
        return backView.maxY()
    }
    
    
    func itemDidTouched(key: String) {
        print(key)
    }
    
    
    static func itemModels() -> [SettingItemModel] {
        var models = [SettingItemModel]()
        models.append(SettingItemModel(image: UIImage(named: "Setting_Favorite"), title: "Favorites", key: "Favorites"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Feedback"), title: "Feedback", key: "Feedback"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Share"), title: "Share with friends", key: "Share"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Like"), title: "Rate us", key: "Rate"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Privacy"), title: "Privacy Policy", key: "Privacy"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Terms"), title: "Terms of use", key: "Terms"))
        return models
    }
}


struct SettingItemModel {
    var image: UIImage?
    var title: String?
    var key: String
}
