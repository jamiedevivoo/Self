import UIKit
import SnapKit

class NoHighlightsView: UIView {
    
    lazy var headerLabel: UILabel = HeaderLabel(StaticMessages.get["stateMessage"]["highlight"]["missing"]["title"].stringValue, .centerPageTitle)
    lazy var subHeaderLabel: UILabel = ParaLabel(StaticMessages.get["stateMessage"]["highlight"]["missing"]["text"].stringValue, .centerPageText)

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

extension NoHighlightsView {
    func setupView() {
        setupChildViews()
    }
    
    func setupChildViews() {
        addSubview(headerLabel)
        addSubview(subHeaderLabel)
        
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
    }
}
