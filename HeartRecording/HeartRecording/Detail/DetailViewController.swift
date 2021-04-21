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
    
    var model: DbModel!
    var totalTime: CGFloat = 0
    var currectTime: CGFloat = 0
    var progress: CGFloat = 0
    var shouldSeek = false
    
    
    convenience init(model: DbModel) {
        self.init()
        self.model = model
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
        likeButton.setImage(UIImage(named: "Detail_" + ((model.favorite ?? false) ? "Favorite" : "Like")), for: .normal)
        likeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
            DbManager.manager.changeFavoriteModel(self.model)
            self.model.favorite = !(self.model.favorite ?? false)
            button.setImage(UIImage(named: "Detail_" + ((self.model.favorite ?? false) ? "Favorite" : "Like")), for: .normal)
        }
        view.addSubview(likeButton)
        
        shareButton = UIButton()
        shareButton.setImage(UIImage(named: "Detail_Share"), for: .normal)
        shareButton.setImage(UIImage(named: "Detail_Share"), for: .highlighted)
        shareButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            if let path = self.model.path {
                let vc = UIActivityViewController.init(activityItems: [URL(fileURLWithPath: path)], applicationActivities: nil)
                self.present(vc, animated: true, completion: nil)
            }
        }
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
        nameTextField.text = model.name
        nameTextField.isEnabled = false
        nameTextField.textColor = .white
        nameTextField.font = .systemFont(ofSize: 28)
        nameTextField.returnKeyType = .done
        nameTextField.textAlignment = .center
        nameTextField.delegate = self
        mainView.addSubview(nameTextField)
        
        let date = DbManager.manager.dateFormatter.date(from: String(model.id!))!
        let dateforMatter = DateFormatter()
        dateforMatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateforMatter.string(from: date)
        
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
            NameEditAlert.show(name: self.model.name, id: self.model.id!, vc: self) {
                [weak self] newName in
                guard let self = self else { return }
                self.nameTextField.text = newName
            }
        }
        mainView.addSubview(editButton)
        
        leftButton = UIButton()
        leftButton.setImage(UIImage(named: "Detail_Left"), for: .normal)
        leftButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            if self.currectTime == 0 {
                return
            }
            self.currectTime = max(0, self.currectTime - 5)
            self.progress = self.currectTime / self.totalTime
            self.view.layoutNow()
            if PlayerManager.shared.isPlaying {
                PlayerManager.shared.seekToProgress(self.progress)
            } else {
                self.shouldSeek = true
            }
        }
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
        rightButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            if self.currectTime + 5 >= self.totalTime {
                return
            }
            self.currectTime += 5
            self.progress = self.currectTime / self.totalTime
            self.view.layoutNow()
            if PlayerManager.shared.isPlaying {
                PlayerManager.shared.seekToProgress(self.progress)
            } else {
                self.shouldSeek = true
            }
        }
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
        PlayerManager.shared.play(path: model.path!) {
            [weak self] time in
            guard let self = self else { return }
            if !time.isNaN {
                self.totalTime = floor(time)
            }
            self.totalTimeLabel.text = String.stringFromTime(self.totalTime)
            self.playButton.setImage(UIImage(named: "Detail_Pause"), for: .normal)
            self.view.layoutNow()
        } progressAction: {
            time in
            if !time.isNaN {
                self.currectTime = floor(time)
            }
            self.progressTimeLabel.text = String.stringFromTime(self.currectTime)
            self.view.layoutNow()
            self.progress = self.currectTime / self.totalTime
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } endAction: {
            self.playButton.setImage(UIImage(named: "Detail_Play"), for: .normal)
            self.progressTimeLabel.text = "00:00"
            self.view.layoutNow()
            self.progress = 0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.view.layoutNow()
            }
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isEnabled = false
        return false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil || textField.text!.count == 0 {
            textField.text = model.name
        } else {
            DbManager.manager.updateName(textField.text!, id: model.id!)
        }
    }
}
