//
//  NBNewStroreManager.swift
//  Fonts
//
//  Created by luoyue on 2020/7/14.
//  Copyright © 2020 luoyue. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import AppsFlyerLib


extension SKProduct{
    var regularPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? ""
    }
    var freeDays: Int{
        var freedays = 0
        if let periods =  introductoryPrice?.numberOfPeriods, let units = introductoryPrice?.subscriptionPeriod.numberOfUnits  {
            switch introductoryPrice?.subscriptionPeriod.unit {
            case .day:
                freedays = periods * units
            case .week:
                freedays = periods * units * 7
            case .month:
                freedays = periods * units * 30
            case .year:
                freedays = periods * units * 365
            default:
                break
            }
        }
        return freedays
    }
}

struct NBPurchaseState {
    var cheackSuccess: Bool
    var haveSubscription: Bool
    var deadLine: Date?
    var receiptItems: [ReceiptItem]
}



class NBNewStoreManager: NSObject,SKPaymentTransactionObserver{

    //购买状态
    enum NBPurchaseStatus {
        case purchaseFailure        //购买失败
        case purchaseCancelled       //支付取消
        case purchaseSuccess
    }
    
    enum NBRestoreStatus{
        case noPurchase         //未购买
        case restoreSuccess     //恢复成功
        case restoreFailed      //恢复失败
    }

	let monthProductId = "com.babyhear.monthplan"
    let sharedSecret = "e2a31bb4d24646119675061c980eca35"
    
    private var products: [SKProduct]?

    
    static let shard = NBNewStoreManager()
    
    @objc open class func shardInstance() -> NBNewStoreManager{
        return shard
    }
    
    
    @objc open func completeTransactions(){
        SwiftyStoreKit.completeTransactions(atomically: true) {
            purchases in
            for purchase in purchases {
                var debugString = ""
                switch purchase.transaction.transactionState {
                case .purchased:
                    if purchase.originalTransaction != nil{
                        #if DEBUG
                        debugString = "支付队列回调 - 扣费成功/续期"
                        #endif
                    } else {
                        #if DEBUG
                        debugString = "支付队列回调 - 首次购买"
                        #endif
                    }
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    NotificationCenter.default.post(name: .NBAppPurchasedStatusDidChange, object: nil)
                    //通知自动续期成功
                case .restored:
                    #if DEBUG
                    debugString = "支付队列回调 - 恢复成功自动通知"
                    #endif
                    
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
				
				@unknown default:
					break
				}
                print(debugString)
            }
        }
        SKPaymentQueue.default().add(self)
    }
    
    
    func allProuductIds() -> [String] {
        return [monthProductId]
    }
    
    /**获取所有产品信息*/
    func retrieveProductsInfo(_ needReload:Bool = false,_ callBack:@escaping ((_ isSuccess: Bool,_ products: [SKProduct])->())) {
        if needReload{
            products = nil
        }
        if let products = products{
            callBack(true,products)
            return
        }
        
        SwiftyStoreKit.retrieveProductsInfo(Set(allProuductIds())) { (result) in
            var products : [SKProduct] = []
            var isSuccess :Bool = false
             if result.error == nil{
                let productSet = result.retrievedProducts
                if !productSet.isEmpty{
                    isSuccess = true
                    products = Array(productSet)
                }
            }
            callBack(isSuccess,products)
        }
    }
    
    /**购买*/
    func purchaseProduct(_ product: SKProduct, callBack:@escaping ((_ status: NBPurchaseStatus)->())) {
        SwiftyStoreKit.purchaseProduct(product) {
            result in
            var status: NBPurchaseStatus = .purchaseFailure
            switch result {
            case .success(let purchase):
                
                var origin_transaction_id = ""
            
                if purchase.originalTransaction != nil{
                    origin_transaction_id = purchase.originalTransaction!.transactionIdentifier ?? ""
                    //在这里获取  transaction.transactionId 提交给服务器
                    print("有订阅购买" + origin_transaction_id)
                } else{
                    origin_transaction_id = purchase.transaction.transactionIdentifier ?? ""
                    print("第一次购买" + origin_transaction_id)
                }
                status = .purchaseSuccess
				
            case .error(let error):
                status = .purchaseFailure
                switch error.code {
                case .paymentCancelled:
                    status = .purchaseCancelled
                default:
                    status = .purchaseFailure
                }
            }
            callBack(status)
        }
    }
    
    /**恢复购买*/
    func restorePurchases(_ callBack:@escaping ((_ restoreStatus: NBRestoreStatus)->())) {
        
        SwiftyStoreKit.restorePurchases { (results) in
            
            print(results)
            var restoreStatus: NBRestoreStatus = .noPurchase
            if results.restoreFailedPurchases.count > 0 {
                restoreStatus = .restoreFailed
            }else if results.restoredPurchases.count > 0 {
               restoreStatus = .restoreSuccess
            }else {
                restoreStatus = .noPurchase
            }
            callBack(restoreStatus)
        }
    }
	
    /**检查订阅状态*/
	func checkPurchaseStatus(_ callBack:@escaping ((_ purchaseState: NBPurchaseState)->())) {
        #if DEBUG
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: sharedSecret)
        #else
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        #endif
        weak var weakSelf = self
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            var cheackSuccess: Bool = false
			//是否有买断状态
//            let haveOnetimePurchase: Bool = false
            //是否有订阅
            var haveSubscription: Bool = false
            //订阅到期时间
            var deadLine: Date?
            //有订阅过时 返回的数据详情 不管是否取消
            var receiptItems: [ReceiptItem] = []
            
            switch result {
            case .success(let receipt):
                cheackSuccess = true
				
				//一次购买状态
//				if let onetimeId = weakSelf?.onceProductId {
//					let onetimeResult = SwiftyStoreKit.verifyPurchase(productId: onetimeId, inReceipt: receipt)
//					switch onetimeResult {
//					case .purchased( _):
//						haveOnetimePurchase = true
//						haveSubscription = true
//					case .notPurchased:
//						haveOnetimePurchase = false
//						haveSubscription = false
//					}
//				}
				 
				var productIds = [String]()
                if let monthProductId = weakSelf?.monthProductId {
                    productIds.append(monthProductId)
                }
//				if let sixMonthProductId = weakSelf?.yearProductId {
//					productIds.append(sixMonthProductId)
//				}
//                if let weekProductId = weakSelf?.weekProductId {
//                    productIds.append(weekProductId)
//                }
                if productIds.count > 0 {
                    let subscriptionGroupId = Set(productIds)
                    let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: subscriptionGroupId, inReceipt: receipt)
                    print(purchaseResult)
                    switch purchaseResult {
                    case .purchased(let expiryDate, let items):
                        print(expiryDate)
                        haveSubscription = true
                        deadLine = expiryDate
                        receiptItems = items

                    case .expired(let expiryDate, let items):
                        //订阅已经到期 相当于没有订阅 不用记录到期时间
                        deadLine = expiryDate
                        receiptItems = items
                    case .notPurchased:
                        break
                    }
                }
			case .error( _):
                //请求失败状态
                break
            }
            let purchaseState = NBPurchaseState(cheackSuccess: cheackSuccess, haveSubscription: haveSubscription, deadLine: deadLine, receiptItems: receiptItems)
			/*if haveOnetimePurchase { //有一次性买断
				NBUserVipStatusManager.shard.recordOnetimePurchase()
				callBack(purchaseState)
			} else */if haveSubscription {  //有订阅
				NBUserVipStatusManager.shard.recordSubscriptionStatus(deadLine)
				callBack(purchaseState)
			} else {
				NBUserVipStatusManager.shard.recordSubscriptionStatus(nil)
				callBack(purchaseState)
			}
        }
    }
    
	//MARK:--SKPaymentTransactionObserver
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
	}
        
	func paymentQueueDidChangeStorefront(_ queue: SKPaymentQueue) {
		NotificationCenter.default.post(name: .NBAppStoreDidChange, object: nil)
	}
}


extension NBNewStoreManager{
    /**
        * 支付并更新订阅状态
        * purchaseStatus   支付状态
        * purchaseState  用于票据状态
        */
       func purchaseProductAndCheckSubscriptions(_ product: SKProduct,_ callBack:@escaping  ((_ purchaseStatus: NBPurchaseStatus,_ purchaseState: NBPurchaseState?)->())) {
           purchaseProduct(product) {  [weak self](purchaseStatus) in
               if purchaseStatus == .purchaseSuccess{
                   self?.checkPurchaseStatus { (purchaseState) in
                       callBack(purchaseStatus,purchaseState)
                   }
               }else{
                   callBack(purchaseStatus,nil)
               }
           }
       }
       
       /**
        *      isHavePurchases 是否有购买订单
        *      isRestoreSuccess  是否恢复成功
        *      purchaseState  用于票据状态
        */
       func restoreAndCheckSubscriptions(_ callBack:@escaping  ((_ restoreStatus: NBRestoreStatus, _ purchaseState: NBPurchaseState?)->())){
           restorePurchases { [weak self] (aRestoreStatus) in
               switch aRestoreStatus{
               case .restoreSuccess:
                   self?.checkPurchaseStatus { (purchaseState) in
                       callBack(aRestoreStatus,purchaseState)
                   }
               case .restoreFailed,.noPurchase:
                   callBack(aRestoreStatus,nil)
               }
           }
       }
}






extension NBNewStoreManager{
    
    //获取免费天
    static func getFreeDays(_ product:SKProduct) -> Int{
        var freeDays = 0
        if #available(iOS 11.2, *) {
            if let periods =  product.introductoryPrice?.numberOfPeriods, let units = product.introductoryPrice?.subscriptionPeriod.numberOfUnits  {
                switch product.introductoryPrice?.subscriptionPeriod.unit {
                case .day:
                    freeDays = periods * units
                case .week:
                    freeDays = periods * units * 7
                case .month:
                    freeDays = periods * units * 30
                case .year:
                    freeDays = periods * units * 365
                default:
                    break
                }
            }
        }
        return freeDays
    }
    
    //获取国际化价格
    static func getLocationPrice(_ product:SKProduct) -> NSDecimalNumber{
        let originPrice = product.price
        return originPrice
    }
    static func getCycles(_ product:SKProduct) -> String{
           var cycles = ""
           if #available(iOS 11.2, *) {
               switch product.subscriptionPeriod?.unit {
               case .day:
                   cycles = "day"
               case .week:
                   cycles = "week"
               case .month:
                   cycles = "month"
               case .year:
                   cycles = "year"
               default:
                   break
               }
           } else {
               cycles = product.productIdentifier
               // Fallback on earlier versions
           }
           return cycles
       }
       
       static func getSymbol(_ product:SKProduct) -> String {
           return product.priceLocale.currencySymbol ?? ""
       }
    
       static func getProductInfo(_ product: SKProduct) -> String{
           let cycles = getCycles(product)
           let freeDays = getFreeDays(product)
           let price = getLocationPrice(product)
           let symbol = getSymbol(product)
           let productInfo = String(format: "%@ %@%@%.2f", cycles, (freeDays == 0) ?"" :"\(freeDays)days free + ", symbol,price.doubleValue)
           return productInfo
       }
}


extension Notification.Name{
    //商店发生变化通知
    static let  NBAppStoreDidChange = Notification.Name.init("NBAppStoreDidChange")
    static let  NBAppPurchasedStatusDidChange = Notification.Name.init("NBAppPurchasedStatusDidChange")
    
//    static let
}
