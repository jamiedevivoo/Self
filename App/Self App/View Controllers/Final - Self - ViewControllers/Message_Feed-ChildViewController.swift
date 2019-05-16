import UIKit
import SnapKit

final class FeedMessageChildViewController: UIViewController {
    
    var messageStackView: MessageStackView
    
    init(accountRef: Account) {
        let message = FeedManager.shared().generateMessage(
            forAccount: AccountManager.shared(),
            withMoods: [],
            withInsight: [],
            withActions: [],
            withSentimentLogs: [])
        
        self.messageStackView = MessageStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), message: message)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Init
extension FeedMessageChildViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
    }
}

// MARK: - Functions
extension FeedMessageChildViewController {
//    withResponse response: Feed.Status.Response, forMessage message: Feed.Status.Message
    @objc func messageResponse(sender: UIButton) {
        print("Message Tapped")

        
//        let animation: CABasicAnimation = {
//            let animate = CABasicAnimation
//            return animate
//        }()
        
        for button in messageStackView.messageResponseStack.responseButtons.filter({$0 != sender}) {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.beginFromCurrentState],
                animations: {
                    button.alpha = 0
            })
        }
        
//        let buttonAnimation: CAAnimationGroup = {
//            let animations = CAAnimationGroup()
//
//            let transformAnimation = CABasicAnimation(keyPath: "transform")
//            transformAnimation.fromValue = CATransform3DMakeScale(1, 1, 1)
//            transformAnimation.toValue = CATransform3DMakeScale(1.1, 1.1, 1)
//            transformAnimation.autoreverses = true
//            transformAnimation.duration = 0.2
//
//            let positionAnimation = CABasicAnimation(keyPath: "frame.origin.y")
//            positionAnimation.fromValue = sender.frame.origin.y
//            positionAnimation.toValue = sender.frame.origin.y + 10
//            positionAnimation.autoreverses = true
//            positionAnimation.duration = 0.2
//
//            let backgroundOpacityAnimation = CABasicAnimation(keyPath: "backgroundColor")
//            backgroundOpacityAnimation.fromValue = 1
//            backgroundOpacityAnimation.toValue = 0
//            backgroundOpacityAnimation.duration = 0.2
//
//            let borderOpacityAnimation = CABasicAnimation(keyPath: "layer.borderColor")
//            borderOpacityAnimation.fromValue = sender.layer.borderColor!
//            borderOpacityAnimation.toValue = UIColor(cgColor: sender.layer.borderColor!).withAlphaComponent(0).cgColor
//            borderOpacityAnimation.duration = 0.2
//
//            animations.animations = [transformAnimation, positionAnimation, backgroundOpacityAnimation, borderOpacityAnimation]
//            animations.duration = 0.2
//            animations.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//            animations.repeatCount = 1
//
//            return animations
//        }()
//
//        sender.layer.add(buttonAnimation, forKey: nil)
        sender.removeTarget(nil, action: #selector(Button.buttonCancelled), for: .touchUpInside)
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut, .layoutSubviews, .autoreverse],
            animations: {
                sender.frame.origin.y -= 10
                sender.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion: { completed in
                sender.frame.origin.y += 10
                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                guard completed else { return }
                sender.isEnabled = false
                UIView.animate(withDuration: 0.3) {
                    sender.frame.origin.x = 0
                }
        })
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut, .layoutSubviews],
            animations: {
                sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(0)
        })
    }
}

// MARK: - View Building
extension FeedMessageChildViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(messageStackView)
    }
    
    func setupChildViews() {
        messageStackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalToSuperview()
            make.right.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(100)
        }
    }
}
