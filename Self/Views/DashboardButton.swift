import UIKit

class DashboardButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubclass()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubclass()
    }
}

extension DashboardButton: subclassSetup {
    
    convenience init(title:String, action: Selector) {
        self.init()
        setTitle(title, for: .normal)
        addTarget(nil, action: action, for: .touchUpInside)
    }
    
    func setupSubclass() {
        self.setTitleColor(UIColor.app.buttonText(), for: .normal)
        self.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        self.backgroundColor = UIColor.app.button().withAlphaComponent(0.8)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 15
        self.clipsToBounds = false
        self.layer.borderColor = UIColor.app.button().cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0,height: 1.5)
    }
}
