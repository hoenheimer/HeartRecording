//
//  RecordViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/15.
//

import UIKit

class RecordViewController: AnaLargeTitleViewController {
    var mainView: UIView!
    var imageView: UIView!
    var label: UILabel!
    var button: UIButton!
    
    
    override func configure() {
        super.configure()
        
        setTitle(title: "HeartRecording")
        
        
    }
    
    
    override func layoutContentView() -> CGFloat {
        return 0
    }
}
