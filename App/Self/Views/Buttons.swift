import UIKit

extension UIButton {
    static var tagButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
        button.setTitleColor(UIColor.app.button.tag.text(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        return button
    }()
}
