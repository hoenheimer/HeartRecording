//
//  AnaTabBarController.swift
//  totowallet
//
//  Created by Yuan Ana on 2020/12/28.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa


class AnaTabBarController: UITabBarController {
	var simulationTabBar: UIView!
	var button1: TabbarButton!
	var button2: TabbarButton!
	var button3: TabbarButton!
	var button4: TabbarButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.isHidden = true
		
		viewControllers = [
			AnaNavigationController(rootViewController: UserDefaults.standard.bool(forKey: "Have_Launch_Once") ? KickCounterViewController() : BaseViewController1()),
			AnaNavigationController(rootViewController: RecordViewController()),
			AnaNavigationController(rootViewController: RecordingListViewController()),
			AnaNavigationController(rootViewController: SettingViewController())
		]
		
		simulationTabBar = UIView()
		simulationTabBar.layer.cornerRadius = 25
		simulationTabBar.backgroundColor = .white
		simulationTabBar.setShadow(color: .color(hexString: "#1ee46a7d"), offset: CGSize(width: 0, height: 19), radius: 50, opacity: 1)
		view.addSubview(simulationTabBar)
		
		func newButton(index: Int, imageNameSuffix: String, title: String) -> TabbarButton {
			let button = TabbarButton()
			button.index = index
			button.backgroundColor = .clear
			let selected = index == 0
			button.imageNameSuffix = imageNameSuffix
			button.setImage(UIImage(named: imageNameSuffix + (selected ? "_Selected" : "_Unselected")), for: .normal)
			button.setTitle(title, for: .normal)
			button.setTitleColor(.color(hexString: (selected ? "#e46a7d" : "#f5d1d6")), for: .normal)
			button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
			button.reactive.controlEvents(.touchUpInside).observeValues {
				[weak self] touchButton in
				guard let self = self else { return }
				guard self.selectedIndex != index else { return }
				FeedbackManager.feedback(type: .light)
				self.selectedIndex = index
				for button in [self.button1, self.button2, self.button3, self.button4] {
					if let button = button {
						let selected = button == touchButton
						button.setImage(UIImage(named: button.imageNameSuffix + (selected ? "_Selected" : "_Unselected")), for: .normal)
						button.setTitleColor(.color(hexString: (selected ? "#e46a7d" : "#f5d1d6")), for: .normal)
					}
				}
			}
			simulationTabBar.addSubview(button)
			return button
		}
		
		button1 = newButton(index: 0, imageNameSuffix: "TabBar_Kicks", title: "Heartbeat")
		button2 = newButton(index: 1, imageNameSuffix: "TabBar_Record", title: "Recording")
		button3 = newButton(index: 2, imageNameSuffix: "TabBar_List", title: "Audio")
		button4 = newButton(index: 3, imageNameSuffix: "TabBar_Setting", title: "Setting")
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		let margin = AnaNavigationController.margin
		simulationTabBar.frame = CGRect(x: margin, y: view.height() - 13 - bottomSpacing() - 82, width: view.width() - margin * 2, height: 82)
		let buttonWidth = (simulationTabBar.width() - 44) / 4
		var x: CGFloat = 13
		for button in [self.button1, self.button2, self.button3, self.button4] {
			if let button = button {
				button.frame = CGRect(x: x, y: 15, width: buttonWidth, height: 56)
				x = button.maxX() + 6
			}
		}
	}
}


class TabbarButton: UIButton {
	var index = 0
	var imageNameSuffix: String!
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
	}
	
	
	override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
		let imageRect = super.imageRect(forContentRect: contentRect)
		let titleRect = super.titleRect(forContentRect: contentRect)
		return CGRect(x: (contentRect.width - imageRect.width) / 2,
					  y: (contentRect.height - imageRect.height - 8 - titleRect.height) / 2,
					  width: imageRect.width,
					  height: imageRect.height)
	}
	
	
	override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
		let imageRect = super.imageRect(forContentRect: contentRect)
		let titleRect = super.titleRect(forContentRect: contentRect)
		return CGRect(x: (contentRect.width - titleRect.width) / 2,
					  y: (contentRect.height - imageRect.height - 8 - titleRect.height) / 2 + imageRect.height + 8,
					  width: titleRect.width,
					  height: titleRect.height)
	}
}
