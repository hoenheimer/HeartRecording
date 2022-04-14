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
    var ana_topProductView:         ProductItemView!
    var ana_bottomProductView:         ProductItemView!
    var ana_buttonBackView:         UIView!
    var ana_buttonShadowView:       UIView!
    var ana_buttonGradientView:     UIView!
    var ana_buttonGradientLayer:    CAGradientLayer!
    var ana_button:                 UIButton!
    var ana_activityView:           UIActivityIndicatorView!
    var ana_buttonBottomLabel:      UILabel!
    var ana_restoreButton:          UIButton!
    var ana_termsButton:            UIButton!
    var ana_privacyButton:          UIButton!
    var ana_bottomLabel:            UILabel!
	
	var ana_scene: SubscriptionScene = .normal
    
    var ana_monthlyProduct: SKProduct?
    var ana_onceProduct: SKProduct?
    var ana_selectBottomProduct = false
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
        ana_titleLabel.text = "Angel  Premium"
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
        ana_featureLabel1.font = UIFont(name: "PingFangSC-Regular", size: 14)
        ana_featuresBackView.addSubview(ana_featureLabel1)
        
        ana_featureLabel2 = UILabel()
        ana_featureLabel2.text = "Share Recording With Others"
        ana_featureLabel2.textColor = .black
        ana_featureLabel2.font = UIFont(name: "PingFangSC-Regular", size: 14)
        ana_featuresBackView.addSubview(ana_featureLabel2)
        
        ana_featureLabel3 = UILabel()
        ana_featureLabel3.text = "Remove Ads"
        ana_featureLabel3.textColor = .black
        ana_featureLabel3.font = UIFont(name: "PingFangSC-Regular", size: 14)
        ana_featuresBackView.addSubview(ana_featureLabel3)
        
        ana_topProductView = ProductItemView()
        ana_topProductView.setSelected(true)
        ana_topProductView.setContent("3 Days Free Trial, Then Only $6.99/Month")
        ana_topProductView.pipe.output.observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.ana_selectBottomProduct = false
            self.ana_topProductView.setSelected(true)
            self.ana_bottomProductView.setSelected(false)
            if let freeDays = self.ana_monthlyProduct?.freeDays {
                if freeDays > 0 {
                    self.ana_button.setTitle("\(freeDays) Days Free Trial", for: .normal)
                } else {
                    self.ana_button.setTitle("Continue", for: .normal)
                }
            } else {
                self.ana_button.setTitle("3 Days Free Trial", for: .normal)
            }
        }
        ana_scrollView.addSubview(ana_topProductView)
        
        ana_bottomProductView = ProductItemView()
        ana_bottomProductView.setSelected(false)
        ana_bottomProductView.setContent("Lifetime Purchase $19.99")
        ana_bottomProductView.pipe.output.observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.ana_selectBottomProduct = true
            self.ana_topProductView.setSelected(false)
            self.ana_bottomProductView.setSelected(true)
            self.ana_button.setTitle("Continue", for: .normal)
        }
        ana_scrollView.addSubview(ana_bottomProductView)
        
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
		ana_button.setTitle("3 Days Free Trial", for: .normal)
        ana_button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
        ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
            var product: SKProduct?
            if self.ana_selectBottomProduct {
                product = self.ana_onceProduct
            } else {
                product = self.ana_monthlyProduct
            }
            if let product = product {
                self.purchase(product: product)
            }
			EventManager.log(name: "Subscription_buttontapped_\(self.ana_scene)")
			EventManager.log(name: "Subscription_buttontapped")
        }
        ana_buttonBackView.addSubview(ana_button)
        
        ana_activityView = UIActivityIndicatorView()
        ana_activityView.color = .color(hexString: "#FCFCFC")
        ana_activityView.startAnimating()
        ana_button.addSubview(ana_activityView)
        
        ana_buttonBottomLabel = UILabel()
        ana_buttonBottomLabel.text = "Auto renewable, Cancel anytime"
        ana_buttonBottomLabel.textColor = .color(hexString: "#979797")
        ana_buttonBottomLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        ana_scrollView.addSubview(ana_buttonBottomLabel)
        
        ana_restoreButton = UIButton()
        ana_restoreButton.setTitle("RESTORE PURCHASE", for: .normal)
        ana_restoreButton.setTitleColor(UIColor.black.withAlphaComponent(0.2), for: .normal)
        ana_restoreButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 10)
        ana_restoreButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.restorePurchaseData()
        }
        ana_scrollView.addSubview(ana_restoreButton)
        
        ana_termsButton = UIButton()
        ana_termsButton.setAttributedTitle(NSAttributedString(string: "Terms of Service",
                                                          attributes: [.font : UIFont(name: "PingFangSC-Regular", size: 10)!,
                                                                       .foregroundColor : UIColor.black.withAlphaComponent(0.2),
                                                                       .underlineStyle : NSUnderlineStyle.single.rawValue,
                                                                       .underlineColor : UIColor.black.withAlphaComponent(0.2).cgColor]),
                                       for: .normal)
        ana_termsButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            let webView = BaseWebController()
            webView.urlStr = "https://sites.google.com/view/angelheart/home"
            webView.modalPresentationStyle = .fullScreen
            self.present(webView, animated: true, completion: nil)
        }
        ana_scrollView.addSubview(ana_termsButton)
        
        ana_privacyButton = UIButton()
        ana_privacyButton.setAttributedTitle(NSAttributedString(string: "Privacy Policy",
                                                          attributes: [.font : UIFont(name: "PingFangSC-Regular", size: 10)!,
                                                                       .foregroundColor : UIColor.black.withAlphaComponent(0.2),
                                                                       .underlineStyle : NSUnderlineStyle.single.rawValue,
                                                                       .underlineColor : UIColor.black.withAlphaComponent(0.2).cgColor]),
                                       for: .normal)
        ana_privacyButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            let webView = BaseWebController()
            webView.urlStr = "https://sites.google.com/view/angelheartbeat/home"
            webView.modalPresentationStyle = .fullScreen
            self.present(webView, animated: true, completion: nil)
        }
        ana_scrollView.addSubview(ana_privacyButton)
        
        ana_bottomLabel = UILabel()
        ana_bottomLabel.numberOfLines = 0
        let pStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        pStyle.lineSpacing = 10
        pStyle.alignment = .justified
        ana_bottomLabel.attributedText = NSAttributedString(string: "Angel Premium offers monthly and lifetime purchase subscription. You can subscribe to a monthly plan($6.99 billed once a month) or lifetime plan($19.99). You can manage or turn off auto-renew in your Apple ID account settings at any time. Subscriptions will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Any unused portion of a free trial period will be forfeited when you purchase a subscription. Our app is functional without purchasing an Auto-Renewable subscription, and you can use all the unlocked content after the subscription expires.",
                                                            attributes: [.font : UIFont(name: "PingFangSC-Semibold", size: 10)!,
                                                                .foregroundColor : UIColor.black.withAlphaComponent(0.2),
                                                                .paragraphStyle : pStyle])
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
        ana_topProductView.frame = CGRect(x: 50, y: ana_featuresBackView.maxY() + 30, width: ana_scrollView.width() - 50 * 2, height: 38)
        ana_bottomProductView.frame = CGRect(x: 50, y: ana_topProductView.maxY() + 8, width: ana_scrollView.width() - 50 * 2, height: 38)
        ana_buttonBackView.frame = CGRect(x: 42, y: ana_bottomProductView.maxY() + 20, width: ana_scrollView.width() - 84, height: 48)
        ana_buttonShadowView.frame = ana_buttonBackView.bounds
        ana_buttonGradientView.frame = ana_buttonShadowView.frame
        ana_buttonGradientLayer.frame = ana_buttonGradientView.bounds
        ana_button.frame = ana_buttonGradientView.frame
        ana_activityView.sizeToFit()
        ana_activityView.center = CGPoint(x: ana_button.halfWidth(), y: ana_button.halfHeight())
        ana_buttonBottomLabel.sizeToFit()
        ana_buttonBottomLabel.bounds = CGRect(x: 0, y: 0, width: ana_buttonBottomLabel.width(), height: 24)
        ana_buttonBottomLabel.center = CGPoint(x: ana_scrollView.halfWidth(),
                                               y: ana_buttonBackView.maxY() + 7 + ana_buttonBottomLabel.halfHeight())
        ana_restoreButton.sizeToFit()
        ana_restoreButton.frame = CGRect(x: 37, y: ana_buttonBottomLabel.maxY() + 20, width: ana_restoreButton.width(), height: 24)
        ana_privacyButton.sizeToFit()
        ana_privacyButton.center = CGPoint(x: ana_scrollView.width() - 38 - ana_privacyButton.halfWidth(), y: ana_restoreButton.centerY())
        ana_termsButton.sizeToFit()
        ana_termsButton.center = CGPoint(x: ana_privacyButton.minX() - 27.5 - ana_termsButton.halfWidth(), y: ana_privacyButton.centerY())
        let size = ana_bottomLabel.sizeThatFits(CGSize(width: ana_scrollView.width() - 74, height: .greatestFiniteMagnitude))
        ana_bottomLabel.frame = CGRect(x: 37, y: ana_restoreButton.maxY() + 3, width: size.width, height: size.height)
        ana_scrollView.contentSize = CGSize(width: ana_scrollView.width(), height: ana_bottomLabel.maxY())
    }
    
    
    func requestSuccess() {
        ana_activityView.stopAnimating()
        if let product = ana_monthlyProduct {
            var string = ""
			if product.freeDays > 0 {
				string.append("\(product.freeDays) Days Free Trial, Then ")
                if !ana_selectBottomProduct {
                    ana_button.setTitle("\(product.freeDays) Days Free Trial", for: .normal)
                }
            } else {
                ana_button.setTitle("Continue", for: .normal)
            }
			string.append("Only \(product.regularPrice)/Month")
            ana_topProductView.setContent(string)
        }
        
        if let product = ana_onceProduct {
            ana_bottomProductView.setContent("Lifetime purchase \(product.regularPrice)")
        }
        
        let pStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        pStyle.lineSpacing = 10
        pStyle.alignment = .justified
        ana_bottomLabel.attributedText = NSAttributedString(string: "Angel Premium offers monthly and lifetime purchase subscription. You can subscribe to a monthly plan(\(ana_monthlyProduct?.regularPrice ?? "$6.99") billed once a month) or lifetime plan(\(ana_onceProduct?.regularPrice ?? "$19.99"). You can manage or turn off auto-renew in your Apple ID account settings at any time. Subscriptions will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Any unused portion of a free trial period will be forfeited when you purchase a subscription. Our app is functional without purchasing an Auto-Renewable subscription, and you can use all the unlocked content after the subscription expires.",
                                                            attributes: [.font : UIFont(name: "PingFangSC-Semibold", size: 10)!,
                                                                .foregroundColor : UIColor.black.withAlphaComponent(0.2),
                                                                .paragraphStyle : pStyle])

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
    
    
    func requestFailed() {
        ana_activityView.stopAnimating()
    }
}


extension SubscriptionViewController: NBInAppPurchaseProtocol {
    
    /**获取订阅产品成功*/
    func subscriptionProductsDidReciveSuccess(products: [SKProduct]) {
        ana_monthlyProduct = products.filter({$0.productIdentifier == NBNewStoreManager.shard.monthProductId}).first
        ana_onceProduct = products.filter({$0.productIdentifier == NBNewStoreManager.shard.onceProductId}).first
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
