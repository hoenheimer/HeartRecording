//
//  RecordViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/15.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class RecordViewController: AnaLargeTitleViewController {
    var animationView: RippleAnimationView!
    var mainView: UIView!
    var heartImageView: UIImageView!
    var label: UILabel!
    var buttonBackgroundView: UIView!
    var buttonGradient: CAGradientLayer!
    var button: UIButton!
    
    let manager = RecordManager()
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "HeartRecording")
        
        animationView = RippleAnimationView(bgColor: .color(hexString: "#FF8282"))
        contentView.addSubview(animationView)
        
        mainView = UIView()
        mainView.layer.cornerRadius = 134
        mainView.backgroundColor = .color(hexString: "#FF8282")
        contentView.addSubview(mainView)
        
        heartImageView = UIImageView()
        heartImageView.backgroundColor = .white
        mainView.addSubview(heartImageView)
        
        label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "When you have found your baby‘s heartbeat, tap the button to record now"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Light", size: 14)
        mainView.addSubview(label)
        
        buttonBackgroundView = UIView()
        buttonBackgroundView.backgroundColor = .clear
        buttonBackgroundView.layer.cornerRadius = 24
        buttonBackgroundView.layer.borderWidth = 1
        buttonBackgroundView.layer.borderColor = UIColor.color(hexString: "#80FCFCFC").cgColor
        contentView.addSubview(buttonBackgroundView)
        
        buttonGradient = CAGradientLayer()
        buttonGradient.colors = [UIColor.color(hexString: "#FF7474").cgColor, UIColor.color(hexString: "#FF4747").cgColor]
        buttonGradient.startPoint = CGPoint(x: 0.5, y: 0)
        buttonGradient.endPoint = CGPoint(x: 0.5, y: 1)
        buttonGradient.cornerRadius = 24
        buttonBackgroundView.layer.addSublayer(buttonGradient)
        
        buttonBackgroundView.setShadow(color: .color(hexString: "#28A0A3BD"), offset: CGSize(width: 0, height: 16), radius: 24)
        
        button = UIButton()
        button.setTitle("Start Recording", for: .normal)
        button.setTitleColor(.color(hexString: "#FCFCFC"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
            if !self.manager.isRecording {
                self.manager.beginRecord()
                if self.manager.isRecording {
                    button.setTitle("Done", for: .normal)
                }
            } else {
                self.manager.stopRecord()
                if !self.manager.isRecording {
                    button.setTitle("Start Recording", for: .normal)
                }
            }
        }
        buttonBackgroundView.addSubview(button)
    }
    
    
    override func layoutContentView() -> CGFloat {
        mainView.bounds = CGRect(origin: .zero, size: CGSize(width: 268, height: 268))
        mainView.center = CGPoint(x: view.halfWidth(), y: 98 + mainView.halfHeight())
        animationView.frame = mainView.frame
        heartImageView.bounds = CGRect(origin: .zero, size: CGSize(width: 43, height: 40))
        heartImageView.center = CGPoint(x: mainView.halfWidth(), y: 65 + heartImageView.halfHeight())
        let size = label.sizeThatFits(CGSize(width: 229, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(origin: .zero, size: size)
        label.center = CGPoint(x: mainView.halfWidth(), y: heartImageView.maxY() + 28 + label.halfHeight())
        buttonBackgroundView.bounds = CGRect(origin: .zero, size: CGSize(width: 175, height: 48))
        buttonBackgroundView.center = CGPoint(x: view.halfWidth(), y: mainView.maxY() + 127 + buttonBackgroundView.halfHeight())
        buttonGradient.frame = buttonBackgroundView.bounds
        button.frame = buttonBackgroundView.bounds
        return buttonBackgroundView.maxY()
    }
}
