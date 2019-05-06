import UIKit
import SnapKit

class NoActionsView: UIView {
    
    lazy var message: UILabel = HeaderLabel("You've completed all your Challenges for today!",.focusTitle)
    
    lazy var button: UIButton = {
        let button = UIButton.tagButton
        button.setTitle("Unlock todays challenges", for: .normal)
        button.addTarget(nil, action: #selector(ActionsViewController.unlockAction), for: .touchUpInside)
        button.action
        return button
    }()

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
        addSubview(message)
        addSubview(button)
        
        message.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(message.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
}
