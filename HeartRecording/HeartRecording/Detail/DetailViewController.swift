//
//  DetailViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/16.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


class DetailViewController: UIViewController, UITextFieldDelegate {
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
    
    var path: String!
    var name: String!
    var dateString: String!
    var totalTime: CGFloat = 0
    var currectTime: CGFloat = 0
    var progress: CGFloat = 0
    
    
    convenience init(path: String, name: String, dateString: String) {
        self.init()
        self.path = path
        self.name = name
        self.dateString = dateString
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        play()
    }
    
    
    func configureSubViews() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(gradientLayer)
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "Detail_Close"), for: .normal)
        closeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
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
        heartImageView.image = UIImage(named: "Record_Heart")
        mainView.addSubview(heartImageView)
        
        nameTextField = UITextField()
        nameTextField.text = name
        nameTextField.isEnabled = false
        nameTextField.textColor = .white
        nameTextField.font = .systemFont(ofSize: 28)
        nameTextField.returnKeyType = .done
        nameTextField.textAlignment = .center
        nameTextField.delegate = self
        mainView.addSubview(nameTextField)
        
        dateLabel = UILabel()
        dateLabel.text = dateString
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 14)
        mainView.addSubview(dateLabel)
        
        editButton = UIButton()
        editButton.setImage(UIImage(named: "Detail_Edit"), for: .normal)
        editButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.nameTextField.isEnabled = true
            self.nameTextField.becomeFirstResponder()
        }
        mainView.addSubview(editButton)
        
        leftButton = UIButton()
        leftButton.setImage(UIImage(named: "Detail_Left"), for: .normal)
        view.addSubview(leftButton)
        
        playButton = UIButton()
        playButton.setImage(UIImage(named: "Detail_Play"), for: .normal)
        playButton.layer.cornerRadius = 44
        playButton.backgroundColor = .color(hexString: "#FF8282")
        playButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
            if !PlayerManager.shared.isPlaying {
                if self.progress == 0 {
                    self.play()
                } else {
                    PlayerManager.shared.resume()
                    button.setImage(UIImage(named: "Detail_Pause"), for: .normal)
                }
            } else {
                PlayerManager.shared.pause()
                button.setImage(UIImage(named: "Detail_Play"), for: .normal)
            }
        }
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
        progressTimeLabel.text = "00:00"
        progressTimeLabel.textColor = .color(hexString: "#3F414E")
        progressTimeLabel.font = .systemFont(ofSize: 16)
        view.addSubview(progressTimeLabel)
        
        totalTimeLabel = UILabel()
        totalTimeLabel.text = "00:00"
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
        heartImageView.sizeToFit()
        heartImageView.center = CGPoint(x: mainView.halfWidth(), y: 65 + heartImageView.halfHeight())
        nameTextField.sizeToFit()
        nameTextField.bounds = CGRect(origin: .zero, size: CGSize(width: 264, height: nameTextField.height()))
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
        progressLine.frame = CGRect(x: 0, y: progressBackLine.minY(), width: progress * progressBackView.width(), height: 3)
        progressImageView.center = CGPoint(x: progressLine.maxX(), y: progressBackView.halfHeight())
        progressTimeLabel.sizeToFit()
        progressTimeLabel.center = CGPoint(x: progressBackView.minX(), y: progressBackView.maxY() + 4 + progressTimeLabel.halfHeight())
        totalTimeLabel.sizeToFit()
        totalTimeLabel.center = CGPoint(x: progressBackView.maxX(), y: progressTimeLabel.centerY())
    }
    
    
    func play() {
        PlayerManager.shared.play(path: path) {
            [weak self] time in
            guard let self = self else { return }
            self.totalTime = floor(time)
            self.totalTimeLabel.text = String.stringFromTime(self.totalTime)
            self.playButton.setImage(UIImage(named: "Detail_Pause"), for: .normal)
            self.view.layoutNow()
        } progressAction: {
            time in
            self.currectTime = floor(time)
            self.progressTimeLabel.text = String.stringFromTime(self.currectTime)
            self.progress = time / self.totalTime
            self.view.layoutNow()
        } endAction: {
            self.progress = 0
            self.playButton.setImage(UIImage(named: "Detail_Play"), for: .normal)
            self.progressTimeLabel.text = "00:00"
            self.view.layoutNow()
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isEnabled = false
        return false
    }
}
