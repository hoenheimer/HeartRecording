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
	var ana_gradientView: UIView!
	var ana_gradientLayer: CAGradientLayer!
	var ana_closeButton: UIButton!
	
	var ana_originView: UIView!
	var ana_imageView: UIImageView!
	var ana_originLabel: UILabel!
	var ana_originArrowLabel: UILabel!
	var ana_startButtonBackView: UIView!
	var ana_startButtonGradientLayer: CAGradientLayer!
	var ana_startButton: UIButton!
	
	var ana_countingView: UIView!
	var ana_kicksLabelsBackView: UIView!
	var ana_kicksTitleLabel: UILabel!
	var ana_kicksValueLabel: UILabel!
	var ana_kickButton: UIButton!
	var ana_timerLabel: UILabel!
	var ana_doneButtonBackView: UIView!
	var ana_doneButtonGradientLayer: CAGradientLayer!
	var ana_doneButton: UIButton!
	
	var ana_kicks = 0
	var ana_timer: Timer?
	var ana_timerStartDate: Date?
	
	
	deinit {
		if ana_timer?.isValid == true {
			ana_timer?.invalidate()
			ana_timer = nil
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
	
	func configure() {
		view.backgroundColor = .white
		
		ana_gradientView = UIView()
		view.addSubview(ana_gradientView)
		
		ana_gradientLayer = CAGradientLayer()
		ana_gradientLayer.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
		ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		ana_gradientView.layer.addSublayer(ana_gradientLayer)
		
		ana_closeButton = UIButton()
		ana_closeButton.setImage(UIImage(named: "Kick_Close"), for: .normal)
		ana_closeButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.dismiss(animated: true, completion: nil)
		}
		view.addSubview(ana_closeButton)
		
		ana_originView = UIView()
		ana_originView.backgroundColor = .clear
		view.addSubview(ana_originView)
		
		ana_imageView = UIImageView()
		ana_imageView.image = UIImage(named: "Kick_Image")
		ana_originView.addSubview(ana_imageView)
		
		ana_originLabel = UILabel()
		ana_originLabel.text = "Tap to begin recording kicks"
		ana_originLabel.textColor = .black
		ana_originLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
		ana_originView.addSubview(ana_originLabel)
		
		ana_originArrowLabel = UILabel()
		ana_originArrowLabel.text = "↓"
		ana_originArrowLabel.textColor = .black
		ana_originArrowLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
		ana_originView.addSubview(ana_originArrowLabel)
		
		ana_startButtonBackView = UIView()
		ana_startButtonBackView.layer.cornerRadius = 24
		ana_startButtonBackView.layer.borderWidth = 1
		ana_startButtonBackView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
		ana_startButtonBackView.backgroundColor = .color(hexString: "#FF5D5D")
		ana_startButtonBackView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24, opacity: 1)
		ana_originView.addSubview(ana_startButtonBackView)
		
		ana_startButtonGradientLayer = CAGradientLayer()
		ana_startButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		ana_startButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		ana_startButtonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF4747").cgColor]
		ana_startButtonGradientLayer.cornerRadius = 24
		ana_startButtonBackView.layer.addSublayer(ana_startButtonGradientLayer)
		
		ana_startButton = UIButton()
		ana_startButton.backgroundColor = .clear
		ana_startButton.setTitle("Start", for: .normal)
		ana_startButton.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
		ana_startButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
		ana_startButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			self.ana_originView.isHidden = true
			self.ana_countingView.isHidden = false
			self.ana_timerStartDate = Date()
			if self.ana_timer?.isValid == true {
				self.ana_timer?.invalidate()
				self.ana_timer = nil
			}
			self.ana_timer = Timer(timeInterval: 1, repeats: true, block: {
				[weak self] _ in
				guard let self = self else { return }
				if let startDate = self.ana_timerStartDate {
					let timeInterval = Date().timeIntervalSince(startDate)
					if timeInterval >= 6000 {
						self.ana_timerLabel.text = "99:59"
					} else {
						var seconds = Int(timeInterval)
						var minute = 0
						while seconds >= 60 {
							minute += 1
							seconds -= 60
						}
						self.ana_timerLabel.text = String(format: "%02d:%02d", minute, seconds)
					}
					self.view.layoutNow()
				}
			})
			RunLoop.current.add(self.ana_timer!, forMode: .default)
		}
		ana_originView.addSubview(ana_startButton)
		
		ana_countingView = UIView()
		ana_countingView.backgroundColor = .clear
		ana_countingView.isHidden = true
		view.addSubview(ana_countingView)
		
		ana_kicksLabelsBackView = UIView()
		ana_kicksLabelsBackView.backgroundColor = .clear
		ana_countingView.addSubview(ana_kicksLabelsBackView)
		
		ana_kicksTitleLabel = UILabel()
		ana_kicksTitleLabel.text = "Kicks"
		ana_kicksTitleLabel.textColor = .color(hexString: "#14142B")
		ana_kicksTitleLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
		ana_kicksLabelsBackView.addSubview(ana_kicksTitleLabel)
		
		ana_kicksValueLabel = UILabel()
		ana_kicksValueLabel.text = "0"
		ana_kicksValueLabel.textColor = .black
		ana_kicksValueLabel.font = UIFont(name: "Poppins-SemiBold", size: 100)
		ana_kicksLabelsBackView.addSubview(ana_kicksValueLabel)
		
		ana_kickButton = UIButton()
		ana_kickButton.setImage(UIImage(named: "Kick_Button"), for: .normal)
		ana_kickButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self  = self else { return }
			FeedbackManager.feedback(type: .light)
			self.ana_kicks += 1
			self.ana_kicksValueLabel.text = "\(self.ana_kicks)"
			self.view.layoutNow()
		}
		ana_countingView.addSubview(ana_kickButton)
		
		ana_timerLabel = UILabel()
		ana_timerLabel.text = "00:00"
		ana_timerLabel.textColor = .black
		ana_timerLabel.font = UIFont(name: "Poppins-SemiBold", size: 44)
		ana_countingView.addSubview(ana_timerLabel)
		
		ana_doneButtonBackView = UIView()
		ana_doneButtonBackView.layer.cornerRadius = 24
		ana_doneButtonBackView.layer.borderWidth = 1
		ana_doneButtonBackView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
		ana_doneButtonBackView.backgroundColor = .color(hexString: "#FF5D5D")
		ana_doneButtonBackView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24, opacity: 1)
		ana_countingView.addSubview(ana_doneButtonBackView)
		
		ana_doneButtonGradientLayer = CAGradientLayer()
		ana_doneButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		ana_doneButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		ana_doneButtonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF4747").cgColor]
		ana_doneButtonGradientLayer.cornerRadius = 24
		ana_doneButtonBackView.layer.addSublayer(ana_doneButtonGradientLayer)
		
		ana_doneButton = UIButton()
		ana_doneButton.backgroundColor = .clear
		ana_doneButton.setTitle("Done", for: .normal)
		ana_doneButton.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
		ana_doneButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
		ana_doneButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self  = self else { return }
			FeedbackManager.feedback(type: .light)
			var duration: TimeInterval = 0
			if let startDate = self.ana_timerStartDate {
				duration = Date().timeIntervalSince(startDate)
			}
			DbManager.manager.insertKicks(duration: min(Int(duration), 6000), kicks: self.ana_kicks)
			self.dismiss(animated: true, completion: nil)
		}
		ana_countingView.addSubview(ana_doneButton)
		
		view.bringSubviewToFront(ana_closeButton)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_gradientView.frame = view.bounds
		ana_gradientLayer.frame = ana_gradientView.bounds
		ana_closeButton.sizeToFit()
		ana_closeButton.setOrigin(x: 20, y: topSpacing() + 27)
		
		ana_originView.frame = view.bounds
		ana_imageView.sizeToFit()
		ana_imageView.center = CGPoint(x: ana_originView.halfWidth(), y: ana_closeButton.maxY() + 52 + ana_imageView.halfHeight())
		ana_startButtonBackView.bounds = CGRect(origin: .zero, size: CGSize(width: 240, height: 48))
		ana_startButtonBackView.center = CGPoint(x: ana_originView.halfWidth(), y: ana_originView.height() * 0.83)
		ana_startButtonGradientLayer.frame = ana_startButtonBackView.bounds
		ana_startButton.frame = ana_startButtonBackView.frame
		ana_originArrowLabel.sizeToFit()
		ana_originArrowLabel.center = CGPoint(x: ana_originView.halfWidth(), y: ana_startButton.minY() - 17 - ana_originArrowLabel.halfHeight())
		ana_originLabel.sizeToFit()
		ana_originLabel.center = CGPoint(x: ana_originView.halfWidth(), y: ana_originArrowLabel.minY() - 9 - ana_originLabel.halfHeight())
		
		ana_countingView.frame = view.bounds
		ana_kicksTitleLabel.sizeToFit()
		ana_kicksValueLabel.sizeToFit()
		ana_kicksLabelsBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(ana_kicksTitleLabel.width(), ana_kicksValueLabel.width()),
																		height: ana_kicksTitleLabel.height() + ana_kicksValueLabel.height()))
		ana_kicksTitleLabel.center = CGPoint(x: ana_kicksLabelsBackView.halfWidth(), y: ana_kicksTitleLabel.halfHeight())
		ana_kicksValueLabel.center = CGPoint(x: ana_kicksLabelsBackView.halfWidth(), y: ana_kicksTitleLabel.maxY() + ana_kicksValueLabel.halfHeight())
		ana_kicksLabelsBackView.center = CGPoint(x: ana_countingView.halfWidth(), y: ana_countingView.height() * 0.3)
		ana_kickButton.sizeToFit()
		ana_kickButton.center = CGPoint(x: ana_countingView.halfWidth(), y: ana_countingView.height() * 0.55)
		ana_timerLabel.sizeToFit()
		ana_timerLabel.center = CGPoint(x: ana_countingView.halfWidth(), y: ana_countingView.height() * 0.735)
		ana_doneButtonBackView.frame = ana_startButton.frame
		ana_doneButtonGradientLayer.frame = ana_doneButtonBackView.bounds
		ana_doneButton.frame = ana_doneButtonBackView.frame
	}
}
