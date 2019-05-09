import UIKit

class Button: UIButton {
    convenience init(title: String, action: Selector? = nil, type: ButtonKind) {
        self.init()
        setTitle(title, for: .normal)
        if action != nil {
            addTarget(nil, action: action!, for: .touchUpInside)
        }
        setup(type)
    }
    
    func setup(_ type: ButtonKind) {
        
        self.layer.cornerRadius = self.layer.bounds.height / 2
        switch type {
            
        case .primary:
            self.backgroundColor = UIColor.App.Button.Primary.fill()
            self.layer.borderColor = UIColor.App.Button.Primary.fill().withAlphaComponent(0.5).cgColor
            self.layer.cornerRadius = 30
            self.isEnabled = true
            return
            
        case .secondary:
            self.setTitleColor(UIColor.App.Button.Primary.fill(), for: .normal)
            self.layer.borderColor = UIColor.App.Button.Primary.fill().cgColor
            self.layer.cornerRadius = 30
            self.backgroundColor = UIColor.clear
            self.layer.borderWidth = 2.0
            self.isEnabled = true
            return
            
        case .disabled:
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
            self.layer.borderColor = self.layer.borderColor?.copy(alpha: 0.5)
            self.isEnabled = false
            return
            
        case .dashboard:
            self.setTitleColor(UIColor.App.Button.Tag.text(), for: .normal)
            self.contentEdgeInsets =  UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
            self.backgroundColor = UIColor.App.Button.Tag.fill().withAlphaComponent(0.8)
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 15
            self.clipsToBounds = false
            self.layer.borderColor = UIColor.App.Button.Tag.fill().cgColor
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.1
            self.layer.shadowRadius = 1
            self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            return
            
        case .tag:
            titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
            setTitleColor(UIColor.App.Button.Tag.text(), for: .normal)
            contentEdgeInsets =  UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
            backgroundColor = UIColor.white.withAlphaComponent(0.3)
            layer.cornerRadius = 15
            clipsToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 1
            layer.shadowOffset = CGSize(width: 0, height: 1.5)
            return
            }
    }

    enum ButtonKind {
        case primary, secondary, disabled, dashboard, tag
    }
}
