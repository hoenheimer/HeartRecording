//
//  GuideViewController2.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/4/14.
//

import UIKit

class GuideViewController2: GuideViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EventManager.log(name: "GuideVC_2_Show")
    }
    
    
    override func configure() {
        super.configure()
        
        ana_imageView.image = UIImage(named: "Guide_Image2")
        
        ana_titleLabel.text = "Share your joy"
        
        let pStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        pStyle.alignment = .center
        pStyle.lineSpacing = 16
        ana_contentLabel.attributedText = NSAttributedString(string: "Share the magic sounds with your family",
                                                             attributes: [.font : UIFont(name: "Poppins-Regular", size: 20)!,
                                                                .foregroundColor : UIColor.color(hexString: "#ff725e"),
                                                                .paragraphStyle : pStyle])
        
        ana_pageView1.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        ana_pageView2.backgroundColor = .color(hexString: "#ff4e4e")
        ana_pageView3.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
            EventManager.log(name: "Guidebutton_2_tapped")
            self.navigationController?.pushViewController(GuideViewController3(), animated: true)
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        ana_gradient.frame = view.bounds
        ana_bottomView.frame = CGRect(x: 0, y: view.height() * 0.6, width: view.width(), height: view.height() * 0.4 + 30)
        ana_imageView.sizeToFit()
        if ana_imageView.width() > 0 {
            let scale = view.width() / ana_imageView.width()
            ana_imageView.bounds = CGRect(x: 0, y: 0, width: view.width(), height: ana_imageView.height() * scale)
        }
        ana_imageView.center = CGPoint(x: view.halfWidth(), y: ana_bottomView.minY() - 22 - ana_imageView.halfHeight())
        ana_titleLabel.sizeToFit()
        ana_titleLabel.bounds = CGRect(x: 0, y: 0, width: ana_titleLabel.width(), height: 44)
        ana_titleLabel.center = CGPoint(x: ana_bottomView.halfWidth(), y: 26 + ana_titleLabel.halfHeight())
        let size = ana_contentLabel.sizeThatFits(CGSize(width: ana_bottomView.width() - 20 * 2, height: .greatestFiniteMagnitude))
        ana_contentLabel.bounds = CGRect(origin: .zero, size: size)
        ana_contentLabel.center = CGPoint(x: ana_bottomView.halfWidth(), y: ana_titleLabel.maxY() + 16 + ana_contentLabel.halfHeight())
        ana_button.sizeToFit()
        ana_button.center = CGPoint(x: ana_bottomView.halfWidth(), y: ana_bottomView.height() - 30 - bottomSpacing() - 28 - ana_button.halfHeight())
        ana_pageView2.bounds = CGRect(x: 0, y: 0, width: 4, height: 12)
        ana_pageView2.center = CGPoint(x: ana_bottomView.halfWidth(), y: ana_button.minY() - 20 - ana_pageView2.halfHeight())
        ana_pageView1.bounds = CGRect(x: 0, y: 0, width: 4, height: 4)
        ana_pageView1.center = CGPoint(x: ana_pageView2.minX() - 4 - ana_pageView1.halfWidth(), y: ana_pageView2.centerY())
        ana_pageView3.bounds = CGRect(x: 0, y: 0, width: 4, height: 4)
        ana_pageView3.center = CGPoint(x: ana_pageView2.maxX() + 4 + ana_pageView3.halfWidth(), y: ana_pageView2.centerY())
    }
}
