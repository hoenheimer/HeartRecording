//
//  NameEditView.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/20.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift


class NameEditView: UIView, UITextFieldDelegate {
	var backView: UIView!
	var textFieldBackView: UIView!
	var textField: UITextField!
	
	var keyboardHeight: CGFloat = 0
	let editPipe = Signal<String?, Never>.pipe()
	let savePipe = Signal<String?, Never>.pipe()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	
	func configure() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		backgroundColor = .clear
		isUserInteractionEnabled = false
		
		backView = UIView()
		backView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		backView.alpha = 0
		addSubview(backView)
		
		let tap = UITapGestureRecognizer()
		tap.reactive.stateChanged.observeValues {
			[weak self] _ in
			guard let self = self else { return }
			self.textField.resignFirstResponder()
		}
		backView.addGestureRecognizer(tap)
		
		textFieldBackView = UIView()
		textFieldBackView.backgroundColor = .white
		addSubview(textFieldBackView)
		
		textField = UITextField()
		textField.textColor = .color(hexString: "#504278")
		textField.font = UIFont(name: "Poppins-SemiBold", size: 16)
		textField.delegate = self
		textField.returnKeyType = .done
		textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
		textFieldBackView.addSubview(textField)
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		backView.frame = bounds
		textFieldBackView.bounds = CGRect(x: 0, y: 0, width: width(), height: 54)
		textFieldBackView.setOrigin(x: 0, y: keyboardHeight == 0 ? height() : height() - keyboardHeight - textFieldBackView.height())
		textField.sizeToFit()
		textField.center = CGPoint(x: textFieldBackView.halfWidth(), y: textFieldBackView.halfHeight())
	}
	
	
	func show(content: String?) {
		textField.text = content
		layoutNow()
		textField.becomeFirstResponder()
	}
	
	
	// MARK: - Keyboard Notifications
	@objc func keyboardShow(sender: Notification) {
		guard let userInfo = sender.userInfo else { return }
		guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
		keyboardHeight = keyboardRect.height
		let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
		setNeedsLayout()
		UIView.animate(withDuration: duration) {
			self.layoutIfNeeded()
			self.backView.alpha = 1
		} completion: {
			completed in
			if completed {
				self.isUserInteractionEnabled = true
			}
		}
	}
	
	
	@objc func keyboardHide(sender: Notification) {
		guard let userInfo = sender.userInfo else { return }
		let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
		keyboardHeight = 0
		setNeedsLayout()
		UIView.animate(withDuration: duration) {
			self.layoutIfNeeded()
			self.backView.alpha = 0
		} completion: {
			completed in
			if completed {
				self.isUserInteractionEnabled = false
			}
		}
	}
	
	
	// MARK: - UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		savePipe.input.send(value: textField.text)
		textField.resignFirstResponder()
		return false
	}
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if (textField.text?.count ?? 0) - range.length + string.count <= 0 {
			return false
		}
		return true
	}
	
	
	@objc func textFieldDidChanged(_ textField: UITextField) {
		layoutNow()
		editPipe.input.send(value: textField.text)
	}
}
