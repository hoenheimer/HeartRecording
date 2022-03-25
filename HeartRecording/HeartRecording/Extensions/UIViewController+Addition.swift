//
//  UIViewController+Addition.swift
//  totowallet
//
//  Created by Yuan Ana on 2020/12/28.
//

import Foundation
import UIKit


public extension UIViewController {
    func getWindoww() -> UIWindow {
        if view.window != nil {
            return view.window!
        } else {
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first ?? UIWindow()
        }
    }
    
    
	func statusBarHeight() -> CGFloat {
		return getWindoww().windowScene!.statusBarManager?.statusBarFrame.size.height ?? 0
	}
	
	
	func navigationBarHeight() -> CGFloat {
		return navigationController?.navigationBar.isHidden ?? true ? 0 : navigationController!.navigationBar.height()
	}
	
	
	func topSpacing() -> CGFloat {
		return statusBarHeight() + navigationBarHeight()
	}
	
	
	func bottomSafeAreaPadding() -> CGFloat {
		return view.safeAreaInsets.bottom
	}
	
	
	func tabBarHeight() -> CGFloat {
		if let simulationTabBar = (tabBarController as? AnaTabBarController)?.ana_simulationTabBar {
			return view.height() - simulationTabBar.minY()
		}
        if let tabBarController = tabBarController {
            return tabBarController.tabBar.isHidden ? 0 : tabBarController.tabBar.height()
        }
        return 0
	}
	
	
	func bottomSpacing() -> CGFloat {
		if tabBarHeight() > 0 {
			return tabBarHeight()
		} else {
			return bottomSafeAreaPadding()
		}
	}
	
	
	class func getCurrentViewController(base: UIViewController?) -> UIViewController? {
		var base = base
		if base == nil {
			let keyWindow = UIApplication.shared.connectedScenes
					.filter({$0.activationState == .foregroundActive})
					.map({$0 as? UIWindowScene})
					.compactMap({$0})
					.first?.windows
					.filter({$0.isKeyWindow}).first
			base = keyWindow?.rootViewController
		}
		
		if let nav = base as? UINavigationController {
			return getCurrentViewController(base: nav.visibleViewController)
		}
		if let tab = base as? UITabBarController {
			return getCurrentViewController(base: tab.selectedViewController)
		}
		if let presented = base?.presentedViewController {
			return getCurrentViewController(base: presented)
		}
		return base
	}
    
    
	func showSubscriptionIfNeeded(handle: (() -> Void)?) {
        if NBUserVipStatusManager.shard.getVipStatus() {
            if let handle = handle {
                handle()
            }
        } else {
            let vc = SubscriptionViewController(success: handle)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
