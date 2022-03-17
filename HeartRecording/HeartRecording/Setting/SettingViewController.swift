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
    
    var ana_proItemView: SettingItemView?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let proItemView = ana_proItemView {
            proItemView.ana_label.text = NBUserVipStatusManager.shard.getVipStatus() ? "You are pro!" : "BabyCare Premium-Unlock All Features"
        }
		setProRightBarItemIfNeeded()
    }
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "Setting")
		setProRightBarItemIfNeeded()
        
        ana_backView = UIView()
        ana_backView.layer.cornerRadius = 25
        ana_backView.backgroundColor = .color(hexString: "#CDFFFFFF")
        ana_backView.setShadow(color: .color(hexString: "#0f933c49"), offset: CGSize(width: 0, height: 8), radius: 25)
        ana_contentView.addSubview(ana_backView)
        
        ana_gradientView = UIView()
        ana_backView.addSubview(ana_gradientView)
        
        ana_gradientLayer = CAGradientLayer()
        ana_gradientLayer.cornerRadius = 25
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
    }
    
    
    override func layoutContentView() -> CGFloat {
        let backViewWidth = view.width() - 50
        var y: CGFloat = 5
        for i in ana_itemViews.indices {
            let itemView = ana_itemViews[i]
            itemView.frame = CGRect(x: 0, y: y, width: backViewWidth, height: 64)
            y = itemView.maxY()
        }
        ana_backView.frame = CGRect(x: 25, y: 40, width: backViewWidth, height: y + 5)
        ana_gradientView.frame = ana_backView.bounds
        ana_gradientLayer.frame = ana_gradientView.bounds
        return ana_backView.maxY()
    }
    
    
    func itemDidTouched(key: String) {
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
            webView.urlStr = "https://sites.google.com/view/babycarepop/home"
            webView.modalPresentationStyle = .fullScreen
            present(webView, animated: true, completion: nil)
        case "Terms":
            let webView = BaseWebController()
            webView.urlStr = "https://sites.google.com/view/babycaretou/home"
            webView.modalPresentationStyle = .fullScreen
            present(webView, animated: true, completion: nil)
		case "Feedback":
			let mailAddress = "xomnmmamd@outlook.com"
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
			let content = "Use this app to record your baby’s heart beat https://itunes.apple.com/app/1610497712"
			NBSharedTool.shard(to: .systemShared, shardContent: content, shardImage: nil, linkUrl: nil,fromVC: self, .zero, nil)
		case "Rate":
			let commentLink = "itms-apps://itunes.apple.com/app/id1610497712?action=write-review"
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
            models.append(SettingItemModel(image: UIImage(named: "Setting_Pro"), title: "BabyCare Premium-Unlock All Features", key: "Pro"))
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
