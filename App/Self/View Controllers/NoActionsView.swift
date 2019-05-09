import UIKit
import SnapKit

class NoActionsView: UIView {
    lazy var headerLabel: UILabel = HeaderLabel("All done here! 🤘", .centerPageTitle)
    lazy var subHeaderLabel: UILabel = ParaLabel("You've completed all your Challenges for today.", .centerPageText)
    
    lazy var button = Button(title: "Unlock todays challenges", action: #selector(ActionsViewController.unlockAction), type: .tag)

    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
}

extension NoActionsView {
    func setupView() {
        setupChildViews()
    }
    
    func setupChildViews() {
        addSubview(headerLabel)
        addSubview(subHeaderLabel)
        addSubview(button)
        self.bringSubviewToFront(button)
        
        headerLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.left.equalTo(subHeaderLabel.snp.left)
            make.height.greaterThanOrEqualTo(50)
        }
        subHeaderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
            make.width.equalToSuperview()
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
}
