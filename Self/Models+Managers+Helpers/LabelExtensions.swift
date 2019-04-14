import Foundation
import  UIKit

extension UILabel {
    static var greeting: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.ultraLight)
        label.textColor = UIColor.app.text.solidText()
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
