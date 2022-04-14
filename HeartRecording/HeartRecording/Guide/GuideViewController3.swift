//
//  GuideViewController3.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/4/14.
//

import UIKit
import StoreKit
import ReactiveCocoa
import ReactiveSwift


class GuideViewController3: GuideViewController {
    var starImageViews = [UIImageView]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EventManager.log(name: "GuideVC_3_Show")
        let pipe = Signal<Int, Never>.pipe()
        let startAnimation: (Int) -> Void = {
            index in
            UIView.animate(withDuration: 0.3) {
                self.starImageViews[index].alpha = 1
            } completion: {
                completed in
                if completed && index < 4 {
                    pipe.input.send(value: index + 1)
                }
            }
        }
        pipe.output.observeValues {
            index in
            startAnimation(index)
        }
        startAnimation(0)
        
        DispatchQueue.main.async {
            if #available(iOS 14.0, *) {
                if let windowScene = self.view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    
    override func configure() {
        super.configure()
        
        ana_imageView.image = UIImage(named: "Guide_Image3")
        
        for _ in 0 ..< 5 {
            let imageView = UIImageView(image: UIImage(named: "Guide_Star"))
            imageView.alpha = 0
            imageView.layer.zPosition = 2
            view.addSubview(imageView)
            starImageViews.append(imageView)
        }
        
        ana_titleLabel.text = "Rate Us"
        
        ana_contentLabel.text = "If you like our app, please rate us on the App Store. This is a great support for our team. Thank you!"
        
        ana_pageView1.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        ana_pageView2.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        ana_pageView3.backgroundColor = .color(hexString: "#ff4e4e")
        
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
            EventManager.log(name: "Guidebutton_3_tapped")
            self.navigationController?.pushViewController(RecordViewController(), animated: true)
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        ana_gradient.frame = view.bounds
        ana_bottomView.frame = CGRect(x: 0, y: view.height() * 0.6, width: view.width(), height: view.height() * 0.4 + 30)
        ana_imageView.sizeToFit()
        ana_imageView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.28)
        for i in starImageViews.indices {
            let imageView = starImageViews[i]
            imageView.sizeToFit()
            imageView.center = CGPoint(x: view.halfWidth() - 72 + 36 * CGFloat(i), y: view.height() * 0.53)
        }
        ana_titleLabel.sizeToFit()
        ana_titleLabel.bounds = CGRect(x: 0, y: 0, width: ana_titleLabel.width(), height: 44)
        ana_titleLabel.center = CGPoint(x: ana_bottomView.halfWidth(), y: 22 + ana_titleLabel.halfHeight())
        let size = ana_contentLabel.sizeThatFits(CGSize(width: ana_bottomView.width() - 20 * 2, height: .greatestFiniteMagnitude))
        ana_contentLabel.bounds = CGRect(origin: .zero, size: size)
        ana_contentLabel.center = CGPoint(x: ana_bottomView.halfWidth(), y: ana_titleLabel.maxY() + 20 + ana_contentLabel.halfHeight())
        ana_button.sizeToFit()
        ana_button.center = CGPoint(x: ana_bottomView.halfWidth(), y: ana_bottomView.height() - 30 - bottomSpacing() - 28 - ana_button.halfHeight())
        ana_pageView2.bounds = CGRect(x: 0, y: 0, width: 4, height: 4)
        ana_pageView2.center = CGPoint(x: ana_bottomView.halfWidth(), y: ana_button.minY() - 24 - ana_pageView2.halfHeight())
        ana_pageView1.bounds = CGRect(x: 0, y: 0, width: 4, height: 4)
        ana_pageView1.center = CGPoint(x: ana_pageView2.minX() - 4 - ana_pageView1.halfWidth(), y: ana_pageView2.centerY())
        ana_pageView3.bounds = CGRect(x: 0, y: 0, width: 4, height: 12)
        ana_pageView3.center = CGPoint(x: ana_pageView2.maxX() + 4 + ana_pageView3.halfWidth(), y: ana_pageView2.centerY())
    }
}
