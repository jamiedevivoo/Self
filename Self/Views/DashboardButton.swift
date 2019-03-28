import UIKit

class DashboardButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        styleButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleButton()
    }

    private func styleButton() {
        self.setTitleColor(UIColor(red: 94/255, green: 86/255, blue: 113/255, alpha: 1), for: .normal)
        self.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 10,bottom: 6,right: 10)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 15
        self.clipsToBounds = false
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0,height: 1.5)
    }
}
