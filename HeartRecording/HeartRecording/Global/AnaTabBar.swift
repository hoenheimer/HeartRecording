//
//  AnaTabBar.swift
//  totowallet
//
//  Created by Yuan Ana on 2020/12/29.
//

import Foundation
import UIKit
import ReactiveCocoa


class AnaTabBarCenterButton: UIButton {
}


class AnaTabBar: UITabBar {
    var backView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    func configure() {
        backgroundColor = .color(hexString: "#FFF0F0")
        unselectedItemTintColor = .color(hexString: "#A0A3BD")
        tintColor = .color(hexString: "#FF8E93")
        
        backView = UIView()
        backView.backgroundColor = .color(hexString: "#E6FFFFFF")
        backView.layer.cornerRadius = 20
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.color(hexString: "#80FFFFFF").cgColor
        backView.setShadow(color: .color(hexString: "#28A0A3BD"), offset: CGSize(width: 0, height: 16), radius: 24)
        addSubview(backView)
        sendSubviewToBack(backView)
    }
    
    
	override func layoutSubviews() {
		super.layoutSubviews()
		
        let height = (window?.safeAreaInsets.bottom ?? 0) + 64
        frame = CGRect(x: 0, y: maxY() - height, width: width(), height: height)
        backView.frame = bounds
	}
}
