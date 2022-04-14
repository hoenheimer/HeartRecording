//
//  KickTipsViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2022/4/14.
//

import UIKit

class KickTipsViewController: UIViewController {
    var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    var backButton: UIButton!
    var scrollView: UIScrollView!
    var labels = [UILabel]()
    var topView: UIView!
    var topColorView: UIView!
    var bottomView: UIView!
    var importantView: UIView!
    var importantLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        view.backgroundColor = .white
        
        gradientView = UIView()
        view.addSubview(gradientView)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.color(hexString: "#fbfcff").cgColor, UIColor.color(hexString: "#fff0f0").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.addSublayer(gradientLayer)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "Kick_Close"), for: .normal)
        backButton.reactive.controlEvents(.touchUpInside).observeValues {
            [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(backButton)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        func addBoldLabel(content: String?, superView: UIView = scrollView, color: UIColor = .black, fontSize: CGFloat = 20) {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = content
            label.textColor = color
            label.font = UIFont(name: "Poppins-Bold", size: fontSize)
            superView.addSubview(label)
            labels.append(label)
        }
        
        func addRegularLabel(content: String?, superView: UIView = scrollView) {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = content
            label.textColor = .black
            label.font = UIFont(name: "Poppins-Regular", size: 13)
            superView.addSubview(label)
            labels.append(label)
        }
        
        addBoldLabel(content: "When You'll Feel Your Baby Move")
        addRegularLabel(content: "You Should Start To Feel Your Baby Move Between Around 16 To 24 Weeks Of Pregnancy. If This Is Your First Baby, You Might Not Feel Movements Until After 20 Weeks.\n\nIf You Have Not Felt Your Baby Move By 24 Weeks, Tell Your Midwife. They'll Check Your Baby's Heartbeat And Movements.\n\nYou Should Feel Your Baby Move Right Up To And During Labour.\n\nOther People Cannot Feel Your Baby Move As Early As You Can. When They Can Feel The Movements, By Putting A Hand On Your Bump, Is Different For Everyone.")
        addBoldLabel(content: "What Your Baby's Movements Feel Like")
        addRegularLabel(content: "The Movements Can Feel Like A Gentle Swirling Or Fluttering. As Your Pregnancy Progresses, You May Feel Kicks And Jerky Movements.")
        
        topView = UIView()
        topView.layer.cornerRadius = 24
        topView.layer.masksToBounds = true
        topView.backgroundColor = .white
        scrollView.addSubview(topView)
        
        topColorView = UIView()
        topColorView.backgroundColor = .color(hexString: "#FF4848")
        topView.addSubview(topColorView)
        
        addBoldLabel(content: "Call Your Midwife Or Maternity Unit Immediately If:", superView: topColorView, color: .white, fontSize: 13)
        
        addRegularLabel(content: "·Your Baby Is Moving Less Than Usual", superView: topView)
        addRegularLabel(content: "·You Cannot Feel Your Baby Moving Anymore", superView: topView)
        addRegularLabel(content: "·There Is A Change To Your Baby's Usual Pattern Of Movements", superView: topView)
        addRegularLabel(content: "They'll Need To Check Your Baby's Movements And Heartbeat.\nDo Not Wait Until The Next Day – Call Immediately, Even If It's The Middle Of The Night.",
                        superView: topView)
        
        addBoldLabel(content: "How Often Should Your Baby Move?")
        addRegularLabel(content: "There's No Set Number Of Movements You Should Feel Each Day – Every Baby Is Different.\n\nYou Do Not Need To Count The Number Of Kicks Or Movements You Feel Each Day.\n\nThe Important Thing Is To Get To Know Your Baby's Usual Movements From Day To Day.")
        
        bottomView = UIView()
        bottomView.layer.cornerRadius = 24
        bottomView.backgroundColor = .white
        scrollView.addSubview(bottomView)
        
        importantView = UIView()
        importantView.layer.cornerRadius = 14
        importantView.backgroundColor = .color(hexString: "#ffbc10")
        bottomView.addSubview(importantView)
        
        importantLabel = UILabel()
        importantLabel.text = "Important"
        importantLabel.textColor = .color(hexString: "#171717")
        importantLabel.font = UIFont(name: "Poppins-Medium", size: 13)
        importantView.addSubview(importantLabel)
        
        addRegularLabel(content: "Do Not Use A Home Doppler (Heartbeat Listening Kit) To Try To Check The Baby's Heartbeat Yourself. This Is Not A Reliable Way To Check Your Baby's Health. Even If You Hear A Heartbeat, This Does Not Mean Your Baby Is Well.",
                        superView: bottomView)
        
        addBoldLabel(content: "Why Your Baby's Movements Are Important")
        addRegularLabel(content: "If Your Baby Is Not Well, They Will Not Be As Active As Usual. This Means Less Movement Can Be A Sign Of Infection Or Another Problem.\n\nThe Sooner This Is Found Out The Better, So You And Your Baby Can Be Given The Right Treatment And Care.\n\nThis Could Save Your Baby's Life.")
        addBoldLabel(content: "Can Your Baby Move Too Much")
        addRegularLabel(content: "It's Not Likely Your Baby Can Move Too Much. The Important Thing Is To Be Aware Of Your Baby's Usual Pattern Of Movements.\n\nAny Changes To This Pattern Of Movements Should Be Checked By A Midwife Or Doctor.")
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientView.frame = view.bounds
        gradientLayer.frame = gradientView.bounds
        backButton.sizeToFit()
        backButton.setOrigin(x: 20, y: topSpacing() + 27)
        scrollView.frame = CGRect(x: 0, y: backButton.maxY(), width: view.width(), height: view.height() - backButton.maxY())
        
        var y: CGFloat = 24
        func labelLoadFrame(index: Int, y: CGFloat) -> CGFloat {
            let label = labels[index]
            let size = label.sizeThatFits(CGSize(width: label.superview!.width() - 20 * 2, height: .greatestFiniteMagnitude))
            label.frame = CGRect(x: 20, y: y, width: size.width, height: size.height)
            return label.maxY()
        }
        y = labelLoadFrame(index: 0, y: y)
        y = labelLoadFrame(index: 1, y: y + 10)
        y = labelLoadFrame(index: 2, y: y + 30)
        y = labelLoadFrame(index: 3, y: y + 10)
        
        topView.bounds = CGRect(x: 0, y: 0, width: scrollView.width() - 20 * 2, height: 0)
        topColorView.bounds = CGRect(x: 0, y: 0, width: topView.width(), height: 0)
        var topY: CGFloat = 16
        topY = labelLoadFrame(index: 4, y: topY)
        topColorView.frame = CGRect(x: 0, y: 0, width: topView.width(), height: topY + 17)
        topY = labelLoadFrame(index: 5, y: topY + 34)
        topY = labelLoadFrame(index: 6, y: topY + 8)
        topY = labelLoadFrame(index: 7, y: topY + 8)
        topY = labelLoadFrame(index: 8, y: topY + 8)
        topView.frame = CGRect(x: 20, y: y + 20, width: topView.width(), height: topY + 28)
        y = topView.maxY()
        
        y = labelLoadFrame(index: 9, y: y + 30)
        y = labelLoadFrame(index: 10, y: y + 10)
        
        bottomView.bounds = CGRect(x: 0, y: 0, width: scrollView.width() - 20 * 2, height: 0)
        importantLabel.sizeToFit()
        importantLabel.setOrigin(x: 17, y: 4)
        importantView.frame = CGRect(x: 20, y: 10, width: importantLabel.width() + 17 * 2, height: importantLabel.height() + 4 * 2)
        let bottomY = labelLoadFrame(index: 11, y: importantView.maxY() + 8)
        bottomView.frame = CGRect(x: 20, y: y + 20, width: bottomView.width(), height: bottomY + 20)
        y = bottomView.maxY()
        
        y = labelLoadFrame(index: 12, y: y + 30)
        y = labelLoadFrame(index: 13, y: y + 10)
        y = labelLoadFrame(index: 14, y: y + 30)
        y = labelLoadFrame(index: 15, y: y + 10)
        
        scrollView.contentSize = CGSize(width: scrollView.width(), height: y + bottomSpacing())
    }
}
