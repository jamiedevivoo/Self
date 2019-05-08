import UIKit
import SnapKit

class NoHighlightsView: UIView {
    
    lazy var headerLabel: UILabel = HeaderLabel("Check back later 👩‍🔬 ...", .centerPageTitle)
    lazy var subHeaderLabel: UILabel = HeaderLabel("Keep using the app to unlock more features like Highlights and Insights.", .centerPageText)

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
