import Foundation
import  UIKit

extension UILabel {
    static var messageGreeting: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.ultraLight)
        label.textColor = UIColor.app.text.solidText()
        return label
    }
    static var messageName: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 46, weight: UIFont.Weight.bold)
        label.textColor = UIColor.app.text.solidText()
        return label
    }
    static var messageText: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
        label.textColor = UIColor.app.text.solidText()
        label.numberOfLines = 0
        return label
    }
    
    static var title: UILabel {
        let label = UILabel()
        label.text = "Title"
        return label
    }
    
    static var disabled: UILabel {
        let label = UILabel()
        return label
    }
    
    func updateText() -> UILabel {
        let label = UILabel()
        return label
    }
}
