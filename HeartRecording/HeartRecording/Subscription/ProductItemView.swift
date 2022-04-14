//
//  ProductItemView.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/4/14.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class ProductItemView: UIView {
    var checkImageView: UIImageView!
    var priceLabel: UILabel!
    
    let pipe = Signal<Int, Never>.pipe()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    func configure() {
        layer.cornerRadius = 8
        backgroundColor = .white
        
        let tap = UITapGestureRecognizer()
        tap.reactive.stateChanged.observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.pipe.input.send(value: 1)
        }
        addGestureRecognizer(tap)
        
        checkImageView = UIImageView()
        addSubview(checkImageView)
        
        priceLabel = UILabel()
        priceLabel.font = UIFont(name: "Poppins-Regular", size: 13)
        addSubview(priceLabel)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        checkImageView.sizeToFit()
        checkImageView.center = CGPoint(x: 12 + checkImageView.halfWidth(), y: halfHeight())
        priceLabel.sizeToFit()
        priceLabel.center = CGPoint(x: checkImageView.maxX() + 6 + priceLabel.halfWidth(), y: halfHeight())
    }
    
    
    func setSelected(_ selected: Bool) {
        checkImageView.image = UIImage(named: "Product_" + (selected ? "Selected" : "Unselected"))
        priceLabel.textColor = selected ? .color(hexString: "#eb5757") : UIColor.black.withAlphaComponent(0.2)
    }
    
    
    func setContent(_ content: String?) {
        priceLabel.text = content
        layoutNow()
    }
}
