//
//  DetailViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/16.
//

import UIKit


class DetailViewController: UIViewController {
    var gradientLayer:      CAGradientLayer!
    var closeButton:        UIButton!
    var likeButton:         UIButton!
    var shareButton:        UIButton!
    var animationView:      RippleAnimationView!
    var mainView:           UIView!
    var heartImageView:     UIImageView!
    var nameTextField:      UITextField!
    var dateLabel:          UILabel!
    var editButton:         UIButton!
    var leftButton:         UIButton!
    var playButton:         UIButton!
    var rightButton:        UIButton!
    var progressBackView:   UIView!
    var progressBackLine:   UIView!
    var progressLine:       UIView!
    var progressImageView:  UIImageView!
    var progressTimeLabel:  UILabel!
    var totalTimeLabel:     UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(gradientLayer)
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "Detail_Close"), for: .normal)
        view.addSubview(closeButton)
        
        likeButton = UIButton()
        likeButton.setImage(UIImage(named: "Detail_Like"), for: .normal)
        view.addSubview(likeButton)
        
        shareButton = UIButton()
        shareButton.setImage(UIImage(named: "Detail_Share"), for: .normal)
        view.addSubview(shareButton)
        
        animationView = RippleAnimationView(bgColor: .color(hexString: "#FF8282"))
        view.addSubview(animationView)
        
        mainView = UIView()
        mainView.layer.cornerRadius = 134
        mainView.backgroundColor = .color(hexString: "#FF8282")
        view.addSubview(mainView)
        
        heartImageView = UIImageView()
        heartImageView.backgroundColor = .white
        mainView.addSubview(heartImageView)
        
        nameTextField = UITextField()
        nameTextField.isEnabled = false
        nameTextField.text = "New Recording"
        nameTextField.textColor = .white
        nameTextField.font = .systemFont(ofSize: 28)
        nameTextField.returnKeyType = .done
        mainView.addSubview(nameTextField)
        
        dateLabel = UILabel()
        dateLabel.text = "2020-02-22"
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 14)
        mainView.addSubview(dateLabel)
        
        editButton = UIButton()
        editButton.setImage(UIImage(named: "Detail_Edit"), for: .normal)
        mainView.addSubview(editButton)
        
        leftButton = UIButton()
        leftButton.setImage(UIImage(named: "Detail_Left"), for: .normal)
        view.addSubview(leftButton)
        
        playButton = UIButton()
        playButton.layer.cornerRadius = 44
        playButton.backgroundColor = .color(hexString: "#FF8282")
        view.addSubview(playButton)
        
        rightButton = UIButton()
        rightButton.setImage(UIImage(named: "Detail_Right"), for: .normal)
        view.addSubview(rightButton)
        
        progressBackView = UIView()
        progressBackView.backgroundColor = .clear
        view.addSubview(progressBackView)
        
        progressBackLine = UIView()
        progressBackLine.backgroundColor = UIColor.color(hexString: "#A0A3B1").withAlphaComponent(0.5)
        progressBackView.addSubview(progressBackLine)
        
        progressLine = UIView()
        progressLine.backgroundColor = .color(hexString: "#3F414E")
        progressBackView.addSubview(progressLine)
        
        progressImageView = UIImageView()
        progressImageView.image = UIImage(named: "Detail_Progress")
        progressBackView.addSubview(progressImageView)
        
        progressTimeLabel = UILabel()
        progressTimeLabel.text = "01:30"
        progressTimeLabel.textColor = .color(hexString: "#3F414E")
        progressTimeLabel.font = .systemFont(ofSize: 16)
        view.addSubview(progressTimeLabel)
        
        totalTimeLabel = UILabel()
        totalTimeLabel.text = "45:00"
        totalTimeLabel.textColor = .color(hexString: "#3F414E")
        totalTimeLabel.font = .systemFont(ofSize: 16)
        view.addSubview(totalTimeLabel)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
        closeButton.sizeToFit()
        closeButton.setOrigin(x: 20, y: 50)
        shareButton.sizeToFit()
        shareButton.setOrigin(x: view.width() - 20 - shareButton.width(), y: 50)
        likeButton.sizeToFit()
        likeButton.setOrigin(x: shareButton.minX() - 15 - likeButton.width(), y: 50)
        mainView.bounds = CGRect(origin: .zero, size: CGSize(width: 268, height: 268))
        mainView.center = CGPoint(x: view.halfWidth(), y: closeButton.maxY() + 114 + mainView.halfHeight())
        animationView.frame = mainView.frame
        heartImageView.bounds = CGRect(origin: .zero, size: CGSize(width: 43, height: 40))
        heartImageView.center = CGPoint(x: mainView.halfWidth(), y: 65 + heartImageView.halfHeight())
        nameTextField.sizeToFit()
        nameTextField.bounds = CGRect(origin: .zero, size: CGSize(width: min(nameTextField.width(), 264), height: nameTextField.height()))
        nameTextField.center = CGPoint(x: mainView.halfWidth(), y: heartImageView.maxY() + 29 + nameTextField.halfHeight())
        dateLabel.sizeToFit()
        dateLabel.center = CGPoint(x: mainView.halfWidth(), y: nameTextField.maxY() - 3 + dateLabel.halfHeight())
        editButton.sizeToFit()
        editButton.center = CGPoint(x: mainView.halfWidth(), y: dateLabel.maxY() + 29 + editButton.halfHeight())
        playButton.bounds = CGRect(origin: .zero, size: CGSize(width: 88, height: 88))
        playButton.center = CGPoint(x: view.halfWidth(), y: mainView.maxY() + 102 + playButton.halfHeight())
        leftButton.sizeToFit()
        leftButton.center = CGPoint(x: playButton.minX() - 61 - leftButton.halfWidth(), y: playButton.centerY())
        rightButton.sizeToFit()
        rightButton.center = CGPoint(x: playButton.maxX() + 61 + rightButton.halfWidth(), y: playButton.centerY())
        progressImageView.sizeToFit()
        progressBackView.frame = CGRect(x: 40, y: playButton.maxY() + 61, width: view.width() - 80, height: progressImageView.height())
        progressBackLine.bounds = CGRect(origin: .zero, size: CGSize(width: progressBackView.width(), height: 3))
        progressBackLine.center = CGPoint(x: progressBackView.halfWidth(), y: progressBackView.halfHeight())
        progressLine.frame = CGRect(x: 0, y: progressBackLine.minY(), width: 30, height: 3)
        progressImageView.center = CGPoint(x: progressLine.maxX(), y: progressBackView.halfHeight())
        progressTimeLabel.sizeToFit()
        progressTimeLabel.center = CGPoint(x: progressBackView.minX(), y: progressBackView.maxY() + 4 + progressTimeLabel.halfHeight())
        totalTimeLabel.sizeToFit()
        totalTimeLabel.center = CGPoint(x: progressBackView.maxX(), y: progressTimeLabel.centerY())
    }
}
