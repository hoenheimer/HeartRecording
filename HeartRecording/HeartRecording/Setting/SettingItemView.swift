//
//  SettingItemView.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class SettingItemView: UIView {
    var button: UIButton!
    var imageView: UIImageView!
    var label: UILabel!
    var arrowImageView: UIImageView!
    
    var key: String!
    let pipe = Signal<String, Never>.pipe()
    
    
    convenience init(image: UIImage?, title: String?, key: String) {
        self.init()
        configure()
        imageView.image = image
        label.text = title
        self.key = key
    }
    
    
    func configure() {
        backgroundColor = .clear
        
        button = UIButton()
        button.backgroundColor = .clear
        button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.pipe.input.send(value: self.key)
        }
        addSubview(button)
        
        imageView = UIImageView()
        addSubview(imageView)
        
        label = UILabel()
        label.textColor = .color(hexString: "#14142B")
        label.font = UIFont(name: "Inter-Regular", size: 14)
        addSubview(label)
        
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "Setting_Arrow")
        addSubview(arrowImageView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
        imageView.sizeToFit()
        imageView.center = CGPoint(x: 18 + imageView.halfWidth(), y: halfHeight())
        label.sizeToFit()
        label.center = CGPoint(x: imageView.maxX() + 14 + label.halfWidth(), y: halfHeight())
        arrowImageView.sizeToFit()
        arrowImageView.center = CGPoint(x: width() - 16 - imageView.halfWidth(), y: halfHeight())
    }
}
