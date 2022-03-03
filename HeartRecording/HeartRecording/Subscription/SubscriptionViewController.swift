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


class SubscriptionViewController: UIViewController {
    var ana_gradientLayer:          CAGradientLayer!
	var backHintView:				UIView!
    var ana_scrollView:             UIScrollView!
	var hintView:					UIView!
	var hintShapeLayer: 			CAShapeLayer!
    var ana_closeButton:            UIButton!
	var ana_imageView:              UIImageView!
    var ana_titleLabel:             UILabel!
	var ana_titleImageView:			UIImageView!
    var ana_featuresBackView:       UIView!
    var ana_iconImageView1:         UIImageView!
    var ana_iconImageView2:         UIImageView!
    var ana_iconImageView3:         UIImageView!
    var ana_featureLabel1:          UILabel!
    var ana_featureLabel2:          UILabel!
    var ana_featureLabel3:          UILabel!
	var ana_topProductView:			SubscriptionProductView!
	var ana_bottomProductView:		SubscriptionProductView!
    var ana_button:                 UIButton!
    var ana_buttonBottomLabel:      UILabel!
    var ana_restoreButton:          UIButton!
    var ana_termsButton:            UIButton!
    var ana_privacyButton:          UIButton!
    var ana_bottomLabel:            UILabel!
    
    var ana_monthProduct: SKProduct?
	var ana_sixMonthProduct: SKProduct?
	var selectBottomProduct = false
    var ana_success: (() -> Void)? = nil
	var ana_dismiss: (() -> Void)? = nil
	var fromBase = false
    
    
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
		
		if fromBase {
			UserDefaults.standard.set(true, forKey: "Have_Launch_Once")
			if let navigationController = navigationController {
				var vcs = navigationController.viewControllers.filter {
					vc in
					return !(vc is BaseViewController)
				}
				vcs.insert(KickCounterViewController(), at: 0)
				navigationController.viewControllers = vcs
			}
		}
	}
    
    
    func configure() {
        ana_gradientLayer = CAGradientLayer()
        ana_gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        ana_gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        ana_gradientLayer.colors = [UIColor.color(hexString: "#fff6f8").cgColor, UIColor.color(hexString: "#fff0f2").cgColor]
        view.layer.addSublayer(ana_gradientLayer)
		
		backHintView = UIView()
		backHintView.backgroundColor = .white
		view.addSubview(backHintView)
        
        ana_scrollView = UIScrollView()
        ana_scrollView.backgroundColor = .clear
		ana_scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(ana_scrollView)
        
        ana_closeButton = UIButton()
        ana_closeButton.setImage(UIImage(named: "Subscription_Close"), for: .normal)
        ana_closeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
			if let navigationController = self.navigationController {
				navigationController.popViewController(animated: true)
			} else {
				self.dismiss(animated: true, completion: self.ana_dismiss)
			}
        }
        view.addSubview(ana_closeButton)
		
		hintView = UIView()
		hintView.backgroundColor = .white
		ana_scrollView.addSubview(hintView)
		
		hintShapeLayer = CAShapeLayer()
		hintView.layer.mask = hintShapeLayer
		
		ana_imageView = UIImageView()
		ana_imageView.image = UIImage(named: "Subscription_Image")
		ana_scrollView.addSubview(ana_imageView)
        
        ana_titleLabel = UILabel()
        ana_titleLabel.text = "BabyCare Premium"
        ana_titleLabel.textColor = .color(hexString: "#6a515e")
        ana_titleLabel.font = UIFont(name: "Merriweather-Regular", size: 28)
        ana_scrollView.addSubview(ana_titleLabel)
		
		ana_titleImageView = UIImageView(image: UIImage(named: "Subscription_Title"))
		ana_scrollView.addSubview(ana_titleImageView)
        
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
		
		ana_topProductView = SubscriptionProductView()
		ana_topProductView.set(price: "$6.99", freeDays: 3, durationString: "month")
		ana_topProductView.setSelected(true)
		ana_topProductView.pipe.output.observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.selectBottomProduct = false
			self.ana_topProductView.setSelected(true)
			self.ana_bottomProductView.setSelected(false)
		}
		ana_scrollView.addSubview(ana_topProductView)
		
		ana_bottomProductView = SubscriptionProductView()
		ana_bottomProductView.set(price: "$39.99", freeDays: 3, durationString: "Half year")
		ana_bottomProductView.setSelected(false)
		ana_bottomProductView.pipe.output.observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.selectBottomProduct = true
			self.ana_topProductView.setSelected(false)
			self.ana_bottomProductView.setSelected(true)
		}
		ana_scrollView.addSubview(ana_bottomProductView)
        
        ana_button = UIButton()
		ana_button.layer.cornerRadius = 27
		ana_button.layer.borderWidth = 1
		ana_button.layer.borderColor = UIColor.color(hexString: "#80fcfcfc").cgColor
        ana_button.backgroundColor = .color(hexString: "#e46a7d")
		ana_button.setShadow(color: .color(hexString: "#4cde7d94"), offset: CGSize(width: 0, height: 12), radius: 30, opacity: 1)
		ana_button.setTitle("Start Free Trial", for: .normal)
        ana_button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
        ana_button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
			if let product = self.selectBottomProduct ? self.ana_sixMonthProduct : self.ana_monthProduct {
				self.purchase(product: product)
			}
        }
        ana_scrollView.addSubview(ana_button)
		
		ana_buttonBottomLabel = UILabel()
		ana_buttonBottomLabel.text = "Auto renewable, Cancel anytime"
		ana_buttonBottomLabel.textColor = .color(hexString: "#6a515e")
		ana_buttonBottomLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
		ana_scrollView.addSubview(ana_buttonBottomLabel)
        
        ana_restoreButton = UIButton()
        ana_restoreButton.setTitle("RESTORE PURCHASE", for: .normal)
        ana_restoreButton.setTitleColor(.color(hexString: "#6a515e"), for: .normal)
        ana_restoreButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 10)
        ana_restoreButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.restorePurchaseData()
        }
        ana_scrollView.addSubview(ana_restoreButton)
        
        ana_termsButton = UIButton()
		ana_termsButton.setTitle("Terms of Service", for: .normal)
		ana_termsButton.setTitleColor(.color(hexString: "#6a515e"), for: .normal)
		ana_termsButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 10)
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
		ana_privacyButton.setTitle("Privacy Policy", for: .normal)
		ana_privacyButton.setTitleColor(.color(hexString: "#6a515e"), for: .normal)
		ana_privacyButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 10)
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
		ana_bottomLabel.textAlignment = .justified
        ana_bottomLabel.text = "BabyCare Premium offers monthly and half-yearly purchase subscription. You can subscribe to a monthly plan($6.99 per month) or a half-yearly plan($39.99 per half-year). You can manage or turn off auto-renew in your Apple ID account settings at any time. Subscriptions will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Any unused portion of a free trial period will be forfeited when you purchase a subscription. Our app is functional without purchasing an Auto-Renewable subscription, and you can use all the unlocked content after the subscription expires."
        ana_bottomLabel.textColor = .color(hexString: "#6a515e")
        ana_bottomLabel.font  = UIFont(name: "PingFangSC-Semibold", size: 10)
        ana_scrollView.addSubview(ana_bottomLabel)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        ana_gradientLayer.frame = view.bounds
        ana_scrollView.frame = view.bounds
        ana_closeButton.sizeToFit()
        ana_closeButton.setOrigin(x: 20, y: topSpacing() + 30)
		ana_imageView.sizeToFit()
		ana_imageView.center = CGPoint(x: view.halfWidth(), y: topSpacing() + 8 + ana_imageView.halfHeight())
        ana_titleLabel.sizeToFit()
		ana_titleLabel.center = CGPoint(x: ana_scrollView.halfWidth(), y: topSpacing() + 96 + ana_titleLabel.halfHeight())
		ana_titleImageView.sizeToFit()
		ana_titleImageView.center = CGPoint(x: ana_titleLabel.maxX() + 12 + ana_titleImageView.halfWidth(), y: ana_titleLabel.centerY())
        ana_iconImageView1.sizeToFit()
        ana_iconImageView1.setOrigin(x: 0, y: 0)
        ana_iconImageView2.sizeToFit()
        ana_iconImageView2.setOrigin(x: 0, y: ana_iconImageView1.maxY() + 21)
        ana_iconImageView3.sizeToFit()
        ana_iconImageView3.setOrigin(x: 0, y: ana_iconImageView2.maxY() + 21)
        ana_featureLabel1.sizeToFit()
        ana_featureLabel1.center = CGPoint(x: ana_iconImageView1.maxX() + 9 + ana_featureLabel1.halfWidth(), y: ana_iconImageView1.centerY())
        ana_featureLabel2.sizeToFit()
        ana_featureLabel2.center = CGPoint(x: ana_iconImageView2.maxX() + 9 + ana_featureLabel2.halfWidth(), y: ana_iconImageView2.centerY())
        ana_featureLabel3.sizeToFit()
        ana_featureLabel3.center = CGPoint(x: ana_iconImageView3.maxX() + 9 + ana_featureLabel3.halfWidth(), y: ana_iconImageView3.centerY())
        ana_featuresBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(ana_featureLabel1.maxX(), ana_featureLabel2.maxX(), ana_featureLabel3.maxX()),
                                                                     height: ana_iconImageView3.maxY()))
		ana_featuresBackView.center = CGPoint(x: ana_scrollView.halfWidth(), y: ana_imageView.maxY() + 13.4 + ana_featuresBackView.halfHeight())
		ana_topProductView.frame = CGRect(x: 25, y: ana_featuresBackView.maxY() + 35, width: ana_scrollView.width() - 25 * 2, height: 44)
		ana_bottomProductView.frame = CGRect(x: 25, y: ana_topProductView.maxY() + 16, width: ana_scrollView.width() - 25 * 2, height: 44)
        ana_button.frame = CGRect(x: 25, y: ana_bottomProductView.maxY() + 24, width: ana_scrollView.width() - 25 * 2, height: 54)
		ana_buttonBottomLabel.sizeToFit()
		ana_buttonBottomLabel.center = CGPoint(x: ana_scrollView.halfWidth(), y: ana_button.maxY() + 12 + ana_buttonBottomLabel.halfHeight())
        ana_restoreButton.sizeToFit()
        ana_restoreButton.setOrigin(x: 38, y: ana_buttonBottomLabel.maxY() + 22)
        ana_privacyButton.sizeToFit()
        ana_privacyButton.center = CGPoint(x: ana_scrollView.width() - 38 - ana_privacyButton.halfWidth(), y: ana_restoreButton.centerY())
        ana_termsButton.sizeToFit()
		ana_termsButton.center = CGPoint(x: (ana_restoreButton.maxX() + ana_privacyButton.minX()) / 2, y: ana_privacyButton.centerY())
        let size = ana_bottomLabel.sizeThatFits(CGSize(width: ana_scrollView.width() - 76, height: .greatestFiniteMagnitude))
        ana_bottomLabel.frame = CGRect(x: 38, y: ana_restoreButton.maxY() + 3, width: size.width, height: size.height)
        ana_scrollView.contentSize = CGSize(width: ana_scrollView.width(), height: ana_bottomLabel.maxY() + bottomSpacing())
		hintView.frame = CGRect(origin: .zero, size: ana_scrollView.contentSize)
		hintShapeLayer.frame = hintView.bounds
		hintShapeLayer.path = maskLayerPath()
		backHintView.frame = CGRect(x: 0, y: 0, width: view.width(), height: view.height() / 3)
    }
	
	
	func maskLayerPath() -> CGPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: 0, y: ana_button.centerY()))
		path.addArc(withCenter: CGPoint(x: 80, y: ana_button.centerY()),
					radius: 80,
					startAngle: -1 * CGFloat.pi,
					endAngle: -0.5 * CGFloat.pi,
					clockwise: true)
		path.addLine(to: CGPoint(x: view.width() - 80, y: ana_button.centerY() - 80))
		path.addArc(withCenter: CGPoint(x: view.width() - 80, y: ana_button.centerY() - 160),
					radius: 80,
					startAngle: 0.5 * CGFloat.pi,
					endAngle: 0,
					clockwise: false)
		path.addLine(to: CGPoint(x: view.width(), y: 0))
		path.close()
		return path.cgPath
	}
    
    
    func requestSuccess() {
		if let ana_monthProduct = ana_monthProduct {
			ana_topProductView.set(price: ana_monthProduct.regularPrice, freeDays: ana_monthProduct.freeDays, durationString: "month")
		}
		if let ana_sixMonthProduct = ana_sixMonthProduct {
			ana_bottomProductView.set(price: ana_sixMonthProduct.regularPrice, freeDays: ana_sixMonthProduct.freeDays, durationString: "Half year")
		}
		ana_bottomLabel.text = "BabyCare Premium offers monthly and half-yearly purchase subscription. You can subscribe to a monthly plan(\(ana_monthProduct?.regularPrice ?? "$6.99") per month) or a half-yearly plan(\(ana_sixMonthProduct?.regularPrice ?? "39.99") per half-year). You can manage or turn off auto-renew in your Apple ID account settings at any time. Subscriptions will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Any unused portion of a free trial period will be forfeited when you purchase a subscription. Our app is functional without purchasing an Auto-Renewable subscription, and you can use all the unlocked content after the subscription expires."
		view.layoutNow()
    }
    
    
    func requestFailed() {
    }
}


extension SubscriptionViewController: NBInAppPurchaseProtocol {
    
    /**获取订阅产品成功*/
    func subscriptionProductsDidReciveSuccess(products: [SKProduct]) {
        ana_monthProduct = products.filter({$0.productIdentifier == NBNewStoreManager.shard.monthProductId}).first
		ana_sixMonthProduct = products.filter({$0.productIdentifier == NBNewStoreManager.shard.sixMonthProductId}).first
        requestSuccess()
    }
    /**获取订阅产品失败*/
    func subscriptionProductsDidReciveFailure() {
//        showAlert(content: "The network connection is unavailable. Please try again later.")
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
			if let navigationController = self.navigationController {
				navigationController.popViewController(animated: true)
			} else {
				self.dismiss(animated: true, completion: self.ana_dismiss)
			}
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
        showAlert(content: "buy success") {
            [weak self] in
            guard let self = self else { return }
			if let navigationController = self.navigationController {
				navigationController.popViewController(animated: true)
			} else {
				self.dismiss(animated: true, completion: self.ana_dismiss)
			}
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
