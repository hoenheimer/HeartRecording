//
//  SettingViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit
import MessageUI
import DeviceKit


class SettingViewController: AnaLargeTitleViewController, MFMailComposeViewControllerDelegate {
    var ana_backView: UIView!
    var ana_gradientView: UIView!
    var ana_gradientLayer: CAGradientLayer!
    var ana_itemViews = [SettingItemView]()
    var ana_versionLabel: UILabel!
    
    var ana_proItemView: SettingItemView?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let proItemView = ana_proItemView {
            proItemView.ana_label.text = NBUserVipStatusManager.shard.getVipStatus() ? "You are pro!" : "Angel Premium-Unlock All Features"
        }
    }
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "Setting")
        
        ana_backView = UIView()
        ana_backView.layer.cornerRadius = 12
        ana_backView.layer.borderWidth = 1
        ana_backView.layer.borderColor = UIColor.color(hexString: "#80FFFFFF").cgColor
        ana_backView.backgroundColor = .color(hexString: "#CDFFFFFF")
        ana_backView.setShadow(color: .color(hexString: "#1e6e7191"), offset: CGSize(width: 0, height: 8), radius: 32)
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
        
        for model in itemModels() {
            let itemView = SettingItemView(image: model.image, title: model.title, key: model.key)
            itemView.ana_pipe.output.observeValues {
                [weak self] key in
                guard let self = self else { return }
                self.itemDidTouched(key: key)
            }
            if model.key == "Pro" {
                ana_proItemView = itemView
            }
            ana_backView.addSubview(itemView)
            ana_itemViews.append(itemView)
        }
        
        ana_versionLabel = UILabel()
        let infoDictionary = Bundle.main.infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"] as! String
        var versionString = "App version V" + version
        if let build = infoDictionary["CFBundleVersion"] as? String {
            versionString = versionString + "(\(build))"
        }
        ana_versionLabel.text = versionString
        ana_versionLabel.textColor = .color(hexString: "#6e7191")
        ana_versionLabel.font = UIFont(name: "Inter-Regular", size: 13)
        ana_backView.addSubview(ana_versionLabel)
    }
    
    
    override func layoutContentView() -> CGFloat {
        let backViewWidth = view.width() - 48
        var y: CGFloat = 6
        for i in ana_itemViews.indices {
            let itemView = ana_itemViews[i]
            itemView.frame = CGRect(x: 0, y: y, width: backViewWidth, height: 62)
            y = itemView.maxY()
        }
        ana_versionLabel.sizeToFit()
        ana_versionLabel.setOrigin(x: 16, y: y + 8)
        ana_backView.frame = CGRect(x: 24, y: 34, width: backViewWidth, height: ana_versionLabel.maxY() + 16)
        ana_gradientView.frame = ana_backView.bounds
        ana_gradientLayer.frame = ana_gradientView.bounds
        return ana_backView.maxY()
    }
    
    
    func itemDidTouched(key: String) {
        print(key)
        switch key {
        case "Pro":
            if !NBUserVipStatusManager.shard.getVipStatus() {
                let vc = SubscriptionViewController(success: nil)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        case "Favorites":
            navigationController?.pushViewController(FavoriteViewController(), animated: true)
        case "Privacy":
            let webView = BaseWebController()
            webView.urlStr = "https://sites.google.com/view/angelheartbeat/home"
            webView.modalPresentationStyle = .fullScreen
            present(webView, animated: true, completion: nil)
        case "Terms":
            let webView = BaseWebController()
            webView.urlStr = "https://sites.google.com/view/angelheart/home"
            webView.modalPresentationStyle = .fullScreen
            present(webView, animated: true, completion: nil)
		case "Feedback":
			let mailAddress = "taolanetwork@163.com"
			if MFMailComposeViewController.canSendMail() {
				let name = Bundle.main.infoDictionary!["CFBundleName"] as! String
				let currentVersionStr = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
				let deviceInfo = String(format: "(%@ %@ on %@ running with %@ %@,device %@)", name, currentVersionStr, Device.current.description, Device.current.systemName ?? "",Device.current.systemVersion ?? "" , Device.identifier)

				let bodyHtml = String(format: "<br><br><br><div style=\"color: gray;font-size: 12;\">%@</div><br><br><br>", arguments: [deviceInfo])
					
				let mailVC = MFMailComposeViewController()
				mailVC.mailComposeDelegate = self
				mailVC.setToRecipients([mailAddress])
				mailVC.setSubject("HeartRecording Feedback")
				mailVC.setMessageBody(bodyHtml, isHTML: true)
				self.navigationController!.present(mailVC, animated: true, completion: nil)
			} else {
				let mailStr = "mailto:" + mailAddress
				UIApplication.shared.open(URL(string: mailStr)!, options: [:], completionHandler: nil)
			}
		case "Share":
			let content = "Use this app to record your baby’s heart beat https://itunes.apple.com/app/1564099404"
			NBSharedTool.shard(to: .systemShared, shardContent: content, shardImage: nil, linkUrl: nil,fromVC: self, .zero, nil)
		case "Rate":
			let commentLink = "itms-apps://itunes.apple.com/app/id1564099404?action=write-review"
			if let commentUrl = URL(string: commentLink){
				UIApplication.shared.open(commentUrl, options: [:], completionHandler: nil)
			}
        default:
            return
        }
    }
    
    
    func itemModels() -> [SettingItemModel] {
        var models = [SettingItemModel]()
        if NBUserVipStatusManager.shard.getVipStatus() {
            models.append(SettingItemModel(image: UIImage(named: "Setting_Pro"), title: "You are pro!", key: "Pro"))
        } else {
            models.append(SettingItemModel(image: UIImage(named: "Setting_Pro"), title: "Angel Premium-Unlock All Features", key: "Pro"))
        }
        models.append(SettingItemModel(image: UIImage(named: "Setting_Favorite"), title: "Favorites", key: "Favorites"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Feedback"), title: "Feedback", key: "Feedback"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Share"), title: "Share with friends", key: "Share"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Like"), title: "Rate us", key: "Rate"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Privacy"), title: "Privacy Policy", key: "Privacy"))
        models.append(SettingItemModel(image: UIImage(named: "Setting_Terms"), title: "Terms of use", key: "Terms"))
        return models
    }
	
	
	// MARK: - MFMailComposeViewControllerDelegate
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}


struct SettingItemModel {
    var image: UIImage?
    var title: String?
    var key: String
}
