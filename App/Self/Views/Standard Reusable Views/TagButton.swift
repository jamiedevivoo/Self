import UIKit

class TagButton: UIButton {
    
    var accountTag: Tag
    
    init(_ tag: Tag) {
        self.accountTag = tag
        super.init(frame: CGRect())

        /// Finish Setup
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagButton {
    func setup() {
        if accountTag.description != nil {
            let image = UIImage(named: "info-circle")
            setImage(image, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
        
        isUserInteractionEnabled = true
        tintColor = UIColor.App.General.blackWhite()
        alpha = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
}
