import UIKit
import SnapKit

final class HeaderLabel: UILabel {
    
    convenience init(_ title: String, _ type: HeaderType) {
        self.init()
        text = title
        setup(type)
    }
    
    func setup(_ type: HeaderType) {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        switch type {
        case .smallScreen:
            font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
            textColor = UIColor.App.Text.text()
            return
        case .largeScreen:
            font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
            textColor = UIColor.App.Text.text()
            setLineSpacing(lineSpacing: 3)
            return
        case .section:
            font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
            textColor = UIColor.App.Text.text().withAlphaComponent(0.8)
            return
        case .subheader:
            font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
            textColor = UIColor.App.Text.text()
            return
        case .centerPageTitle:
            font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.black)
            textColor = UIColor.App.Text.text().withAlphaComponent(0.4)
            textAlignment = NSTextAlignment.center
            setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
        case .centerPageText:
            font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
            textColor = UIColor.App.Text.text()
            textAlignment = NSTextAlignment.center
            setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
        }
    }
    
    enum HeaderType {
        case smallScreen, section, subheader, centerPageTitle, centerPageText, largeScreen
    }
    
    func applyDefaultScreenHeaderConstraints(usingVC vc: UIViewController) {
        self.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(38)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
    }
}
