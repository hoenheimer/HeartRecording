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
    var ana_button: UIButton!
    var ana_imageView: UIImageView!
    var ana_label: UILabel!
    var ana_arrowImageView: UIImageView!
    
    var ana_key: String!
    let ana_pipe = Signal<String, Never>.pipe()
    
    
    convenience init(image: UIImage?, title: String?, key: String) {
        self.init()
        configure()
        ana_imageView.image = image
        ana_label.text = title
        self.ana_key = key
    }
    
    
    func configure() {
        backgroundColor = .clear
        
        ana_button = UIButton()
        ana_button.backgroundColor = .clear
        ana_button.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.ana_pipe.input.send(value: self.ana_key)
        }
        addSubview(ana_button)
        
        ana_imageView = UIImageView()
        addSubview(ana_imageView)
        
        ana_label = UILabel()
        ana_label.textColor = .color(hexString: "#14142B")
        ana_label.font = UIFont(name: "Inter-Regular", size: 14)
        addSubview(ana_label)
        
        ana_arrowImageView = UIImageView()
        ana_arrowImageView.image = UIImage(named: "Setting_Arrow")
        addSubview(ana_arrowImageView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ana_button.frame = bounds
        ana_imageView.sizeToFit()
        ana_imageView.center = CGPoint(x: 18 + ana_imageView.halfWidth(), y: halfHeight())
        ana_label.sizeToFit()
        ana_label.center = CGPoint(x: ana_imageView.maxX() + 14 + ana_label.halfWidth(), y: halfHeight())
        ana_arrowImageView.sizeToFit()
        ana_arrowImageView.center = CGPoint(x: width() - 16 - ana_imageView.halfWidth(), y: halfHeight())
    }
}
