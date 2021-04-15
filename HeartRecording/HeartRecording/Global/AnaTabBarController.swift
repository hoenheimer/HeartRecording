//
//  AnaTabBarController.swift
//  totowallet
//
//  Created by Yuan Ana on 2020/12/28.
//

import Foundation
import UIKit
import ReactiveSwift


class AnaTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let tabbar = AnaTabBar()
		setValue(tabbar, forKey: "tabBar")
		
		let apperance = tabBar.standardAppearance.copy()
		apperance.backgroundImage = UIImage()
		apperance.shadowImage = UIImage()
		apperance.configureWithTransparentBackground()
		tabBar.standardAppearance = apperance
		
        func navigationVC(rootVC: UIViewController, imageName: String, title: String) -> AnaNavigationController {
			let navigationController = AnaNavigationController(rootViewController: rootVC)
			navigationController.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
			let image = UIImage(named: imageName)?.reSizeImage(reSize: CGSize(width: 22, height: 22))
            navigationController.tabBarItem.title = title
			navigationController.tabBarItem.image = image?.withRenderingMode(.alwaysTemplate)
			navigationController.tabBarItem.selectedImage = image?.withTintColor(.color(hexString: "#6D5FFE"), renderingMode: .alwaysOriginal)
			navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
			return navigationController
		}
			
		viewControllers = [
			navigationVC(rootVC: RecordViewController(), imageName: "TabBar_Home", title: "Record Now"),
            navigationVC(rootVC: UIViewController(), imageName: "TabBar_Home", title: "Recording"),
            navigationVC(rootVC: UIViewController(), imageName: "TabBar_Home", title: "Setting")
		]
	}
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        FeedbackManager.feedback(type: .light)
    }
}
