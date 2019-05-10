import UIKit

final class IconButton: UIButton {
    
    convenience init(_ image: UIImage, action: Selector? = nil, _ type: IconButtonType) {
        self.init()
        
        /// Apply Image
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        
        /// AddAction
        if action != nil {
            addTarget(nil, action: action!, for: .touchUpInside)
        }
        
        /// Finish Setup
        setup(type)
    }
    
    func setup(_ type: IconButtonType) {

        switch type {
        case .standard:
            imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            isUserInteractionEnabled = true
            tintColor = UIColor.white
            alpha = 0.5
            layer.shadowRadius = 3.0
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            addTarget(self, action: #selector(buttonActive), for: .touchDown)
            addTarget(self, action: #selector(buttonActive), for: .touchDragEnter)
            addTarget(self, action: #selector(buttonCancelled), for: .touchDragExit)
            addTarget(self, action: #selector(buttonCancelled), for: .touchCancel)
        return
        }
        
    }
    
    enum IconButtonType {
        case standard
    }
}

extension IconButton {
    
    enum IconButtonPosition {
        case topLeft, topRight, bottomRight, bottomLeft
    }
    
//    func applyConstraints(forPosition position: IconButtonPosition, inView sView: UIView) {
//        switch position {
//        case .topLeft:
//            snp.makeConstraints { make in
//                make.top.equalTo(sView.safeAreaLayoutGuide.snp.top).offset(10)
//                make.left.equalTo(sView.safeAreaLayoutGuide.snp.left).offset(15)
//                make.height.equalTo(40)
//                make.width.equalTo(40)
//            }
//        return
//        case .topRight:
//            snp.makeConstraints { make in
//                make.top.equalTo(sView.safeAreaLayoutGuide.snp.top).offset(20)
//                make.right.equalTo(sView.safeAreaLayoutGuide.snp.right).inset(15)
//                make.height.equalTo(40)
//                make.width.equalTo(40)
//            }
//            return
//        case .bottomRight:
//            return
//        case .bottomLeft:
//            return
//        }
//    }
    
}

// Animation responses
extension IconButton {
    @objc func buttonActive(_ sender: UIButton) {
        focusButton(sender)
    }
    
    @objc func buttonCancelled(_ sender: UIButton) {
        unFocusButton(sender)
    }
    
    func focusButton(_ button: UIButton) {
        let duration = 0.6
        
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
                        button.alpha += 0.2
                        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    func unFocusButton(_ button: UIButton) {
        let duration = 0.4
        
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
                        button.alpha -= 0.2
                        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
