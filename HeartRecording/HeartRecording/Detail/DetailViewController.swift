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
    var ana_gradientLayer:      CAGradientLayer!
    var ana_closeButton:        UIButton!
    var ana_likeButton:         UIButton!
    var ana_shareButton:        UIButton!
    var ana_animationView:      RippleAnimationView!
    var ana_mainView:           UIView!
    var ana_heartImageView:     UIImageView!
    var ana_nameTextField:      UITextField!
    var ana_dateLabel:          UILabel!
    var ana_editButton:         UIButton!
    var ana_leftButton:         UIButton!
    var ana_playButton:         UIButton!
    var ana_rightButton:        UIButton!
    var ana_progressBackView:   UIView!
    var ana_progressBackLine:   UIView!
    var ana_progressLine:       UIView!
    var ana_progressImageView:  UIImageView!
    var ana_progressTimeLabel:  UILabel!
    var ana_totalTimeLabel:     UILabel!
    
    var ana_model: DbRecordModel!
    var ana_totalTime: CGFloat = 0
    var ana_currectTime: CGFloat = 0
    var ana_progress: CGFloat = 0
    var ana_shouldSeek = false
    
    
    convenience init(model: DbRecordModel) {
        self.init()
        self.ana_model = model
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if NBUserVipStatusManager.shard.getVipStatus() {
            play()
        }
    }
    
    
    func configureSubViews() {
        ana_gradientLayer = CAGradientLayer()
        ana_gradientLayer.colors = [UIColor.color(hexString: "#FBFCFF").cgColor, UIColor.color(hexString: "#FFF0F0").cgColor]
        ana_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        ana_gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(ana_gradientLayer)
        
        ana_closeButton = UIButton()
        ana_closeButton.setImage(UIImage(named: "Detail_Close"), for: .normal)
        ana_closeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        view.addSubview(ana_closeButton)
        
        ana_likeButton = UIButton()
        ana_likeButton.setImage(UIImage(named: "Detail_" + ((ana_model.favorite ?? false) ? "Favorite" : "Like")), for: .normal)
        ana_likeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
            DbManager.manager.changeFavoriteModel(self.ana_model)
            self.ana_model.favorite = !(self.ana_model.favorite ?? false)
            button.setImage(UIImage(named: "Detail_" + ((self.ana_model.favorite ?? false) ? "Favorite" : "Like")), for: .normal)
        }
        view.addSubview(ana_likeButton)
        
        ana_shareButton = UIButton()
        ana_shareButton.setImage(UIImage(named: "Detail_Share"), for: .normal)
        ana_shareButton.setImage(UIImage(named: "Detail_Share"), for: .highlighted)
        ana_shareButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			self.showSubscriptionIfNeeded(scene: .share) {
                [weak self] in
                guard let self = self else { return }
                if let fileName = self.ana_model.path {
					if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/" + fileName) {
						let vc = UIActivityViewController.init(activityItems: [URL(fileURLWithPath: path)], applicationActivities: nil)
						self.present(vc, animated: true, completion: nil)
					}
                }
            }
        }
        view.addSubview(ana_shareButton)
        
        ana_animationView = RippleAnimationView(bgColor: .color(hexString: "#FF8282"))
        view.addSubview(ana_animationView)
        
        ana_mainView = UIView()
        ana_mainView.layer.cornerRadius = 134
        ana_mainView.backgroundColor = .color(hexString: "#FF8282")
        view.addSubview(ana_mainView)
        
        ana_heartImageView = UIImageView()
        ana_heartImageView.image = UIImage(named: "Record_Heart")
        ana_mainView.addSubview(ana_heartImageView)
        
        ana_nameTextField = UITextField()
        ana_nameTextField.text = ana_model.name
        ana_nameTextField.isEnabled = false
        ana_nameTextField.textColor = .white
        ana_nameTextField.font = .systemFont(ofSize: 28)
        ana_nameTextField.returnKeyType = .done
        ana_nameTextField.textAlignment = .center
        ana_nameTextField.delegate = self
        ana_mainView.addSubview(ana_nameTextField)
        
        let date = DbManager.manager.dateFormatter.date(from: String(ana_model.id!))!
        let dateforMatter = DateFormatter()
        dateforMatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateforMatter.string(from: date)
        
        ana_dateLabel = UILabel()
        ana_dateLabel.text = dateString
        ana_dateLabel.textColor = .white
        ana_dateLabel.font = .systemFont(ofSize: 14)
        ana_mainView.addSubview(ana_dateLabel)
        
        ana_editButton = UIButton()
        ana_editButton.setImage(UIImage(named: "Detail_Edit"), for: .normal)
        ana_editButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            NameEditAlert.show(name: self.ana_model.name, id: self.ana_model.id!, vc: self) {
                [weak self] newName in
                guard let self = self else { return }
                self.ana_nameTextField.text = newName
            }
        }
        ana_mainView.addSubview(ana_editButton)
        
        ana_leftButton = UIButton()
        ana_leftButton.setImage(UIImage(named: "Detail_Left"), for: .normal)
        ana_leftButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
            if self.ana_currectTime == 0 {
                return
            }
            self.ana_currectTime = max(0, self.ana_currectTime - 5)
            self.ana_progress = self.ana_currectTime / self.ana_totalTime
            self.view.layoutNow()
            if PlayerManager.shared.isPlaying {
                PlayerManager.shared.seekToProgress(self.ana_progress)
            } else {
                self.ana_shouldSeek = true
            }
        }
        view.addSubview(ana_leftButton)
        
        ana_playButton = UIButton()
        ana_playButton.setImage(UIImage(named: "Detail_Play"), for: .normal)
        ana_playButton.layer.cornerRadius = 44
        ana_playButton.backgroundColor = .color(hexString: "#FF8282")
        ana_playButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			self.showSubscriptionIfNeeded(scene: .play) {
				[weak self] in
				guard let self = self else { return }
				if !PlayerManager.shared.isPlaying {
					if self.ana_progress == 0 {
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
        }
        view.addSubview(ana_playButton)
        
        ana_rightButton = UIButton()
        ana_rightButton.setImage(UIImage(named: "Detail_Right"), for: .normal)
        ana_rightButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
            if self.ana_currectTime + 5 >= self.ana_totalTime {
                return
            }
            self.ana_currectTime += 5
            self.ana_progress = self.ana_currectTime / self.ana_totalTime
            self.view.layoutNow()
            if PlayerManager.shared.isPlaying {
                PlayerManager.shared.seekToProgress(self.ana_progress)
            } else {
                self.ana_shouldSeek = true
            }
        }
        view.addSubview(ana_rightButton)
        
        ana_progressBackView = UIView()
        ana_progressBackView.backgroundColor = .clear
        view.addSubview(ana_progressBackView)
        
        ana_progressBackLine = UIView()
        ana_progressBackLine.backgroundColor = UIColor.color(hexString: "#A0A3B1").withAlphaComponent(0.5)
        ana_progressBackView.addSubview(ana_progressBackLine)
        
        ana_progressLine = UIView()
        ana_progressLine.backgroundColor = .color(hexString: "#3F414E")
        ana_progressBackView.addSubview(ana_progressLine)
        
        ana_progressImageView = UIImageView()
        ana_progressImageView.image = UIImage(named: "Detail_Progress")
        ana_progressBackView.addSubview(ana_progressImageView)
        
        ana_progressTimeLabel = UILabel()
        ana_progressTimeLabel.text = "00:00"
        ana_progressTimeLabel.textColor = .color(hexString: "#3F414E")
        ana_progressTimeLabel.font = .systemFont(ofSize: 16)
        view.addSubview(ana_progressTimeLabel)
        
        ana_totalTimeLabel = UILabel()
        ana_totalTimeLabel.text = "00:00"
        ana_totalTimeLabel.textColor = .color(hexString: "#3F414E")
        ana_totalTimeLabel.font = .systemFont(ofSize: 16)
        view.addSubview(ana_totalTimeLabel)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ana_gradientLayer.frame = view.bounds
        ana_closeButton.sizeToFit()
        ana_closeButton.setOrigin(x: 20, y: 50)
        ana_shareButton.sizeToFit()
        ana_shareButton.setOrigin(x: view.width() - 20 - ana_shareButton.width(), y: 50)
        ana_likeButton.sizeToFit()
        ana_likeButton.setOrigin(x: ana_shareButton.minX() - 15 - ana_likeButton.width(), y: 50)
        ana_mainView.bounds = CGRect(origin: .zero, size: CGSize(width: 268, height: 268))
        ana_mainView.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.4)
        ana_animationView.frame = ana_mainView.frame
        ana_heartImageView.sizeToFit()
        ana_heartImageView.center = CGPoint(x: ana_mainView.halfWidth(), y: 65 + ana_heartImageView.halfHeight())
        ana_nameTextField.sizeToFit()
        ana_nameTextField.bounds = CGRect(origin: .zero, size: CGSize(width: 264, height: ana_nameTextField.height()))
        ana_nameTextField.center = CGPoint(x: ana_mainView.halfWidth(), y: ana_heartImageView.maxY() + 29 + ana_nameTextField.halfHeight())
        ana_dateLabel.sizeToFit()
        ana_dateLabel.center = CGPoint(x: ana_mainView.halfWidth(), y: ana_nameTextField.maxY() - 3 + ana_dateLabel.halfHeight())
        ana_editButton.sizeToFit()
        ana_editButton.center = CGPoint(x: ana_mainView.halfWidth(), y: ana_dateLabel.maxY() + 29 + ana_editButton.halfHeight())
        ana_playButton.bounds = CGRect(origin: .zero, size: CGSize(width: 88, height: 88))
        ana_playButton.center = CGPoint(x: view.halfWidth(), y: view.height() * 0.73)
        ana_leftButton.sizeToFit()
        ana_leftButton.center = CGPoint(x: ana_playButton.minX() - 61 - ana_leftButton.halfWidth(), y: ana_playButton.centerY())
        ana_rightButton.sizeToFit()
        ana_rightButton.center = CGPoint(x: ana_playButton.maxX() + 61 + ana_rightButton.halfWidth(), y: ana_playButton.centerY())
        ana_progressImageView.sizeToFit()
        ana_progressBackView.frame = CGRect(x: 40, y: view.height() * 0.86, width: view.width() - 80, height: ana_progressImageView.height())
        ana_progressBackLine.bounds = CGRect(origin: .zero, size: CGSize(width: ana_progressBackView.width(), height: 3))
        ana_progressBackLine.center = CGPoint(x: ana_progressBackView.halfWidth(), y: ana_progressBackView.halfHeight())
        ana_progressLine.frame = CGRect(x: 0, y: ana_progressBackLine.minY(), width: ana_progress * ana_progressBackView.width(), height: 3)
        ana_progressImageView.center = CGPoint(x: ana_progressLine.maxX(), y: ana_progressBackView.halfHeight())
        ana_progressTimeLabel.sizeToFit()
        ana_progressTimeLabel.center = CGPoint(x: ana_progressBackView.minX(), y: ana_progressBackView.maxY() + 4 + ana_progressTimeLabel.halfHeight())
        ana_totalTimeLabel.sizeToFit()
        ana_totalTimeLabel.center = CGPoint(x: ana_progressBackView.maxX(), y: ana_progressTimeLabel.centerY())
    }
    
    
    func play() {
        PlayerManager.shared.play(path: ana_model.path!) {
            [weak self] time in
            guard let self = self else { return }
            if !time.isNaN {
                self.ana_totalTime = floor(time)
            }
            self.ana_totalTimeLabel.text = String.stringFromTime(self.ana_totalTime)
            self.ana_playButton.setImage(UIImage(named: "Detail_Pause"), for: .normal)
            self.view.layoutNow()
        } progressAction: {
            time, totalTime in
            if !time.isNaN {
                self.ana_currectTime = floor(time)
            }
            self.ana_progressTimeLabel.text = String.stringFromTime(self.ana_currectTime)
            self.view.layoutNow()
			if !totalTime.isNaN && totalTime != 0 {
				self.ana_totalTime = totalTime
				self.ana_progress = self.ana_currectTime / self.ana_totalTime
				self.ana_totalTimeLabel.text = String.stringFromTime(self.ana_totalTime)
			}
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } endAction: {
            self.ana_playButton.setImage(UIImage(named: "Detail_Play"), for: .normal)
            self.ana_progressTimeLabel.text = "00:00"
            self.view.layoutNow()
            self.ana_progress = 0
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
            textField.text = ana_model.name
        } else {
            DbManager.manager.updateName(textField.text!, id: ana_model.id!)
        }
    }
}
