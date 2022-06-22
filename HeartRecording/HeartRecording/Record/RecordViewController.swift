//
//  RecordViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/15.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import StoreKit
import AVFoundation
import DeviceKit


class RecordViewController: AnaLargeTitleViewController {
	var ana_backImageView: UIImageView!
    var ana_timerLabel: UILabel!
    var ana_button: UIButton!
    
    let ana_manager = RecordManager()
    var ana_recordStartDate = Date()
    var ana_timer: Timer?
    var ana_visiableTime: CGFloat = 0
    
    
    deinit {
        if ana_timer != nil && ana_timer!.isValid {
            ana_timer!.invalidate()
            ana_timer = nil
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		setProRightBarItemIfNeeded()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        if let tabBarController = tabBarController as? AnaTabBarController {
            tabBarController.ana_simulationTabBar.isHidden = false
        }
    }
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !ana_manager.isRecording {
			ana_backImageView.stopAnimating()
		}
	}
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "Action")
		setProRightBarItemIfNeeded()
        
        ana_scrollView.layer.masksToBounds = false
		
		ana_backImageView = RotationImageView(image: UIImage(named: "Record_Image"))
		ana_contentView.addSubview(ana_backImageView)
        
        ana_timerLabel = UILabel()
		ana_timerLabel.text = "00:00"
        ana_timerLabel.textColor = .color(hexString: "#504278")
        ana_timerLabel.font = UIFont(name: "PingFangHK-Regular", size: Device.isSmallScreen() ? 28 : 36)
		ana_contentView.addSubview(ana_timerLabel)
        
        ana_button = UIButton()
		ana_button.backgroundColor = .color(hexString: "#8059f3")
		ana_button.layer.cornerRadius = 27
        ana_button.setTitle("Start Recording", for: .normal)
        ana_button.setTitleColor(.white, for: .normal)
        ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
			if !self.ana_manager.isRecording {
				let action = {
					FeedbackManager.feedback(type: .light)
					self.ana_backImageView.startAnimating()
					self.ana_manager.beginRecord()
					if self.ana_manager.isRecording {
						button.setTitle("Done", for: .normal)
					}
					
					self.view.layoutNow()
					self.ana_recordStartDate = Date()
					self.ana_visiableTime = 0
					if self.ana_timer != nil && self.ana_timer!.isValid {
						self.ana_timer!.invalidate()
						self.ana_timer = nil
					}
					self.ana_timer = Timer(timeInterval: 1, repeats: true, block: {
						[weak self] _ in
						guard let self = self else { return }
						let time = Date().timeIntervalSince(self.ana_recordStartDate)
						if self.ana_visiableTime >= CGFloat(time) {
							self.ana_visiableTime += 1
						} else {
							self.ana_visiableTime = CGFloat(time)
						}
						self.ana_timerLabel.text = String.stringFromTime(self.ana_visiableTime)
						self.view.layoutNow()
					})
					RunLoop.current.add(self.ana_timer!, forMode: .default)
				}
				if !NBUserVipStatusManager.shard.getVipStatus() {
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "yyyyMMdd"
					let todayString = dateFormatter.string(from: Date())
					if UserDefaults.standard.string(forKey: "Home_Last_Show_SubscriptionVC") != todayString {
						let vc = SubscriptionViewController()
						vc.ana_success = action
						vc.ana_dismiss = action
						vc.modalPresentationStyle = .fullScreen
						self.present(vc, animated: true, completion: nil)
						UserDefaults.standard.setValue(todayString, forKey: "Home_Last_Show_SubscriptionVC")
					} else {
						action()
					}
				} else {
					action()
				}
			} else {
				FeedbackManager.feedback(type: .light)
				self.ana_backImageView.stopAnimating()
				self.ana_manager.stopRecord()
				self.ana_timerLabel.text = "00:00"
				if !self.ana_manager.isRecording {
					button.setTitle("Start Recording", for: .normal)
				}
				let model = DbManager.manager.addRecording(path: self.ana_manager.file_name!)
				self.navigationController?.pushViewController(DetailViewController(model: model), animated: true)
				if self.ana_timer != nil && self.ana_timer!.isValid {
					self.ana_timer!.invalidate()
					self.ana_timer = nil
				}
				if !UserDefaults.standard.bool(forKey: "Has_Request_View") {
					SKStoreReviewController.requestReview()
					UserDefaults.standard.setValue(true, forKey: "Has_Request_View")
				}
			}
        }
        ana_contentView.addSubview(ana_button)
    }
    
    
    override func layoutContentView() -> CGFloat {
		ana_backImageView.sizeToFit()
        if Device.isSmallScreen() {
            ana_backImageView.bounds = CGRect(x: 0, y: 0, width: ana_backImageView.width() * 0.8, height: ana_backImageView.height() * 0.8)
        }
        ana_backImageView.center = CGPoint(x: ana_scrollView.halfWidth(), y: (Device.isSmallScreen() ? 36 : 72) + ana_backImageView.halfHeight())
		ana_timerLabel.sizeToFit()
		ana_timerLabel.center = ana_backImageView.center
		ana_button.bounds = CGRect(origin: .zero, size: CGSize(width: 250, height: 54))
		ana_button.center = CGPoint(x: view.halfWidth(), y: ana_backImageView.maxY() + 23 + ana_button.halfHeight())
        return  ana_button.maxY()
    }
}
