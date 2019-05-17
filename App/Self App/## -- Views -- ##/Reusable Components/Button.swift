import UIKit

final class Button: UIButton {
    var type: ButtonKind = .primary
    
    convenience init(title: String, action: Selector? = nil, type: ButtonKind = .primary, state: ButtonState = .normal) {
        self.init()

        setTitle(title, for: .normal)
        addAction(action)
        setup(type)
        applyState(state)
    }
}

extension Button {
    private func addAction(_ action: Selector?) {
        addTarget(self, action: #selector(buttonActive), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(buttonCancelled), for: [.touchDragExit, .touchCancel, .touchUpInside])
        if action != nil {
            addTarget(nil, action: action!, for: .touchUpInside)
            print(action!)
        }
    }
}

extension Button {
    
    enum ButtonKind {
        case primary, secondary, dashboard, tag
    }
    
    func setup(_ type: ButtonKind) {
        self.type = type
        layer.cornerRadius = self.layer.bounds.height / 2
        
        switch type {
        case .primary:
            setTitleColor(UIColor.App.Button.Primary.text(), for: .normal)
            backgroundColor = UIColor.App.Button.Primary.fill()
            layer.borderColor = UIColor.App.Button.Primary.fill().withAlphaComponent(0.5).cgColor
            layer.cornerRadius = 30
            isEnabled = true
            return
            
        case .secondary:
            setTitleColor(UIColor.App.Button.Primary.fill(), for: .normal)
            layer.borderColor = UIColor.App.Button.Primary.fill().cgColor
            layer.cornerRadius = 30
            backgroundColor = UIColor.clear
            layer.borderWidth = 2.0
            isEnabled = true
            return

        case .dashboard:
            setTitleColor(UIColor.App.Button.Tag.text(), for: .normal)
            contentEdgeInsets =  UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
            backgroundColor = UIColor.App.Button.Tag.fill().withAlphaComponent(0.8)
            layer.borderWidth = 1.0
            layer.cornerRadius = 15
            clipsToBounds = false
            layer.borderColor = UIColor.App.Button.Tag.fill().cgColor
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 1
            layer.shadowOffset = CGSize(width: 0, height: 1.5)
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
}

// update the state of the button
extension Button {
    
    enum ButtonState {
        case normal, disabled
    }
    
    func applyState(_ state: ButtonState) {
        switch state {
        case .disabled:
            backgroundColor = backgroundColor?.withAlphaComponent(0.5)
            layer.borderColor = layer.borderColor?.copy(alpha: 0.5)
            isEnabled = false
            return
        case .normal:
            setup(self.type)
            isEnabled = true
            return
        }
    }
}

// Animation responses
extension Button {
        
    @objc func buttonActive(_ sender: UIButton) {
        focusButton(sender)
    }
    
    @objc func buttonCancelled(_ sender: UIButton) {
        unFocusButton(sender)
    }
    
    func focusButton(_ button: UIButton) {
        let duration = 0.3
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius += 1.0
        button.layer.shadowOpacity -= 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width + 0.5, height: button.layer.shadowOffset.height + 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha -= 0.2
                        button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    func unFocusButton(_ button: UIButton) {
        let duration = 0.2
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius -= 1.0
        button.layer.shadowOpacity += 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width - 0.5, height: button.layer.shadowOffset.height - 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha += 0.2
                        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
