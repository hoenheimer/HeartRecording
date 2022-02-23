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


class RecordViewController: AnaLargeTitleViewController {
	var backImageView: UIImageView!
    var ana_label: UILabel!
    var ana_timerLabel: UILabel!
    var ana_buttonBackgroundView: UIView!
    var ana_buttonGradient: CAGradientLayer!
    var ana_button: UIButton!
    
    let ana_manager = RecordManager()
    var ana_recordStartDate = Date()
    var ana_timer: Timer?
    var ana_visiableTime: CGFloat = 0
	
	var avPlayer: AVPlayer?
	var avPlayerLayer: AVPlayerLayer?
    
    
    deinit {
        if ana_timer != nil && ana_timer!.isValid {
            ana_timer!.invalidate()
            ana_timer = nil
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		setProRightBarItemIfNeeded()
    }
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "BabyCare")
		setProRightBarItemIfNeeded()
        
        scrollView.layer.masksToBounds = false
		
		backImageView = UIImageView(image: UIImage(named: "Record_Image"))
		contentView.addSubview(backImageView)
		
		let path = Bundle.main.path(forResource: "Record", ofType: "mp4")!
		let url = URL(fileURLWithPath: path)
		avPlayer = AVPlayer(url: url)
		avPlayerLayer = AVPlayerLayer(player: avPlayer)
		avPlayerLayer?.opacity = 0
		backImageView.layer.addSublayer(avPlayerLayer!)
        
        ana_label = UILabel()
        ana_label.numberOfLines = 0
        ana_label.textAlignment = .center
        ana_label.text = "When you have found your baby‘s heartbeat, tap the button to record now"
        ana_label.textColor = .color(hexString: "#6a515e")
        ana_label.font = UIFont(name: "Poppins-Medium", size: 14)
		backImageView.addSubview(ana_label)
        
        ana_timerLabel = UILabel()
        ana_timerLabel.textColor = .color(hexString: "#6a515e")
        ana_timerLabel.font = UIFont(name: "Poppins-SemiBold", size: 44)
        ana_timerLabel.isHidden = true
		backImageView.addSubview(ana_timerLabel)
        
        ana_buttonBackgroundView = UIView()
        ana_buttonBackgroundView.backgroundColor = .clear
        ana_buttonBackgroundView.layer.cornerRadius = 27
        contentView.addSubview(ana_buttonBackgroundView)
        
        ana_buttonGradient = CAGradientLayer()
        ana_buttonGradient.colors = [UIColor.color(hexString: "#fff3ed").cgColor, UIColor.color(hexString: "#ffdde4").cgColor]
		ana_buttonGradient.startPoint = CGPoint(x: 0, y: 0.5)
		ana_buttonGradient.endPoint = CGPoint(x: 1, y: 0.5)
        ana_buttonGradient.cornerRadius = 27
        ana_buttonBackgroundView.layer.addSublayer(ana_buttonGradient)
        
        ana_buttonBackgroundView.setShadow(color: .color(hexString: "#28d3afb8"), offset: CGSize(width: 0, height: 12), radius: 30)
        
        ana_button = UIButton()
		ana_button.layer.cornerRadius = 27
		ana_button.layer.borderWidth = 1
		ana_button.layer.borderColor = UIColor.color(hexString: "#80fcfcfc").cgColor
        ana_button.setTitle("Start Recording", for: .normal)
        ana_button.setTitleColor(.color(hexString: "#6a515e"), for: .normal)
        ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
			if !self.ana_manager.isRecording {
				let action = {
					FeedbackManager.feedback(type: .light)
					self.ana_manager.beginRecord()
					if self.ana_manager.isRecording {
						button.setTitle("Done", for: .normal)
					}
					
					self.ana_timerLabel.text = "00:00"
					self.view.layoutNow()
					self.ana_timerLabel.isHidden = false
					self.ana_label.isHidden = true
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
						vc.ana_scene = .record
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
				self.ana_manager.stopRecord()
				if !self.ana_manager.isRecording {
					button.setTitle("Start Recording", for: .normal)
				}
				let model = DbManager.manager.addRecording(path: self.ana_manager.file_name!)
				let vc = DetailViewController(model: model)
				vc.modalPresentationStyle = .fullScreen
				self.present(vc, animated: true, completion: nil)
				self.ana_timerLabel.isHidden = true
				self.ana_label.isHidden = false
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
        ana_buttonBackgroundView.addSubview(ana_button)
    }
    
    
    override func layoutContentView() -> CGFloat {
		backImageView.sizeToFit()
		backImageView.center = CGPoint(x: scrollView.halfWidth(), y: 29 + backImageView.halfHeight())
		avPlayerLayer?.frame = backImageView.bounds
		let size = ana_label.sizeThatFits(CGSize(width: 230, height: CGFloat.greatestFiniteMagnitude))
		ana_label.bounds = CGRect(origin: .zero, size: size)
		ana_label.center = CGPoint(x: backImageView.halfWidth(), y: 262)
		ana_timerLabel.sizeToFit()
		ana_timerLabel.center = ana_label.center
        ana_buttonBackgroundView.bounds = CGRect(origin: .zero, size: CGSize(width: 250, height: 54))
		ana_buttonBackgroundView.center = CGPoint(x: view.halfWidth(), y: backImageView.maxY() + 30 + ana_buttonBackgroundView.halfHeight())
        ana_buttonGradient.frame = ana_buttonBackgroundView.bounds
        ana_button.frame = ana_buttonBackgroundView.bounds
        return ana_buttonBackgroundView.maxY()
    }
}
