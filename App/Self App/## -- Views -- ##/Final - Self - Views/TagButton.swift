import UIKit
import SnapKit

final class TagButton: UIButton {
    
    var accountTag: Tag
    
    private lazy var infoIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "info-circle")?.withRenderingMode(.alwaysTemplate)
        print("making info")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
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
        if let _ = accountTag.description {
            print("adding info")
            addSubview(infoIcon)
            infoIcon.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(5)
                make.height.width.equalTo(10)
                make.centerX.equalToSuperview()
            }
            infoIcon.addTarget(self, action: #selector(self.showDescription), for: .touchUpInside)
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
        print("Show Description:", sender.accountTag.description ?? "Sorry, the description isn't available")
    }
}
