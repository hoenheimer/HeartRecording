//
//  SubscriptionViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/20.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import StoreKit


public enum SubscriptionScene: String {
	case normal = "normal"
	case guide = "guide"
	case record = "record"
	case play = "play"
	case share = "share"
}


class SubscriptionViewController: UIViewController {
    var ana_gradientLayer:          CAGradientLayer!
    var ana_scrollView:             UIScrollView!
    var ana_closeButton:            UIButton!
    var ana_titleLabel:             UILabel!
    var ana_imageView:              UIImageView!
    var ana_featuresBackView:       UIView!
    var ana_iconImageView1:         UIImageView!
    var ana_iconImageView2:         UIImageView!
    var ana_iconImageView3:         UIImageView!
    var ana_featureLabel1:          UILabel!
    var ana_featureLabel2:          UILabel!
    var ana_featureLabel3:          UILabel!
    var ana_freeDayLabel:           UILabel!
    var ana_buttonBackView:         UIView!
    var ana_buttonShadowView:       UIView!
    var ana_buttonGradientView:     UIView!
    var ana_buttonGradientLayer:    CAGradientLayer!
    var ana_button:                 UIButton!
    var ana_activityView:           UIActivityIndicatorView!
    var ana_buttonBottomButton:     UIButton!
    var ana_restoreButton:          UIButton!
    var ana_termsButton:            UIButton!
    var ana_privacyButton:          UIButton!
    var ana_bottomLabel:            UILabel!
	
	var ana_scene: SubscriptionScene = .normal
    
    var ana_product: SKProduct?
    var ana_success: (() -> Void)? = nil
	var ana_dismiss: (() -> Void)? = nil
    
    
    convenience init(success: (() -> Void)?) {
        self.init()
        self.ana_success = success
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestProducts()
        configure()
    }
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		EventManager.log(name: "Subscription_Show_\(ana_scene)")
		EventManager.log(name: "Subscription_Show")
	}
    
    
    func configure() {
        ana_gradientLayer = CAGradientLayer()
        ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        ana_gradientLayer.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
        view.layer.addSublayer(ana_gradientLayer)
        
        ana_scrollView = UIScrollView()
        ana_scrollView.backgroundColor = .clear
        view.addSubview(ana_scrollView)
        
        ana_closeButton = UIButton()
        ana_closeButton.setImage(UIImage(named: "Detail_Close"), for: .normal)
        ana_closeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
			self.dismiss(animated: true, completion: self.ana_dismiss)
			EventManager.log(name: "Subscription_cancel_\(self.ana_scene)")
			EventManager.log(name: "Subscription_cancel")
        }
        view.addSubview(ana_closeButton)
        
        ana_titleLabel = UILabel()
        ana_titleLabel.text = "BabyCare  Premium"
        ana_titleLabel.textColor = .black
        ana_titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 26)
        ana_scrollView.addSubview(ana_titleLabel)
        
        ana_imageView = UIImageView()
        ana_imageView.image = UIImage(named: "Subscription_Image")
        ana_scrollView.addSubview(ana_imageView)
        
        ana_featuresBackView = UIView()
        ana_featuresBackView.backgroundColor = .clear
        ana_scrollView.addSubview(ana_featuresBackView)
        
        ana_iconImageView1 = UIImageView()
        ana_iconImageView1.image = UIImage(named: "Subscription_Feature")
        ana_featuresBackView.addSubview(ana_iconImageView1)
        
        ana_iconImageView2 = UIImageView()
        ana_iconImageView2.image = UIImage(named: "Subscription_Feature")
        ana_featuresBackView.addSubview(ana_iconImageView2)
        
        ana_iconImageView3 = UIImageView()
        ana_iconImageView3.image = UIImage(named: "Subscription_Feature")
        ana_featuresBackView.addSubview(ana_iconImageView3)
        
        ana_featureLabel1 = UILabel()
        ana_featureLabel1.text = "Unlock All Features"
        ana_featureLabel1.textColor = .black
        ana_featureLabel1.font = .systemFont(ofSize: 14)
        ana_featuresBackView.addSubview(ana_featureLabel1)
        
        ana_featureLabel2 = UILabel()
        ana_featureLabel2.text = "Share Recording With Others"
        ana_featureLabel2.textColor = .black
        ana_featureLabel2.font = .systemFont(ofSize: 14)
        ana_featuresBackView.addSubview(ana_featureLabel2)
        
        ana_featureLabel3 = UILabel()
        ana_featureLabel3.text = "Remove Ads"
        ana_featureLabel3.textColor = .black
        ana_featureLabel3.font = .systemFont(ofSize: 14)
        ana_featuresBackView.addSubview(ana_featureLabel3)
        
        ana_freeDayLabel = UILabel()
        ana_freeDayLabel.textColor = .color(hexString: "#EB5757")
        ana_freeDayLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        ana_scrollView.addSubview(ana_freeDayLabel)
        
        ana_buttonBackView = UIView()
        ana_buttonBackView.backgroundColor = .clear
        ana_scrollView.addSubview(ana_buttonBackView)
        
        ana_buttonGradientView = UIView()
        ana_buttonGradientView.backgroundColor = .clear
        ana_buttonBackView.addSubview(ana_buttonGradientView)
        
        ana_buttonShadowView = UIView()
        ana_buttonShadowView.layer.cornerRadius = 24
        ana_buttonShadowView.layer.borderWidth = 1
        ana_buttonShadowView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
        ana_buttonShadowView.backgroundColor = .color(hexString: "#FF5E5E")
        ana_buttonShadowView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24)
        ana_buttonBackView.addSubview(ana_buttonShadowView)
        
        ana_buttonGradientLayer = CAGradientLayer()
        ana_buttonGradientLayer.cornerRadius = 24
        ana_buttonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        ana_buttonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        ana_buttonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF474747").cgColor]
        ana_buttonGradientView.layer.addSublayer(ana_buttonGradientLayer)
        
        ana_button = UIButton()
        ana_button.backgroundColor = .clear
		ana_button.setTitle("Continue", for: .normal)
        ana_button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
        ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
            if let product = self.ana_product {
                self.purchase(product: product)
				EventManager.income(product: product, type: "test")
            }
			EventManager.log(name: "Subscription_buttontapped_\(self.ana_scene)")
			EventManager.log(name: "Subscription_buttontapped")
        }
        ana_buttonBackView.addSubview(ana_button)
        
        ana_activityView = UIActivityIndicatorView()
        ana_activityView.color = .color(hexString: "#FCFCFC")
        ana_activityView.startAnimating()
        ana_button.addSubview(ana_activityView)
        
        ana_buttonBottomButton = UIButton()
        ana_buttonBottomButton.setTitle("Auto renewable, Cancel anytime", for: .normal)
        ana_buttonBottomButton.setTitleColor(.color(hexString: "#979797"), for: .normal)
        ana_buttonBottomButton.titleLabel?.font = .systemFont(ofSize: 13)
        ana_buttonBottomButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        ana_buttonBottomButton.isEnabled = false
        ana_scrollView.addSubview(ana_buttonBottomButton)
        
        ana_restoreButton = UIButton()
        ana_restoreButton.setTitle("RESTORE PURCHASE", for: .normal)
        ana_restoreButton.setTitleColor(.color(hexString: "#979797"), for: .normal)
        ana_restoreButton.titleLabel?.font = .systemFont(ofSize: 10, weight: .semibold)
        ana_restoreButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.restorePurchaseData()
        }
        ana_scrollView.addSubview(ana_restoreButton)
        
        ana_termsButton = UIButton()
        ana_termsButton.setAttributedTitle(NSAttributedString(string: "Terms of Service",
                                                          attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                                                                       NSAttributedString.Key.foregroundColor : UIColor.color(hexString: "#979797"),
                                                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                                                       NSAttributedString.Key.underlineColor : UIColor.color(hexString: "#979797").cgColor]),
                                       for: .normal)
        ana_termsButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            let webView = BaseWebController()
            webView.urlStr = "https://sites.google.com/view/babycaretou/home"
            webView.modalPresentationStyle = .fullScreen
            self.present(webView, animated: true, completion: nil)
        }
        ana_scrollView.addSubview(ana_termsButton)
        
        ana_privacyButton = UIButton()
        ana_privacyButton.setAttributedTitle(NSAttributedString(string: "Privacy Policy",
                                                          attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                                                                       NSAttributedString.Key.foregroundColor : UIColor.color(hexString: "#979797"),
                                                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                                                       NSAttributedString.Key.underlineColor : UIColor.color(hexString: "#979797").cgColor]),
                                       for: .normal)
        ana_privacyButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            let webView = BaseWebController()
            webView.urlStr = "https://sites.google.com/view/babycarepop/home"
            webView.modalPresentationStyle = .fullScreen
            self.present(webView, animated: true, completion: nil)
        }
        ana_scrollView.addSubview(ana_privacyButton)
        
        ana_bottomLabel = UILabel()
        ana_bottomLabel.numberOfLines = 0
        ana_bottomLabel.text = "BabyCare Premium offers weekly purchase subscription. You can subscribe to a yearly plan. You can manage or turn off auto-renew in your Apple ID account settings at any time. Subscriptions will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Any unused portion of a free trial period will be forfeited when you purchase a subscription. Our app is functional without purchasing an Auto-Renewable subscription, and you can use all the unlocked content after the subscription expires."
        ana_bottomLabel.textColor = .color(hexString: "#979797")
        ana_bottomLabel.font  = .systemFont(ofSize: 10, weight: .semibold)
        ana_scrollView.addSubview(ana_bottomLabel)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        ana_gradientLayer.frame = view.bounds
        ana_scrollView.frame = view.bounds
        ana_closeButton.sizeToFit()
        ana_closeButton.setOrigin(x: 20, y: 74)
        ana_titleLabel.sizeToFit()
        ana_titleLabel.center = CGPoint(x: ana_scrollView.halfWidth(), y: 136 + ana_titleLabel.halfHeight())
        ana_imageView.sizeToFit()
        ana_imageView.center = CGPoint(x: ana_scrollView.halfWidth(), y: ana_titleLabel.maxY() + 22 + ana_imageView.halfHeight())
        ana_iconImageView1.sizeToFit()
        ana_iconImageView1.setOrigin(x: 0, y: 0)
        ana_iconImageView2.sizeToFit()
        ana_iconImageView2.setOrigin(x: 0, y: ana_iconImageView1.maxY() + 22)
        ana_iconImageView3.sizeToFit()
        ana_iconImageView3.setOrigin(x: 0, y: ana_iconImageView2.maxY() + 22)
        ana_featureLabel1.sizeToFit()
        ana_featureLabel1.center = CGPoint(x: ana_iconImageView1.maxX() + 23 + ana_featureLabel1.halfWidth(), y: ana_iconImageView1.centerY())
        ana_featureLabel2.sizeToFit()
        ana_featureLabel2.center = CGPoint(x: ana_iconImageView2.maxX() + 23 + ana_featureLabel2.halfWidth(), y: ana_iconImageView2.centerY())
        ana_featureLabel3.sizeToFit()
        ana_featureLabel3.center = CGPoint(x: ana_iconImageView3.maxX() + 23 + ana_featureLabel3.halfWidth(), y: ana_iconImageView3.centerY())
        ana_featuresBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(ana_featureLabel1.maxX(), ana_featureLabel2.maxX(), ana_featureLabel3.maxX()),
                                                                     height: ana_iconImageView3.maxY()))
        ana_featuresBackView.center = CGPoint(x: ana_scrollView.halfWidth(), y: ana_imageView.maxY() + 15 + ana_featuresBackView.halfHeight())
        ana_freeDayLabel.sizeToFit()
        ana_buttonBackView.frame = CGRect(x: 42, y: ana_featuresBackView.maxY() + 72, width: ana_scrollView.width() - 84, height: 48)
        ana_freeDayLabel.center = CGPoint(x: ana_scrollView.halfWidth(), y: ana_buttonBackView.minY() - 10 - ana_freeDayLabel.halfHeight())
        ana_buttonShadowView.frame = ana_buttonBackView.bounds
        ana_buttonGradientView.frame = ana_buttonShadowView.frame
        ana_buttonGradientLayer.frame = ana_buttonGradientView.bounds
        ana_button.frame = ana_buttonGradientView.frame
        ana_activityView.sizeToFit()
        ana_activityView.center = CGPoint(x: ana_button.halfWidth(), y: ana_button.halfHeight())
        ana_buttonBottomButton.sizeToFit()
        ana_buttonBottomButton.center = CGPoint(x: ana_scrollView.halfWidth(), y: ana_buttonBackView.maxY() + 7 + ana_buttonBottomButton.halfHeight())
        ana_restoreButton.sizeToFit()
        ana_restoreButton.setOrigin(x: 42, y: ana_buttonBottomButton.maxY() + 29)
        ana_privacyButton.sizeToFit()
        ana_privacyButton.center = CGPoint(x: ana_scrollView.width() - 42 - ana_privacyButton.halfWidth(), y: ana_restoreButton.centerY())
        ana_termsButton.sizeToFit()
        ana_termsButton.center = CGPoint(x: ana_privacyButton.minX() - 27 - ana_termsButton.halfWidth(), y: ana_privacyButton.centerY())
        let size = ana_bottomLabel.sizeThatFits(CGSize(width: ana_scrollView.width() - 84, height: .greatestFiniteMagnitude))
        ana_bottomLabel.frame = CGRect(x: 42, y: ana_restoreButton.maxY() + 3, width: size.width, height: size.height)
        ana_scrollView.contentSize = CGSize(width: ana_scrollView.width(), height: ana_bottomLabel.maxY())
    }
    
    
    func requestSuccess() {
        ana_activityView.stopAnimating()
        if let product = ana_product {
            var string = ""
			if product.freeDays > 0 {
				string.append("\(product.freeDays) Days Free Trial, Then ")
			}
			let timeString = product.subscriptionPeriod?.unit == .month ? "Month" : "Year"
			string.append("Only \(product.regularPrice)/\(timeString)")
			ana_freeDayLabel.text = string
            
			let littleTimeString = product.subscriptionPeriod?.unit == .month ? "month" : "year"
            ana_bottomLabel.text = "BabyCare Premium offers weekly purchase subscription. You can subscribe to a monthly plan(\(product.regularPrice) per \(littleTimeString). You can manage or turn off auto-renew in your Apple ID account settings at any time. Subscriptions will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Any unused portion of a free trial period will be forfeited when you purchase a subscription. Our app is functional without purchasing an Auto-Renewable subscription, and you can use all the unlocked content after the subscription expires."
            
            view.layoutNow()
            
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = -0.15
            animation.toValue = 0.15
            animation.autoreverses = true
            animation.duration = 0.15

            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [animation]
            animationGroup.duration = 2.15
            animationGroup.repeatCount = .greatestFiniteMagnitude
            ana_buttonBackView.layer.add(animationGroup, forKey: nil)
        }
    }
    
    
    func requestFailed() {
        ana_activityView.stopAnimating()
    }
}


extension SubscriptionViewController: NBInAppPurchaseProtocol {
    
    /**获取订阅产品成功*/
    func subscriptionProductsDidReciveSuccess(products: [SKProduct]) {
        ana_product = products.filter({$0.productIdentifier == NBNewStoreManager.shard.monthProductId}).first
        requestSuccess()
    }
    /**获取订阅产品失败*/
    func subscriptionProductsDidReciveFailure() {
        showAlert(content: "The network connection is unavailable. Please try again later.")
        requestFailed()
    }
    
    /**购买成功回调*/
    func purchasedSuccess(_ needUnsubscribe: Bool) {
        showPurchaseSuccessAlert(needUnsubscribe)
    }
    /**购买失败*/
    func purchasedFailure() {
        showAlert(content: "buy failed")
    }
    
    /**恢复购买成功*/
    func restorePurchaseSuccess() {
        showAlert(content: "restore success") {
            [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    /**回复购买失败*/
    func restorePurchaseFailure() {
        showAlert(content: "restore failed")
    }
    
    /**
     * 订阅成功弹窗
     */
    func showPurchaseSuccessAlert(_ needUnsubscribe: Bool = false) {
		EventManager.log(name: "Subscription_success_\(ana_scene)")
		EventManager.log(name: "Subscription_success")
        showAlert(content: "buy success") {
            [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            if let success = self.ana_success {
                success()
            }
        }
    }
    
    
    func showAlert(content: String, handler: ( () -> Void)? = nil) {
        let vc = UIAlertController(title: nil, message: content, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "I know", style: .default, handler: {
            [weak vc] _ in
            guard let vc = vc else { return }
            vc.dismiss(animated: true, completion: nil)
            if handler != nil {
                handler!()
            }
        }))
        self.present(vc, animated: true, completion: nil)
    }
}
