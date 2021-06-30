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
    var proButton: UIButton!
    var animationView: RippleAnimationView!
    var mainView: UIView!
    var heartImageView: UIImageView!
    var label: UILabel!
    var timerLabel: UILabel!
    var buttonBackgroundView: UIView!
    var buttonGradient: CAGradientLayer!
    var button: UIButton!
    
    let manager = RecordManager()
    var recordStartDate = Date()
    var timer: Timer?
    var visiableTime: CGFloat = 0
    
    
    deinit {
        if timer != nil && timer!.isValid {
            timer!.invalidate()
            timer = nil
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        proButton.isHidden = NBUserVipStatusManager.shard.getVipStatus()
    }
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "Angel")
        
        scrollView.layer.masksToBounds = false
        
        proButton = UIButton()
        proButton.setImage(UIImage(named: "Record_Pro"), for: .normal)
        proButton.setShadow(color: .color(hexString: "#146575a7"), offset: CGSize(width: 0, height: 8), radius: 32)
        proButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            let vc = SubscriptionViewController(success: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        titleBackView.addSubview(proButton)
        
        animationView = RippleAnimationView(bgColor: .color(hexString: "#FF8282"))
        contentView.addSubview(animationView)
        
        mainView = UIView()
        mainView.layer.cornerRadius = 134
        mainView.backgroundColor = .color(hexString: "#FF8282")
        contentView.addSubview(mainView)
        
        heartImageView = UIImageView()
        heartImageView.image = UIImage(named: "Record_Heart")
        mainView.addSubview(heartImageView)
        
        label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "When you have found your baby‘s heartbeat, tap the button to record now"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Light", size: 14)
        mainView.addSubview(label)
        
        timerLabel = UILabel()
        timerLabel.textColor = .white
        timerLabel.font = UIFont(name: "Poppins-SemiBold", size: 44)
        timerLabel.isHidden = true
        mainView.addSubview(timerLabel)
        
        buttonBackgroundView = UIView()
        buttonBackgroundView.backgroundColor = .clear
        buttonBackgroundView.layer.cornerRadius = 24
        buttonBackgroundView.layer.borderWidth = 1
        buttonBackgroundView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
        contentView.addSubview(buttonBackgroundView)
        
        buttonGradient = CAGradientLayer()
        buttonGradient.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF4747").cgColor]
        buttonGradient.startPoint = CGPoint(x: 0.5, y: 0)
        buttonGradient.endPoint = CGPoint(x: 0.5, y: 1)
        buttonGradient.cornerRadius = 24
        buttonBackgroundView.layer.addSublayer(buttonGradient)
        
        buttonBackgroundView.setShadow(color: .color(hexString: "#28A0A3BD"), offset: CGSize(width: 0, height: 16), radius: 24)
        
        button = UIButton()
        button.setTitle("Start Recording", for: .normal)
        button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
			if !self.manager.isRecording {
				let action = {
					FeedbackManager.feedback(type: .light)
					self.manager.beginRecord()
					if self.manager.isRecording {
						button.setTitle("Done", for: .normal)
					}
					
					self.timerLabel.text = "00:00"
					self.view.layoutNow()
					self.timerLabel.isHidden = false
					self.label.isHidden = true
					self.recordStartDate = Date()
					self.visiableTime = 0
					if self.timer != nil && self.timer!.isValid {
						self.timer!.invalidate()
						self.timer = nil
					}
					self.timer = Timer(timeInterval: 1, repeats: true, block: {
						[weak self] _ in
						guard let self = self else { return }
						let time = Date().timeIntervalSince(self.recordStartDate)
						if self.visiableTime >= CGFloat(time) {
							self.visiableTime += 1
						} else {
							self.visiableTime = CGFloat(time)
						}
						self.timerLabel.text = String.stringFromTime(self.visiableTime)
						self.view.layoutNow()
					})
					RunLoop.current.add(self.timer!, forMode: .default)
				}
				if !NBUserVipStatusManager.shard.getVipStatus() {
					let vc = SubscriptionViewController()
					vc.success = action
					vc.dismiss = action
					vc.scene = .record
					vc.modalPresentationStyle = .fullScreen
					self.present(vc, animated: true, completion: nil)
				} else {
					action()
				}
			} else {
				FeedbackManager.feedback(type: .light)
				self.manager.stopRecord()
				if !self.manager.isRecording {
					button.setTitle("Start Recording", for: .normal)
				}
				let model = DbManager.manager.addRecording(path: self.manager.file_name!)
				let vc = DetailViewController(model: model)
				vc.modalPresentationStyle = .fullScreen
				self.present(vc, animated: true, completion: nil)
				self.timerLabel.isHidden = true
				self.label.isHidden = false
				if self.timer != nil && self.timer!.isValid {
					self.timer!.invalidate()
					self.timer = nil
				}
				if !UserDefaults.standard.bool(forKey: "Has_Request_View") {
					SKStoreReviewController.requestReview()
					UserDefaults.standard.setValue(true, forKey: "Has_Request_View")
				}
			}
        }
        buttonBackgroundView.addSubview(button)
    }
    
    
    override func layoutContentView() -> CGFloat {
        proButton.sizeToFit()
        proButton.center = CGPoint(x: view.width() - proButton.halfWidth(), y: titleLabel.centerY() - 10)
        mainView.bounds = CGRect(origin: .zero, size: CGSize(width: 268, height: 268))
        mainView.center = CGPoint(x: view.halfWidth(), y: scrollView.height() * 0.3)
        animationView.frame = mainView.frame
        heartImageView.sizeToFit()
        heartImageView.center = CGPoint(x: mainView.halfWidth(), y: 65 + heartImageView.halfHeight())
        let size = label.sizeThatFits(CGSize(width: 229, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(origin: .zero, size: size)
        label.center = CGPoint(x: mainView.halfWidth(), y: heartImageView.maxY() + 28 + label.halfHeight())
        timerLabel.sizeToFit()
        timerLabel.center = CGPoint(x: mainView.halfWidth(), y: heartImageView.maxY() + 36 + label.halfHeight())
        buttonBackgroundView.bounds = CGRect(origin: .zero, size: CGSize(width: 175, height: 48))
        buttonBackgroundView.center = CGPoint(x: view.halfWidth(), y: scrollView.height() * 0.7)
        buttonGradient.frame = buttonBackgroundView.bounds
        button.frame = buttonBackgroundView.bounds
        return buttonBackgroundView.maxY()
    }
}
