import UIKit
import SnapKit

final class SpecialLabel: UILabel {
    
    convenience init(_ title: String, _ type: LabelType) {
        self.init()
        text = title
        setup(type)
    }
    
    func setup(_ type: LabelType) {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        switch type {
        case .messageGreeting:
            font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.ultraLight)
            textColor = UIColor.App.Text.text()
            return
        case .messageName:
            font = UIFont.systemFont(ofSize: 46, weight: UIFont.Weight.bold)
            textColor = UIColor.App.Text.text()
            return
        case .messageText:
            font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
            textColor = UIColor.App.Text.text()
            numberOfLines = 0
            return
        }
    }
    
    enum LabelType {
        case messageGreeting, messageName, messageText
    }
}
