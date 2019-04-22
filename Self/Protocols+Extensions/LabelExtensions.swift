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

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
