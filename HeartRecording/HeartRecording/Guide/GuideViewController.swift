//
//  GuideViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/6/1.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class GuideViewController: UIViewController {
	var ana_gradient: 		CAGradientLayer!
    var ana_imageView:      UIImageView!
    var ana_bottomView:     UIView!
	var ana_titleLabel: 	UILabel!
	var ana_contentLabel:   UILabel!
    var ana_pageView1:      UIView!
    var ana_pageView2:      UIView!
    var ana_pageView3:      UIView!
	var ana_button:         UIButton!
	
	
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
		ana_gradient = CAGradientLayer()
		ana_gradient.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
		ana_gradient.startPoint = CGPoint(x: 0.5, y: 0)
		ana_gradient.endPoint = CGPoint(x: 0.5, y: 1)
		view.layer.addSublayer(ana_gradient)
        
        ana_imageView = UIImageView()
        ana_imageView.layer.zPosition = 2
        view.addSubview(ana_imageView)
        
        ana_bottomView = UIView()
        ana_bottomView.layer.cornerRadius = 30
        ana_bottomView.backgroundColor = .white
        ana_bottomView.layer.zPosition = 2
        view.addSubview(ana_bottomView)
		
		ana_titleLabel = UILabel()
		ana_titleLabel.textColor = .color(hexString: "#263238")
		ana_titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 26)
        ana_bottomView.addSubview(ana_titleLabel)
		
		ana_contentLabel = UILabel()
		ana_contentLabel.numberOfLines = 0
        ana_contentLabel.textAlignment = .center
        ana_contentLabel.textColor = .color(hexString: "#ff725e")
        ana_contentLabel.font = UIFont(name: "Poppins-Regular", size: 20)
        ana_bottomView.addSubview(ana_contentLabel)
        
        ana_pageView1 = UIView()
        ana_pageView1.layer.cornerRadius = 2
        ana_bottomView.addSubview(ana_pageView1)
        
        ana_pageView2 = UIView()
        ana_pageView2.layer.cornerRadius = 2
        ana_bottomView.addSubview(ana_pageView2)
        
        ana_pageView3 = UIView()
        ana_pageView3.layer.cornerRadius = 2
        ana_bottomView.addSubview(ana_pageView3)
		
		ana_button = UIButton()
        ana_button.setImage(UIImage(named: "Guide_Button"), for: .normal)
		ana_bottomView.addSubview(ana_button)
	}
}
