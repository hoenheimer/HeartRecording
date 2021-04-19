//
//  NBInAppPurchaseProtocol.swift
//  Fonts
//
//  Created by yue luo on 2020/9/14.
//  Copyright © 2020 luoyue. All rights reserved.
//

//import UIKit
import StoreKit

protocol NBInAppPurchaseProtocol {
     /**获取订阅商品成功*/
    func subscriptionProductsDidReciveSuccess(products: [SKProduct])
    /**获取订阅商品失败*/
    func subscriptionProductsDidReciveFailure()
    /*
     * 订阅成功
     * needUnsubscribe  是否需要取消订阅
     */
    func purchasedSuccess(_ needUnsubscribe: Bool)
    /**订阅失败*/
    func purchasedFailure()
    /**恢复购买成功*/
    func restorePurchaseSuccess()
    /**恢复购买失败*/
    func restorePurchaseFailure()
    /*
     * 已经有购买回调
     * isOnetime   true 一次性购买， false 订阅
     */
    func haspurchased(_ isOnetime: Bool)

}


extension NBInAppPurchaseProtocol{
    /**获取订阅商品成功*/
    func subscriptionProductsDidReciveSuccess(products: [SKProduct]){}
    /**获取订阅商品失败*/
    func subscriptionProductsDidReciveFailure(){}
     /*
      * 订阅成功
      * needUnsubscribe  是否需要取消订阅
      */
    func purchasedSuccess(_ needUnsubscribe: Bool){}
       /**订阅失败*/
    func purchasedFailure(){}
       /**恢复购买成功*/
    func restorePurchaseSuccess(){}
       /**恢复购买失败*/
    func restorePurchaseFailure(){}
    /*
     * 已经有购买回调
     * isOnetime   true 一次性购买， false 订阅
     */
    func haspurchased(_ isOnetime: Bool){}
}


extension NBInAppPurchaseProtocol where Self : UIViewController{
    //获取产品
    func requestProducts()  {
        NBNewStoreManager.shard.retrieveProductsInfo(true) { [weak self](isSuccess, aProducts) in
            if isSuccess{
                self?.subscriptionProductsDidReciveSuccess(products: aProducts)
            }else{
                self?.subscriptionProductsDidReciveFailure()
            }
        }
    }
	
    func purchase(product:SKProduct, needUnsubscribe: Bool = true) {
        NBLoadingBox.startLoadingAnimation()
        NBNewStoreManager.shard.purchaseProductAndCheckSubscriptions(product) { [weak self](purchaseStatus, purchaseState) in
			DispatchQueue.main.async {
				NBLoadingBox.stopLoadAnimation()
			}
            switch purchaseStatus{
            case .purchaseSuccess:
                if let purchaseState = purchaseState{
					if purchaseState.haveSubscription{  //有订阅
					   self?.purchasedSuccess(needUnsubscribe)
					}else{
						self?.purchasedFailure()
					}
                }
            case .purchaseFailure:
                self?.purchasedFailure()
            case .purchaseCancelled:
                break
            }
        }
    }
    
    
    func restorePurchaseData(){
        NBLoadingBox.startLoadingAnimation()
        NBNewStoreManager.shard.restoreAndCheckSubscriptions { [weak self](restoreStatus, purchaseState) in
            NBLoadingBox.stopLoadAnimation()
            switch restoreStatus{
            case .noPurchase:
                 self?.restorePurchaseFailure()
            case .restoreFailed:
                 self?.restorePurchaseFailure()
            case .restoreSuccess:
                if let purchaseState = purchaseState{
					if purchaseState.haveSubscription{  //有订阅
						 self?.restorePurchaseSuccess()
					}else{
						 self?.restorePurchaseFailure()
					}
                }
            }
        }
    }
}
