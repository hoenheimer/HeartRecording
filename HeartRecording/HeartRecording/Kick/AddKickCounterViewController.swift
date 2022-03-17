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
	
	var ana_backImageView: UIImageView!
	var ana_countLabel: UILabel!
	var ana_timeLabel: UILabel!
	var ana_addButton: UIButton!
	var ana_button: UIButton!
	
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
			tabBarController.ana_simulationTabBar.isHidden = true
		}
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = false
		if let tabBarController = tabBarController as? AnaTabBarController {
			tabBarController.ana_simulationTabBar.isHidden = false
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
		ana_gradientLayer.colors = [UIColor.color(hexString: "#fff5fb").cgColor, UIColor.white.cgColor]
		ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.23)
		ana_gradientView.layer.addSublayer(ana_gradientLayer)
		
		ana_closeButton = UIButton()
		ana_closeButton.setImage(UIImage(named: "Kick_Close"), for: .normal)
		ana_closeButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.navigationController?.popViewController(animated: true)
		}
		view.addSubview(ana_closeButton)
		
		ana_backImageView = UIImageView(image: UIImage(named: "Kick_Add_Shape"))
		view.addSubview(ana_backImageView)
		
		ana_countLabel = UILabel()
		ana_countLabel.alpha = 0.3
		ana_countLabel.text = "00"
		ana_countLabel.textColor = .color(hexString: "#504278")
		ana_countLabel.font = UIFont(name: "PingFangHK-Regular", size: 64)
		view.addSubview(ana_countLabel)
		
		ana_addButton = UIButton()
		ana_addButton.setImage(UIImage(named: "Kick_Add_Button"), for: .normal)
		ana_addButton.setImage(UIImage(named: "Kick_Add_Button_Disabled"), for: .disabled)
		ana_addButton.setShadow(color: .color(hexString: "#35d74b61"), offset: CGSize(width: 0, height: 12), radius: 38, opacity: 1)
		ana_addButton.isEnabled = false
		ana_addButton.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.ana_kicks += 1
			self.ana_countLabel.text = String(format: "%02d", self.ana_kicks)
			self.view.layoutNow()
		}
		view.addSubview(ana_addButton)
		
		ana_timeLabel = UILabel()
		ana_timeLabel.text = "00:00"
		ana_timeLabel.textColor = .color(hexString: "#504278")
		ana_timeLabel.font = UIFont(name: "PingFangHK-SemiBold", size: 18)
		view.addSubview(ana_timeLabel)
		
		ana_button = UIButton()
		ana_button.layer.cornerRadius = 27
		ana_button.backgroundColor = .color(hexString: "#4c8059f3")
		ana_button.setTitle("Start", for: .normal)
		ana_button.setTitleColor(.color(hexString: "#504278"), for: .normal)
		ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
		ana_button.reactive.controlEvents(.touchUpInside).observeValues {
			[weak self] _ in
			guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			if self.ana_timer?.isValid != true {
				self.ana_countLabel.alpha = 1
				self.ana_addButton.isEnabled = true
				self.ana_button.setTitle("Done", for: .normal)
				self.ana_timer?.invalidate()
				self.ana_timer = nil
				self.ana_timerStartDate = Date()
				self.ana_timer = Timer(timeInterval: 1, repeats: true, block: {
					[weak self] _ in
					guard let self = self else { return }
					if let startDate = self.ana_timerStartDate {
						let timeInterval = Date().timeIntervalSince(startDate)
						if timeInterval >= 6000 {
							self.ana_timeLabel.text = "99:59"
						} else {
							var seconds = Int(timeInterval)
							var minute = 0
							while seconds >= 60 {
								minute += 1
								seconds -= 60
							}
							self.ana_timeLabel.text = String(format: "%02d:%02d", minute, seconds)
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
		view.addSubview(ana_button)
		
		view.bringSubviewToFront(ana_closeButton)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		ana_gradientView.frame = view.bounds
		ana_gradientLayer.frame = ana_gradientView.bounds
		ana_closeButton.sizeToFit()
		ana_closeButton.setOrigin(x: 24, y: topSpacing() + 25)
		ana_backImageView.sizeToFit()
		ana_backImageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.39)
		ana_countLabel.sizeToFit()
		ana_countLabel.center = ana_backImageView.center
		ana_timeLabel.sizeToFit()
		ana_timeLabel.bounds = CGRect(x: 0, y: 0, width: ana_timeLabel.width(), height: 44)
		ana_timeLabel.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.65)
		ana_addButton.sizeToFit()
		ana_addButton.center = CGPoint(x: view.halfWidth(), y: ana_timeLabel.maxY() + 8 + ana_addButton.halfHeight())
		ana_button.bounds = CGRect(x: 0, y: 0, width: view.width() - 24 * 2, height: 54)
		ana_button.center = CGPoint(x: view.halfWidth(), y: view.height() - bottomSpacing() - 33 - ana_button.halfHeight())
	}
}
