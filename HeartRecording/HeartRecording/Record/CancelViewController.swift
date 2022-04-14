//
//  CancelViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/4/14.
//

import UIKit

class CancelViewController: UIViewController {
    var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    var backButton: UIButton!
    var scrollView: UIScrollView!
    var titleLabel: UILabel!
    var label1: UILabel!
    var label2: UILabel!
    var label3: UILabel!
    var imageView: UIImageView!
    var label4: UILabel!
    var label5: UILabel!
    var buttonShadowView: UIView!
    var buttonGradientView: UIView!
    var buttonGradientLayer: CAGradientLayer!
    var button: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        gradientView = UIView()
        view.addSubview(gradientView)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.color(hexString: "#fbfcff").cgColor, UIColor.color(hexString: "#fff0f0").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.addSublayer(gradientLayer)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "Kick_Close"), for: .normal)
        backButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(backButton)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = "How to cancel a subscription on your iPhone touch"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 20)
        scrollView.addSubview(titleLabel)
        
        func newLabel(text: String?) -> UILabel {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = text
            label.textColor = .black
            label.font = UIFont(name: "Poppins-Regular", size: 15)
            scrollView.addSubview(label)
            return label
        }
        
        label1 = newLabel(text: "1.Open the Settings app.")
        label2 = newLabel(text: "2.Tap your name.")
        label3 = newLabel(text: "3.Tap Subscriptions.")
        
        imageView = UIImageView(image: UIImage(named: "Cancel_Image"))
        scrollView.addSubview(imageView)
        
        label4 = newLabel(text: "4.Tap the subscription that you want to manage.")
        label5 = newLabel(text: "5.Tap Cancel Subscription. (Or if you want to cancel Apple One but keep some subscriptions, tap Choose Individual Services.) If you don’t see Cancel, the subscription is already canceled and won't renew.")
        
        buttonShadowView = UIView()
        buttonShadowView.layer.cornerRadius = 24
        buttonShadowView.backgroundColor = .color(hexString: "#FF5E5E")
        buttonShadowView.setShadow(color: .color(hexString: "#28a0a3bd"), offset: CGSize(width: 0, height: 16), radius: 24, opacity: 1)
        scrollView.addSubview(buttonShadowView)
        
        buttonGradientView = UIView()
        scrollView.addSubview(buttonGradientView)
        
        buttonGradientLayer = CAGradientLayer()
        buttonGradientLayer.cornerRadius = 24
        buttonGradientLayer.colors = [UIColor.color(hexString: "#ff4747").cgColor, UIColor.color(hexString: "#ff7474").cgColor]
        buttonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        buttonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        buttonGradientView.layer.addSublayer(buttonGradientLayer)
        
        button = UIButton()
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.color(hexString: "#80fcfcfc").cgColor
        button.setTitle("Cancel Premium", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        button.reactive.controlEvents(.touchUpInside).observeValues {
            _ in
            if let url = URL(string: "App-Prefs:root=") {
                UIApplication.shared.open(url)
            }
        }
        scrollView.addSubview(button)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientView.frame = view.bounds
        gradientLayer.frame = gradientView.bounds
        backButton.sizeToFit()
        backButton.setOrigin(x: 20, y: topSpacing() + 27)
        scrollView.frame = CGRect(x: 0, y: backButton.maxY(), width: view.width(), height: view.height() - backButton.maxY())
        func labelSizeToFit(_ label: UILabel) {
            let size = label.sizeThatFits(CGSize(width: view.width() - 20 * 2, height: .greatestFiniteMagnitude))
            label.bounds = CGRect(origin: .zero, size: size)
        }
        labelSizeToFit(titleLabel)
        titleLabel.setOrigin(x: 20, y: 24)
        labelSizeToFit(label1)
        label1.setOrigin(x: 20, y: titleLabel.maxY() + 10)
        labelSizeToFit(label2)
        label2.setOrigin(x: 20, y: label1.maxY() + 12)
        labelSizeToFit(label3)
        label3.setOrigin(x: 20, y: label2.maxY() + 12)
        imageView.sizeToFit()
        imageView.center = CGPoint(x: scrollView.halfWidth(), y: label3.maxY() + 30 + imageView.halfHeight())
        labelSizeToFit(label4)
        label4.setOrigin(x: 20, y: imageView.maxY() + 29)
        labelSizeToFit(label5)
        label5.setOrigin(x: 20, y: label4.maxY() + 12)
        buttonShadowView.bounds = CGRect(x: 0, y: 0, width: 185, height: 48)
        buttonShadowView.center = CGPoint(x: scrollView.halfWidth(), y: label5.maxY() + 35 + buttonShadowView.halfHeight())
        buttonGradientView.frame = buttonShadowView.frame
        buttonGradientLayer.frame = buttonGradientView.bounds
        button.frame = buttonShadowView.frame
        scrollView.contentSize = CGSize(width: scrollView.width(), height: buttonShadowView.maxY() + 20 + bottomSpacing())
    }
}
