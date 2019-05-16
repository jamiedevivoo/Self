import UIKit

final class TagButton: UIButton {
    
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
        if let description = accountTag.description {
            let image = UIImage(named: "info-circle")?.withRenderingMode(.alwaysTemplate)
            setImage(image, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 10, left: (bounds.width - 35), bottom: 10, right: 10)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
            addTarget(self, action: #selector(TagButton.showDescription), for: .touchUpInside)
            imageView?.contentMode = .scaleAspectFit
        }
        
        setTitle(accountTag.title, for: .normal)
        setTitleColor(UIColor.App.General.contrastBlackWhite().withAlphaComponent(0.4), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        imageView?.tintColor = UIColor.App.General.contrastBlackWhite().withAlphaComponent(0.15)
        tintColor = UIColor.App.General.contrastBlackWhite().withAlphaComponent(0.15)
        backgroundColor = UIColor.App.General.blackWhite().withAlphaComponent(0.3)
        
        isUserInteractionEnabled = true
        
        layer.cornerRadius = 20
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
}

extension TagButton {
    @objc func showDescription(_ sender: TagButton) {
        print("Show Description:", sender.accountTag.description)
    }
}
