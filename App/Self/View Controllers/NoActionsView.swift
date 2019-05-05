import UIKit
import SnapKit

class NoActionsView: UIView {
    
    lazy var message: UILabel = {
        let label = UILabel()
        label.text = "No active chllenge for today"
        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Open todays challenge", for: .normal)
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
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(message.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}
