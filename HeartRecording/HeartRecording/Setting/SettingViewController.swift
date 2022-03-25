//
//  SettingViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit
import MessageUI
import DeviceKit


class SettingViewController: AnaLargeTitleTableViewController, MFMailComposeViewControllerDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		ana_tableView.reloadData()
    }
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "Setting")
		setProRightBarItemIfNeeded()
		setHeaderView(headerView: nil)
        
		ana_tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(SettingTableViewCell.self)))
		ana_tableView.rowHeight = 76
    }
	
	
	// MARK: - UITableViewDelegate & UITableViewDataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(NSStringFromClass(SettingTableViewCell.self)), for: indexPath) as! SettingTableViewCell
		switch indexPath.row {
		case 0:
			cell.set(imageName: "Setting_Pro", title: NBUserVipStatusManager.shard.getVipStatus() ? "You are pro!" : "Pre Eggers Premium-Unlock All Features")
		case 1:
			cell.set(imageName: "Setting_Favorite", title: "Favorite")
		case 2:
			cell.set(imageName: "Setting_Feedback", title: "Feedback")
		case 3:
			cell.set(imageName: "Setting_Share", title: "Share with friends")
		case 4:
			cell.set(imageName: "Setting_Like", title: "Rate us")
		case 5:
			cell.set(imageName: "Setting_Privacy", title: "Privacy Policy")
		case 6:
			cell.set(imageName: "Setting_Terms", title: "Terms of use")
		case 7:
			cell.set(imageName: "Setting_Health", title: "Health Information Source")
		default:
			break
		}
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			if !NBUserVipStatusManager.shard.getVipStatus() {
				let vc = SubscriptionViewController(success: nil)
				vc.modalPresentationStyle = .fullScreen
				present(vc, animated: true, completion: nil)
			}
		case 1:
			navigationController?.pushViewController(FavoriteViewController(), animated: true)
		case 2:
			let mailAddress = "992976910@qq.com"
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
		case 3:
			let content = "Mom & Baby's Memo https://itunes.apple.com/app/1614775980"
			NBSharedTool.shard(to: .systemShared, shardContent: content, shardImage: nil, linkUrl: nil,fromVC: self, .zero, nil)
		case 4:
			let commentLink = "itms-apps://itunes.apple.com/app/id1614775980?action=write-review"
			if let commentUrl = URL(string: commentLink){
				UIApplication.shared.open(commentUrl, options: [:], completionHandler: nil)
			}
		case 5:
			let webView = BaseWebController()
			webView.urlStr = "https://sites.google.com/view/pre-eggerspop/home"
			webView.modalPresentationStyle = .fullScreen
			present(webView, animated: true, completion: nil)
		case 6:
			let webView = BaseWebController()
			webView.urlStr = "https://sites.google.com/view/preeggerstou/home"
			webView.modalPresentationStyle = .fullScreen
			present(webView, animated: true, completion: nil)
		case 7:
			if let url = URL(string: "https://www.nhs.uk/pregnancy/keeping-well/your-babys-movements/") {
				UIApplication.shared.open(url)
			}
		default:
			return
		}
	}
	
	
	// MARK: - MFMailComposeViewControllerDelegate
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
