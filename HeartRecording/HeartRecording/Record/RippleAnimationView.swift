//
//  RippleAnimationView.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/15.
//

import UIKit


class RippleAnimationView: UIView {
    let multiple: CGFloat = 1.18
    var pulsingCount = 3
    var animationDuration: Double = 3
    var bgColor: UIColor!
    
    
    convenience init(bgColor: UIColor) {
        self.init()
        self.bgColor = bgColor
        backgroundColor = .clear
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let animationLayer = CALayer()
        
        for i in 0 ..< pulsingCount {
            let array = animationArray()
            let animationGroup = self.animationGroup(animations: array, index: i)
            let pulsingLayer = self.pulsingLayer(rect, animationGroup: animationGroup)
            animationLayer.addSublayer(pulsingLayer)
        }
        layer.addSublayer(animationLayer)
    }
    
    
    func animationArray() -> [CAAnimation] {
        return [scaleAnimation(), backgroundColorAnimation(), borderColorAnimation()]
    }
    
    
    func animationGroup(animations: [CAAnimation], index: Int) -> CAAnimationGroup {
        let defaultCurve = CAMediaTimingFunction(name: .default)
        let animationGroup = CAAnimationGroup()
        
        animationGroup.fillMode = .backwards
        animationGroup.beginTime = CACurrentMediaTime() + Double(index) * animationDuration / Double(pulsingCount)
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = Float.greatestFiniteMagnitude
        animationGroup.timingFunction = defaultCurve
        animationGroup.animations = animations
        animationGroup.isRemovedOnCompletion = false
        return animationGroup
    }
    
    
    func pulsingLayer(_ rect: CGRect, animationGroup: CAAnimationGroup) -> CALayer {
        let pulsingLayer = CALayer()
        pulsingLayer.frame = CGRect(origin: .zero, size: rect.size)
        pulsingLayer.backgroundColor = bgColor.cgColor
        pulsingLayer.borderWidth = 0.5
        pulsingLayer.borderColor = bgColor.cgColor
        pulsingLayer.cornerRadius = rect.size.height / 2
        pulsingLayer.add(animationGroup, forKey: "plusing")
        return pulsingLayer
    }
    
    
    func scaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = multiple
        return scaleAnimation
    }
    
    
    func backgroundColorAnimation() -> CAKeyframeAnimation {
        let backgroundColorAnimation = CAKeyframeAnimation()
        backgroundColorAnimation.keyPath = "backgroundColor"
        backgroundColorAnimation.values = [UIColor.color(hexString: "#FFC2C2").cgColor,
                                           UIColor.color(hexString: "#FFDCDC").cgColor,
                                           UIColor.clear.cgColor]
        backgroundColorAnimation.keyTimes = [0.45, 0.9, 1]
        return backgroundColorAnimation
    }
    
    
    func borderColorAnimation() -> CAKeyframeAnimation {
        let borderColorAnimation = CAKeyframeAnimation()
        borderColorAnimation.keyPath = "borderColor"
        borderColorAnimation.values = [UIColor.color(hexString: "#FFC2C2").cgColor,
                                       UIColor.color(hexString: "#FFDCDC").cgColor,
                                       UIColor.clear.cgColor]
        borderColorAnimation.keyTimes = [0.45, 0.9, 1]
        return borderColorAnimation
    }
}
