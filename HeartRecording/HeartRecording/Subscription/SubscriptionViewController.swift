//
//  SubscriptionViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/20.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class SubscriptionViewController: UIViewController {
    var gradientLayer:          CAGradientLayer!
    var scrollView:             UIScrollView!
    var closeButton:            UIButton!
    var titleLabel:             UILabel!
    var imageView:              UIImageView!
    var featuresBackView:       UIView!
    var iconImageView1:         UIImageView!
    var iconImageView2:         UIImageView!
    var iconImageView3:         UIImageView!
    var featureLabel1:          UILabel!
    var featureLabel2:          UILabel!
    var featureLabel3:          UILabel!
    var buttonShadowView:       UIView!
    var buttonGradientView:     UIView!
    var buttonGradientLayer:    CAGradientLayer!
    var button:                 UIButton!
    var buttonBottomLabel:      UILabel!
    var restoreButton:          UIButton!
    var termsButton:            UIButton!
    var privacyButton:          UIButton!
    var bottomLabel:            UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
        view.layer.addSublayer(gradientLayer)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "Detail_Close"), for: .normal)
        closeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        view.addSubview(closeButton)
        
        titleLabel = UILabel()
        titleLabel.text = "Angle  Premium"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 26)
        scrollView.addSubview(titleLabel)
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "Subscription_Image")
        scrollView.addSubview(imageView)
        
        featuresBackView = UIView()
        featuresBackView.backgroundColor = .clear
        scrollView.addSubview(featuresBackView)
        
        iconImageView1 = UIImageView()
        iconImageView1.image = UIImage(named: "Subscription_Feature")
        featuresBackView.addSubview(iconImageView1)
        
        iconImageView2 = UIImageView()
        iconImageView2.image = UIImage(named: "Subscription_Feature")
        featuresBackView.addSubview(iconImageView2)
        
        iconImageView3 = UIImageView()
        iconImageView3.image = UIImage(named: "Subscription_Feature")
        featuresBackView.addSubview(iconImageView3)
        
        featureLabel1 = UILabel()
        featureLabel1.text = "Unlock All Features"
        featureLabel1.textColor = .black
        featureLabel1.font = .systemFont(ofSize: 14)
        featuresBackView.addSubview(featureLabel1)
        
        featureLabel2 = UILabel()
        featureLabel2.text = "Share Recording With Others"
        featureLabel2.textColor = .black
        featureLabel2.font = .systemFont(ofSize: 14)
        featuresBackView.addSubview(featureLabel2)
        
        featureLabel3 = UILabel()
        featureLabel3.text = "Remove Ads"
        featureLabel3.textColor = .black
        featureLabel3.font = .systemFont(ofSize: 14)
        featuresBackView.addSubview(featureLabel3)
        
        buttonGradientView = UIView()
        buttonGradientView.backgroundColor = .clear
        scrollView.addSubview(buttonGradientView)
        
        buttonShadowView = UIView()
        buttonShadowView.layer.cornerRadius = 24
        buttonShadowView.layer.borderWidth = 1
        buttonShadowView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
        buttonShadowView.backgroundColor = .color(hexString: "#FF5E5E")
        buttonShadowView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24)
        scrollView.addSubview(buttonShadowView)
        
        buttonGradientLayer = CAGradientLayer()
        buttonGradientLayer.cornerRadius = 24
        buttonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        buttonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        buttonGradientLayer.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF474747").cgColor]
        buttonGradientView.layer.addSublayer(buttonGradientLayer)
        
        button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("3 Days Free Trial,then $19.99/Year", for: .normal)
        button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        scrollView.addSubview(button)
        
        buttonBottomLabel = UILabel()
        buttonBottomLabel.text = "Auto renewable, Cancel anytime"
        buttonBottomLabel.textColor = .color(hexString: "#979797")
        buttonBottomLabel.font = .systemFont(ofSize: 13)
        scrollView.addSubview(buttonBottomLabel)
        
        restoreButton = UIButton()
        restoreButton.setTitle("RESTORE PURCHASE", for: .normal)
        restoreButton.setTitleColor(.color(hexString: "#979797"), for: .normal)
        restoreButton.titleLabel?.font = .systemFont(ofSize: 10, weight: .semibold)
        scrollView.addSubview(restoreButton)
        
        termsButton = UIButton()
        termsButton.setAttributedTitle(NSAttributedString(string: "Terms of Service",
                                                          attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                                                                       NSAttributedString.Key.foregroundColor : UIColor.color(hexString: "#979797"),
                                                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                                                       NSAttributedString.Key.underlineColor : UIColor.color(hexString: "#979797").cgColor]),
                                       for: .normal)
        scrollView.addSubview(termsButton)
        
        privacyButton = UIButton()
        privacyButton.setAttributedTitle(NSAttributedString(string: "Privacy Policy",
                                                          attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                                                                       NSAttributedString.Key.foregroundColor : UIColor.color(hexString: "#979797"),
                                                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                                                       NSAttributedString.Key.underlineColor : UIColor.color(hexString: "#979797").cgColor]),
                                       for: .normal)
        scrollView.addSubview(privacyButton)
        
        bottomLabel = UILabel()
        bottomLabel.numberOfLines = 0
        bottomLabel.text = "HighlightCovers Premium offers weekly purchase subscription. You can subscribe to a weekly plan ($3.99 billed once a week ). You can manage or turn off auto-renew in your Apple ID account settings at any time. Subscriptions will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Any unused portion of a free trial period will be forfeited when you purchase a subscription. Our app is functional without purchasing an Auto-Renewable subscription, and you can use all the unlocked content after the subscription expires."
        bottomLabel.textColor = .color(hexString: "#979797")
        bottomLabel.font  = .systemFont(ofSize: 10, weight: .semibold)
        scrollView.addSubview(bottomLabel)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        scrollView.frame = view.bounds
        closeButton.sizeToFit()
        closeButton.setOrigin(x: 20, y: 74)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: scrollView.halfWidth(), y: 136 + titleLabel.halfHeight())
        imageView.sizeToFit()
        imageView.center = CGPoint(x: scrollView.halfWidth(), y: titleLabel.maxY() + 22 + imageView.halfHeight())
        iconImageView1.sizeToFit()
        iconImageView1.setOrigin(x: 0, y: 0)
        iconImageView2.sizeToFit()
        iconImageView2.setOrigin(x: 0, y: iconImageView1.maxY() + 22)
        iconImageView3.sizeToFit()
        iconImageView3.setOrigin(x: 0, y: iconImageView2.maxY() + 22)
        featureLabel1.sizeToFit()
        featureLabel1.center = CGPoint(x: iconImageView1.maxX() + 23 + featureLabel1.halfWidth(), y: iconImageView1.centerY())
        featureLabel2.sizeToFit()
        featureLabel2.center = CGPoint(x: iconImageView2.maxX() + 23 + featureLabel2.halfWidth(), y: iconImageView2.centerY())
        featureLabel3.sizeToFit()
        featureLabel3.center = CGPoint(x: iconImageView3.maxX() + 23 + featureLabel3.halfWidth(), y: iconImageView3.centerY())
        featuresBackView.bounds = CGRect(origin: .zero, size: CGSize(width: max(featureLabel1.maxX(), featureLabel2.maxX(), featureLabel3.maxX()),
                                                                     height: iconImageView3.maxY()))
        featuresBackView.center = CGPoint(x: scrollView.halfWidth(), y: imageView.maxY() + 15 + featuresBackView.halfHeight())
        buttonShadowView.frame = CGRect(x: 42, y: featuresBackView.maxY() + 72, width: scrollView.width() - 84, height: 48)
        buttonGradientView.frame = buttonShadowView.frame
        buttonGradientLayer.frame = buttonGradientView.bounds
        button.frame = buttonGradientView.frame
        buttonBottomLabel.sizeToFit()
        buttonBottomLabel.center = CGPoint(x: scrollView.halfWidth(), y: button.maxY() + 7 + buttonBottomLabel.halfHeight())
        restoreButton.sizeToFit()
        restoreButton.setOrigin(x: 42, y: buttonBottomLabel.maxY() + 29)
        privacyButton.sizeToFit()
        privacyButton.center = CGPoint(x: scrollView.width() - 42 - privacyButton.halfWidth(), y: restoreButton.centerY())
        termsButton.sizeToFit()
        termsButton.center = CGPoint(x: privacyButton.minX() - 27 - termsButton.halfWidth(), y: privacyButton.centerY())
        let size = bottomLabel.sizeThatFits(CGSize(width: scrollView.width() - 84, height: .greatestFiniteMagnitude))
        bottomLabel.frame = CGRect(x: 42, y: restoreButton.maxY() + 3, width: size.width, height: size.height)
        scrollView.contentSize = CGSize(width: scrollView.width(), height: bottomLabel.maxY())
    }
}
