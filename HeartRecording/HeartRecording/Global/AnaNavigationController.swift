//
//  AnaNavigationController.swift
//  totowallet
//
//  Created by Yuan Ana on 2020/12/28.
//

import Foundation
import UIKit


class AnaNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationBar.prefersLargeTitles = false
		navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationBar.shadowImage = UIImage()
		navigationBar.backgroundColor = .clear
        
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.color(hexString: "#88684C")]
	}
	
	func pushViewController(_ viewController: UIViewController, animated: Bool, color: UIColor) {
		let backBarButtonItem = UIBarButtonItem(title: Iconfont.backArrow.rawValue, style: .plain, target: self, action: nil)
		backBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "iconfont", size: 16) as Any,
												  NSAttributedString.Key.foregroundColor : color as Any], for: .normal)
		backBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "iconfont", size: 16) as Any,
												  NSAttributedString.Key.foregroundColor : color as Any], for: .selected)
		backBarButtonItem.setBackButtonBackgroundImage(UIImage(color: .clear, size: CGSize(width: 0, height: 0)), for: .normal, barMetrics: .default)
		visibleViewController?.navigationItem.backBarButtonItem = backBarButtonItem
		super.pushViewController(viewController, animated: animated)
	}
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		pushViewController(viewController, animated: animated, color: UIColor.color(hexString: "#88684C"))
	}
	
	
	static var margin: CGFloat = 20
}
