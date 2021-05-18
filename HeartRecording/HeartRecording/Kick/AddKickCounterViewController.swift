//
//  AddKickCounterViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/5/17.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa


class AddKickCounterViewController: UIViewController {
	var gradientView: UIView!
	var gradientLayer: CAGradientLayer!
	var closeButton: UIButton!
	
	var originView: UIView!
	var imageView: UIImageView!
	var originLabel: UILabel!
	var originArrowLabel: UILabel!
	var startButtonBackView: UIView!
	var startButtonGradientLayer: CAGradientLayer!
	var startButton: UIButton!
	
	var countingView: UIView!
	var kicksLabelsBackView: UIView!
	var kicksTitleLabel: UILabel!
	var kicksValueLabel: UILabel!
	var kickButton: UIButton!
	var timerLabel: UILabel!
	var doneButtonBackView: UIView!
	var doneButtonGradientLayer: CAGradientLayer!
	var doneButton: UIButton!
	
	var kicks = 0
	var timer: Timer?
	var timerStartDate: Date?
	
	
	deinit {
		if timer?.isValid == true {
			timer?.invalidate()
			timer = nil
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
	
	func configure() {
		view.backgroundColor = .white
		
		gradientView = UIView()
		view.addSubview(gradientView)
		
		gradientLayer = CAGradientLayer()
		gradientLayer.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		gradientView.layer.addSublayer(gradientLayer)
		
		closeButton = UIButton()
		closeButton.setImage(UIImage(named: "Kick_Close"), for: .normal)
		closeButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.dismiss(animated: true, completion: nil)
		}
		view.addSubview(closeButton)
		
		originView = UIView()
		originView.backgroundColor = .clear
		view.addSubview(originView)
		
		imageView = UIImageView()
		imageView.image = UIImage(named: "Kick_Image")
		originView.addSubview(imageView)
		
		originLabel = UILabel()
		originLabel.text = "Tap to begin recording kicks"
		originLabel.textColor = .black
		originLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
		originView.addSubview(originLabel)
		
		originArrowLabel = UILabel()
		originArrowLabel.text = "↓"
		originArrowLabel.textColor = .black
		originArrowLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
		originView.addSubview(originArrowLabel)
		
		startButtonBackView = UIView()
		startButtonBackView.layer.cornerRadius = 24
		startButtonBackView.layer.borderWidth = 1
		startButtonBackView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
		startButtonBackView.backgroundColor = .color(hexString: "#FF5D5D")
		startButtonBackView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24, opacity: 1)
		originView.addSubview(startButtonBackView)
		
		startButtonGradientLayer = CAGradientLayer()
		startButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		startButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		startButtonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF4747").cgColor]
		startButtonGradientLayer.cornerRadius = 24
		startButtonBackView.layer.addSublayer(startButtonGradientLayer)
		
		startButton = UIButton()
		startButton.backgroundColor = .clear
		startButton.setTitle("Start", for: .normal)
		startButton.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
		startButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
		startButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.originView.isHidden = true
			self.countingView.isHidden = false
			self.timerStartDate = Date()
			if self.timer?.isValid == true {
				self.timer?.invalidate()
				self.timer = nil
			}
			self.timer = Timer(timeInterval: 1, repeats: true, block: {
				[weak self] _ in
				guard let self = self else { return }
				if let startDate = self.timerStartDate {
					let timeInterval = Date().timeIntervalSince(startDate)
					if timeInterval >= 6000 {
						self.timerLabel.text = "99:59"
					} else {
						var seconds = Int(timeInterval)
						var minute = 0
						while seconds >= 60 {
							minute += 1
							seconds -= 60
						}
						self.timerLabel.text = String(format: "%02d:%02d", minute, seconds)
					}
					self.view.layoutNow()
				}
			})
			RunLoop.current.add(self.timer!, forMode: .default)
		}
		originView.addSubview(startButton)
		
		countingView = UIView()
		countingView.backgroundColor = .clear
		countingView.isHidden = true
		view.addSubview(countingView)
		
		kicksLabelsBackView = UIView()
		kicksLabelsBackView.backgroundColor = .clear
		countingView.addSubview(kicksLabelsBackView)
		
		kicksTitleLabel = UILabel()
		kicksTitleLabel.text = "Kicks"
		kicksTitleLabel.textColor = .color(hexString: "#14142B")
		kicksTitleLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
		kicksLabelsBackView.addSubview(kicksTitleLabel)
		
		kicksValueLabel = UILabel()
		kicksValueLabel.text = "0"
		kicksValueLabel.textColor = .black
		kicksValueLabel.font = UIFont(name: "Poppins-SemiBold", size: 100)
		kicksLabelsBackView.addSubview(kicksValueLabel)
		
		kickButton = UIButton()
		kickButton.setImage(UIImage(named: "Kick_Button"), for: .normal)
		kickButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self  = self else { return }
			self.kicks += 1
			self.kicksValueLabel.text = "\(self.kicks)"
			self.view.layoutNow()
		}
		countingView.addSubview(kickButton)
		
		timerLabel = UILabel()
		timerLabel.text = "00:00"
		timerLabel.textColor = .black
		timerLabel.font = UIFont(name: "Poppins-SemiBold", size: 44)
		countingView.addSubview(timerLabel)
		
		doneButtonBackView = UIView()
		doneButtonBackView.layer.cornerRadius = 24
		doneButtonBackView.layer.borderWidth = 1
		doneButtonBackView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
		doneButtonBackView.backgroundColor = .color(hexString: "#FF5D5D")
		doneButtonBackView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24, opacity: 1)
		countingView.addSubview(doneButtonBackView)
		
		doneButtonGradientLayer = CAGradientLayer()
		doneButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		doneButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		doneButtonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF4747").cgColor]
		doneButtonGradientLayer.cornerRadius = 24
		doneButtonBackView.layer.addSublayer(doneButtonGradientLayer)
		
		doneButton = UIButton()
		doneButton.backgroundColor = .clear
		doneButton.setTitle("Done", for: .normal)
		doneButton.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
		doneButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
		doneButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self  = self else { return }
			var duration: TimeInterval = 0
			if let startDate = self.timerStartDate {
				duration = Date().timeIntervalSince(startDate)
			}
			DbManager.manager.insertKicks(duration: min(Int(duration), 6000), kicks: self.kicks)
			self.dismiss(animated: true, completion: nil)
		}
		countingView.addSubview(doneButton)
		
		view.bringSubviewToFront(closeButton)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		gradientView.frame = view.bounds
		gradientLayer.frame = gradientView.bounds
		closeButton.sizeToFit()
		closeButton.setOrigin(x: 20, y: topSpacing() + 27)
		
		originView.frame = view.bounds
		imageView.sizeToFit()
		imageView.center = CGPoint(x: originView.halfWidth(), y: closeButton.maxY() + 52 + imageView.halfHeight())
		startButtonBackView.bounds = CGRect(origin: .zero, size: CGSize(width: 240, height: 48))
		startButtonBackView.center = CGPoint(x: originView.halfWidth(), y: originView.height() * 0.83)
		startButtonGradientLayer.frame = startButtonBackView.bounds
		startButton.frame = startButtonBackView.frame
		originArrowLabel.sizeToFit()
		originArrowLabel.center = CGPoint(x: originView.halfWidth(), y: startButton.minY() - 17 - originArrowLabel.halfHeight())
		originLabel.sizeToFit()
		originLabel.center = CGPoint(x: originView.halfWidth(), y: originArrowLabel.minY() - 9 - originLabel.halfHeight())
		
		countingView.frame = view.bounds
		kicksTitleLabel.sizeToFit()
		kicksValueLabel.sizeToFit()
		kicksLabelsBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(kicksTitleLabel.width(), kicksValueLabel.width()),
																		height: kicksTitleLabel.height() + kicksValueLabel.height()))
		kicksTitleLabel.center = CGPoint(x: kicksLabelsBackView.halfWidth(), y: kicksTitleLabel.halfHeight())
		kicksValueLabel.center = CGPoint(x: kicksLabelsBackView.halfWidth(), y: kicksTitleLabel.maxY() + kicksValueLabel.halfHeight())
		kicksLabelsBackView.center = CGPoint(x: countingView.halfWidth(), y: countingView.height() * 0.3)
		kickButton.sizeToFit()
		kickButton.center = CGPoint(x: countingView.halfWidth(), y: countingView.height() * 0.55)
		timerLabel.sizeToFit()
		timerLabel.center = CGPoint(x: countingView.halfWidth(), y: countingView.height() * 0.735)
		doneButtonBackView.frame = startButton.frame
		doneButtonGradientLayer.frame = doneButtonBackView.bounds
		doneButton.frame = doneButtonBackView.frame
	}
}
