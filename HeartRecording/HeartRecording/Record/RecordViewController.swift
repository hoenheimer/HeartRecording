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


class RecordViewController: AnaLargeTitleViewController {
    var ana_proButton: UIButton!
    var ana_animationView: RippleAnimationView!
    var ana_mainView: UIView!
    var ana_heartImageView: UIImageView!
    var ana_label: UILabel!
    var ana_timerLabel: UILabel!
    var ana_buttonBackgroundView: UIView!
    var ana_buttonGradient: CAGradientLayer!
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
        ana_proButton.isHidden = NBUserVipStatusManager.shard.getVipStatus()
    }
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "Angel")
        
        scrollView.layer.masksToBounds = false
        
        ana_proButton = UIButton()
        ana_proButton.setImage(UIImage(named: "Record_Pro"), for: .normal)
        ana_proButton.setShadow(color: .color(hexString: "#146575a7"), offset: CGSize(width: 0, height: 8), radius: 32)
        ana_proButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            let vc = SubscriptionViewController(success: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        titleBackView.addSubview(ana_proButton)
        
        ana_animationView = RippleAnimationView(bgColor: .color(hexString: "#FF8282"))
        contentView.addSubview(ana_animationView)
        
        ana_mainView = UIView()
        ana_mainView.layer.cornerRadius = 134
        ana_mainView.backgroundColor = .color(hexString: "#FF8282")
        contentView.addSubview(ana_mainView)
        
        ana_heartImageView = UIImageView()
        ana_heartImageView.image = UIImage(named: "Record_Heart")
        ana_mainView.addSubview(ana_heartImageView)
        
        ana_label = UILabel()
        ana_label.numberOfLines = 0
        ana_label.textAlignment = .center
        ana_label.text = "When you have found your baby‘s heartbeat, tap the button to record now"
        ana_label.textColor = .white
        ana_label.font = UIFont(name: "Poppins-Light", size: 14)
        ana_mainView.addSubview(ana_label)
        
        ana_timerLabel = UILabel()
        ana_timerLabel.textColor = .white
        ana_timerLabel.font = UIFont(name: "Poppins-SemiBold", size: 44)
        ana_timerLabel.isHidden = true
        ana_mainView.addSubview(ana_timerLabel)
        
        ana_buttonBackgroundView = UIView()
        ana_buttonBackgroundView.backgroundColor = .clear
        ana_buttonBackgroundView.layer.cornerRadius = 24
        ana_buttonBackgroundView.layer.borderWidth = 1
        ana_buttonBackgroundView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
        contentView.addSubview(ana_buttonBackgroundView)
        
        ana_buttonGradient = CAGradientLayer()
        ana_buttonGradient.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF4747").cgColor]
        ana_buttonGradient.startPoint = CGPoint(x: 0.5, y: 0)
        ana_buttonGradient.endPoint = CGPoint(x: 0.5, y: 1)
        ana_buttonGradient.cornerRadius = 24
        ana_buttonBackgroundView.layer.addSublayer(ana_buttonGradient)
        
        ana_buttonBackgroundView.setShadow(color: .color(hexString: "#28A0A3BD"), offset: CGSize(width: 0, height: 16), radius: 24)
        
        ana_button = UIButton()
        ana_button.setTitle("Start Recording", for: .normal)
        ana_button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
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
        ana_proButton.sizeToFit()
        ana_proButton.center = CGPoint(x: view.width() - ana_proButton.halfWidth(), y: titleLabel.centerY() - 10)
        ana_mainView.bounds = CGRect(origin: .zero, size: CGSize(width: 268, height: 268))
        ana_mainView.center = CGPoint(x: view.halfWidth(), y: scrollView.height() * 0.3)
        ana_animationView.frame = ana_mainView.frame
        ana_heartImageView.sizeToFit()
        ana_heartImageView.center = CGPoint(x: ana_mainView.halfWidth(), y: 65 + ana_heartImageView.halfHeight())
        let size = ana_label.sizeThatFits(CGSize(width: 229, height: CGFloat.greatestFiniteMagnitude))
        ana_label.bounds = CGRect(origin: .zero, size: size)
        ana_label.center = CGPoint(x: ana_mainView.halfWidth(), y: ana_heartImageView.maxY() + 28 + ana_label.halfHeight())
        ana_timerLabel.sizeToFit()
        ana_timerLabel.center = CGPoint(x: ana_mainView.halfWidth(), y: ana_heartImageView.maxY() + 36 + ana_label.halfHeight())
        ana_buttonBackgroundView.bounds = CGRect(origin: .zero, size: CGSize(width: 175, height: 48))
        ana_buttonBackgroundView.center = CGPoint(x: view.halfWidth(), y: scrollView.height() * 0.7)
        ana_buttonGradient.frame = ana_buttonBackgroundView.bounds
        ana_button.frame = ana_buttonBackgroundView.bounds
        return ana_buttonBackgroundView.maxY()
    }
}
