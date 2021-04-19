//
//  NBBasePopUpBox.swift
//  MeditationDiary
//
//  Created by luoyue on 2019/11/20.
//  Copyright © 2019 Novabeyond. All rights reserved.
//

import UIKit



class NBBasePopUpBox: UIView {

    static private let shard = NBBasePopUpBox()
    var tapGesture: UITapGestureRecognizer?
    var originWindowWindowColor: UIColor?
//    weak var popWindow: UIWindow?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tapGesture = UITapGestureRecognizer(target: self, action:  #selector(hiddenPopup))
        self.addGestureRecognizer(tapGesture!)
    }

    func showActionSheet(){
        
        if let window = NBBasePopUpBox.getWindow(){
//            popWindow = window
            self.frame = window.bounds
            originWindowWindowColor = window.backgroundColor
//            popWindow?.backgroundColor = UIColor.black.alpha(0.5)
            window.addSubview(self)
        }
//        popUpWindow.makeKeyAndVisible()
//        popUpWindow.addSubview(self)
    }
    
    @objc func hiddenPopup(){
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let window = delegate.window
//        window?.makeKeyAndVisible()
        removeFromSuperview()
        if let window = NBBasePopUpBox.getWindow(){
            window.backgroundColor = originWindowWindowColor
        }        
    }
     
    deinit {
        #if DEBUG
        print("弹窗销毁")
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    class func getWindow() -> UIWindow? {
        let windows = UIApplication.shared.windows
        for window in windows {
            if window.windowLevel == .normal && window.bounds.equalTo(UIScreen.main.bounds){
                return window
            }
        }
        return nil
    }
}
