import UIKit
import SnapKit

class ParaLabel: UILabel {
    
    convenience init(_ title: String, _ type: ParaType) {
        self.init()
        text = title
        setup(type)
    }
    
    func setup(_ type: ParaType) {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        switch type {
        case .standard:
            font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
            textColor = UIColor.App.Text.text()
            return
        case .doubleStandard:
            font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
            textColor = UIColor.App.Text.text()
        return
        case .centerPageText:
            font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
            textColor = UIColor.App.Text.text()
            textAlignment = NSTextAlignment.center
            setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
        }
    }
    
    enum ParaType {
        case standard, centerPageText, doubleStandard
    }
}
