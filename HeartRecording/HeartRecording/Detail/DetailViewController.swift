//
//  DetailViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/16.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import YYImage
import FLAnimatedImage


class DetailViewController: UIViewController, UITextFieldDelegate {
    var ana_closeButton:        UIButton!
    var ana_likeButton:         UIButton!
    var ana_shareButton:        UIButton!
	var backImageView: 			FLAnimatedImageView!
	var heartImageView: 		YYAnimatedImageView!
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
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.isHidden = true
		if let tabBarController = tabBarController as? AnaTabBarController {
			tabBarController.simulationTabBar.isHidden = true
		}
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = false
		if let tabBarController = tabBarController as? AnaTabBarController {
			tabBarController.simulationTabBar.isHidden = false
		}
	}
	
    
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		backImageView.stopAnimating()
		
        if NBUserVipStatusManager.shard.getVipStatus() {
            play()
        }
    }
    
    
    func configureSubViews() {
		view.backgroundColor = .white
        
        ana_closeButton = UIButton()
        ana_closeButton.setImage(UIImage(named: "Kick_Close"), for: .normal)
        ana_closeButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
			self.navigationController?.popViewController(animated: true)
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
			self.showSubscriptionIfNeeded {
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
		
		backImageView = FLAnimatedImageView(gifName: "Detail")
		view.addSubview(backImageView)
		
		heartImageView = YYAnimatedImageView()
		heartImageView.image = YYImage(named: "Heart")
		heartImageView.autoPlayAnimatedImage = false
		backImageView.addSubview(heartImageView)
        
        ana_nameTextField = UITextField()
        ana_nameTextField.text = ana_model.name
        ana_nameTextField.isEnabled = false
        ana_nameTextField.textColor = .color(hexString: "#6a515e")
        ana_nameTextField.font = UIFont(name: "Poppins-Medium", size: 24)
        ana_nameTextField.returnKeyType = .done
        ana_nameTextField.textAlignment = .center
        ana_nameTextField.delegate = self
		backImageView.addSubview(ana_nameTextField)
        
        let date = DbManager.manager.dateFormatter.date(from: String(ana_model.id!))!
        let dateforMatter = DateFormatter()
        dateforMatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateforMatter.string(from: date)
        
        ana_dateLabel = UILabel()
        ana_dateLabel.text = dateString
        ana_dateLabel.textColor = .color(hexString: "#6a515e")
        ana_dateLabel.font = UIFont(name: "Poppins-Medium", size: 13)
		backImageView.addSubview(ana_dateLabel)
        
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
		view.addSubview(ana_editButton)
        
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
		ana_playButton.setShadow(color: .color(hexString: "#35d74b61"), offset: CGSize(width: 0, height: 12), radius: 38, opacity: 1)
        ana_playButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] button in
            guard let self = self else { return }
			FeedbackManager.feedback(type: .light)
			self.showSubscriptionIfNeeded {
				[weak self] in
				guard let self = self else { return }
				if !PlayerManager.shared.isPlaying {
					if self.ana_progress == 0 {
						self.play()
					} else {
						PlayerManager.shared.resume()
						self.backImageView.startAnimating()
						self.heartImageView.startAnimating()
						button.setImage(UIImage(named: "Detail_Pause"), for: .normal)
					}
				} else {
					PlayerManager.shared.pause()
					self.backImageView.stopAnimating()
					self.heartImageView.stopAnimating()
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
		ana_progressBackLine.layer.cornerRadius = 1.5
        ana_progressBackLine.backgroundColor = UIColor.color(hexString: "#6a515e").withAlphaComponent(0.25)
        ana_progressBackView.addSubview(ana_progressBackLine)
        
        ana_progressLine = UIView()
		ana_progressLine.layer.cornerRadius = 1.5
        ana_progressLine.backgroundColor = .color(hexString: "#6a515e")
        ana_progressBackView.addSubview(ana_progressLine)
        
        ana_progressImageView = UIImageView()
        ana_progressImageView.image = UIImage(named: "Detail_Progress")
        ana_progressBackView.addSubview(ana_progressImageView)
        
        ana_progressTimeLabel = UILabel()
        ana_progressTimeLabel.text = "00:00"
        ana_progressTimeLabel.textColor = .color(hexString: "#6a515e")
        ana_progressTimeLabel.font = UIFont(name: "Poppins-Regular", size: 12)
        view.addSubview(ana_progressTimeLabel)
        
        ana_totalTimeLabel = UILabel()
        ana_totalTimeLabel.text = "00:00"
        ana_totalTimeLabel.textColor = .color(hexString: "#6a515e")
        ana_totalTimeLabel.font = UIFont(name: "Poppins-Regular", size: 12)
        view.addSubview(ana_totalTimeLabel)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ana_closeButton.sizeToFit()
        ana_closeButton.setOrigin(x: 20, y: 50)
        ana_shareButton.sizeToFit()
        ana_shareButton.setOrigin(x: view.width() - 20 - ana_shareButton.width(), y: 50)
        ana_likeButton.sizeToFit()
        ana_likeButton.setOrigin(x: ana_shareButton.minX() - 15 - ana_likeButton.width(), y: 50)
		backImageView.sizeToFit()
		if backImageView.width() != 0 {
			let scale = (view.width() - 16) / backImageView.width()
			backImageView.bounds = CGRect(x: 0, y: 0, width: view.width() - 16, height: backImageView.height() * scale)
		}
		backImageView.center = CGPoint(x: view.halfWidth(), y: ana_closeButton.maxY() + 39 + backImageView.halfHeight())
		heartImageView.sizeToFit()
		heartImageView.center = CGPoint(x: backImageView.halfWidth(), y: backImageView.height() * 0.4)
        ana_nameTextField.sizeToFit()
        ana_nameTextField.bounds = CGRect(origin: .zero, size: CGSize(width: 264, height: ana_nameTextField.height()))
		ana_nameTextField.center = CGPoint(x: backImageView.halfWidth(), y: backImageView.height() * 0.63)
        ana_dateLabel.sizeToFit()
        ana_dateLabel.center = CGPoint(x: backImageView.halfWidth(), y: ana_nameTextField.maxY() + ana_dateLabel.halfHeight())
        ana_editButton.sizeToFit()
		ana_editButton.center = CGPoint(x: view.halfWidth(), y: ana_dateLabel.maxY() + 18 + ana_editButton.halfHeight() + backImageView.minY())
		ana_progressTimeLabel.sizeToFit()
		ana_progressTimeLabel.bounds = CGRect(x: 0, y: 0, width: ana_progressTimeLabel.width(), height: 44)
		ana_progressTimeLabel.center = CGPoint(x: 40 + ana_progressTimeLabel.halfWidth(),
											   y: view.height() - bottomSpacing() - 35 - ana_progressTimeLabel.halfHeight())
		ana_totalTimeLabel.sizeToFit()
		ana_totalTimeLabel.center = CGPoint(x: view.width() - 40 - ana_totalTimeLabel.halfWidth(), y: ana_progressTimeLabel.centerY())
		ana_progressImageView.sizeToFit()
		ana_progressBackView.frame = CGRect(x: 40,
											y: ana_progressTimeLabel.minY() - ana_progressImageView.height(),
											width: view.width() - 80,
											height: ana_progressImageView.height())
		ana_progressBackLine.bounds = CGRect(origin: .zero, size: CGSize(width: ana_progressBackView.width(), height: 3))
		ana_progressBackLine.center = CGPoint(x: ana_progressBackView.halfWidth(), y: ana_progressBackView.halfHeight())
		ana_progressLine.frame = CGRect(x: 0, y: ana_progressBackLine.minY(), width: ana_progress * ana_progressBackView.width(), height: 3)
		ana_progressImageView.center = CGPoint(x: ana_progressLine.maxX(), y: ana_progressBackView.halfHeight())
        ana_playButton.bounds = CGRect(origin: .zero, size: CGSize(width: 72, height: 72))
		ana_playButton.center = CGPoint(x: view.halfWidth(), y: ana_progressBackView.minY() - 37 - ana_playButton.halfHeight())
        ana_leftButton.sizeToFit()
        ana_leftButton.center = CGPoint(x: ana_playButton.minX() - 61 - ana_leftButton.halfWidth(), y: ana_playButton.centerY())
        ana_rightButton.sizeToFit()
        ana_rightButton.center = CGPoint(x: ana_playButton.maxX() + 61 + ana_rightButton.halfWidth(), y: ana_playButton.centerY())
        ana_progressImageView.sizeToFit()
        
    }
    
    
    func play() {
		backImageView.startAnimating()
		heartImageView.startAnimating()
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
			self.backImageView.stopAnimating()
			self.heartImageView.stopAnimating()
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
