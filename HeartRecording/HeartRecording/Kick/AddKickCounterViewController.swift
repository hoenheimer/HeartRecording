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
	
	var backImageView: UIImageView!
	var stepImageView: UIImageView!
	var countLabel: UILabel!
	var addButton: UIButton!
	var timeLabel: UILabel!
	var buttonGradientView: UIView!
	var buttonGradientLayer: CAGradientLayer!
	var button: UIButton!
	
	var ana_kicks = 0
	var ana_timer: Timer?
	var ana_timerStartDate: Date?
	
	
	deinit {
		if ana_timer?.isValid == true {
			ana_timer?.invalidate()
			ana_timer = nil
		}
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
		if let tabBarController = tabBarController as? AnaTabBarController {
			tabBarController.simulationTabBar.isHidden = true
		}
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = false
		if let tabBarController = tabBarController as? AnaTabBarController {
			tabBarController.simulationTabBar.isHidden = false
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
		ana_gradientLayer.colors = [UIColor.color(hexString: "#fffefd").cgColor, UIColor.color(hexString: "#fcf3f4").cgColor]
		ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		ana_gradientView.layer.addSublayer(ana_gradientLayer)
		
		ana_closeButton = UIButton()
		ana_closeButton.setImage(UIImage(named: "Kick_Close"), for: .normal)
		ana_closeButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.navigationController?.popViewController(animated: true)
		}
		view.addSubview(ana_closeButton)
		
		backImageView = UIImageView(image: UIImage(named: "Kick_Add_Shape"))
		view.addSubview(backImageView)
		
		stepImageView = UIImageView(image: UIImage(named: "Kick_Add_Steps_Inactive"))
		backImageView.addSubview(stepImageView)
		
		countLabel = UILabel()
		countLabel.text = "00"
		countLabel.textColor = .color(hexString: "#6a515e")
		countLabel.font = UIFont(name: "Poppins-SemiBold", size: 72)
		backImageView.addSubview(countLabel)
		
		addButton = UIButton()
		addButton.setImage(UIImage(named: "Kick_Add_Button"), for: .normal)
		addButton.setShadow(color: .color(hexString: "#35d74b61"), offset: CGSize(width: 0, height: 12), radius: 38, opacity: 1)
		addButton.isEnabled = false
		addButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.ana_kicks += 1
			self.countLabel.text = String(format: "%02d", self.ana_kicks)
			self.stepImageView.image = UIImage(named: "Kick_Add_Steps_Active_\(self.ana_kicks % 2)")
			self.view.layoutNow()
		}
		view.addSubview(addButton)
		
		timeLabel = UILabel()
		timeLabel.text = "00:00"
		timeLabel.textColor = .color(hexString: "#6a515e")
		timeLabel.font = UIFont(name: "Poppins-SemiBold", size: 24)
		view.addSubview(timeLabel)
		
		buttonGradientView = UIView()
		buttonGradientView.layer.cornerRadius = 27
		buttonGradientView.backgroundColor = .color(hexString: "#ffe8e8")
		buttonGradientView.setShadow(color: .color(hexString: "#28d3afb8"), offset: CGSize(width: 0, height: 12), radius: 30, opacity: 1)
		view.addSubview(buttonGradientView)
		
		buttonGradientLayer = CAGradientLayer()
		buttonGradientLayer.cornerRadius = 27
		buttonGradientLayer.colors = [UIColor.color(hexString: "#fff3ed").cgColor, UIColor.color(hexString: "#ffdde4").cgColor]
		buttonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		buttonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		buttonGradientView.layer.addSublayer(buttonGradientLayer)
		
		button = UIButton()
		button.layer.cornerRadius = 27
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.color(hexString: "#80fcfcfc").cgColor
		button.backgroundColor = .clear
		button.setTitle("Start", for: .normal)
		button.setTitleColor(.color(hexString: "#6a515e"), for: .normal)
		button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
		button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			if self.ana_timer?.isValid != true {
				self.stepImageView.image = UIImage(named: "Kick_Add_Steps_Active_0")
				self.addButton.isEnabled = true
				self.button.setTitle("Done", for: .normal)
				self.ana_timer?.invalidate()
				self.ana_timer = nil
				self.ana_timerStartDate = Date()
				self.ana_timer = Timer(timeInterval: 1, repeats: true, block: {
					[weak self] _ in
					guard let self = self else { return }
					if let startDate = self.ana_timerStartDate {
						let timeInterval = Date().timeIntervalSince(startDate)
						if timeInterval >= 6000 {
							self.timeLabel.text = "99:59"
						} else {
							var seconds = Int(timeInterval)
							var minute = 0
							while seconds >= 60 {
								minute += 1
								seconds -= 60
							}
							self.timeLabel.text = String(format: "%02d:%02d", minute, seconds)
						}
						self.view.layoutNow()
					}
				})
				RunLoop.current.add(self.ana_timer!, forMode: .default)
			} else {
				var duration: TimeInterval = 0
				if let startDate = self.ana_timerStartDate {
					duration = Date().timeIntervalSince(startDate)
				}
				DbManager.manager.insertKicks(duration: min(Int(duration), 6000), kicks: self.ana_kicks)
				self.navigationController?.popViewController(animated: true)
			}
		}
		view.addSubview(button)
		
		view.bringSubviewToFront(ana_closeButton)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_gradientView.frame = view.bounds
		ana_gradientLayer.frame = ana_gradientView.bounds
		ana_closeButton.sizeToFit()
		ana_closeButton.setOrigin(x: 20, y: topSpacing() + 27)
		backImageView.sizeToFit()
		backImageView.center = CGPoint(x: view.halfWidth(), y: ana_closeButton.maxY() + 43 + backImageView.halfHeight())
		stepImageView.sizeToFit()
		stepImageView.center = CGPoint(x: backImageView.halfWidth(), y: 110 + stepImageView.halfHeight())
		countLabel.sizeToFit()
		countLabel.center = CGPoint(x: backImageView.halfWidth(), y: 275)
		addButton.sizeToFit()
		addButton.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.7)
		timeLabel.sizeToFit()
		timeLabel.center = CGPoint(x: view.halfWidth(), y: addButton.maxY() + 38)
		buttonGradientView.bounds = CGRect(x: 0, y: 0, width: 250, height: 54)
		buttonGradientView.center = CGPoint(x: view.halfWidth(), y: view.height() - bottomSpacing() - 40 - buttonGradientView.halfHeight())
		buttonGradientLayer.frame = buttonGradientView.bounds
		button.frame = buttonGradientView.frame
	}
}
