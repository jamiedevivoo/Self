import UIKit
import SnapKit

class NoHighlightsView: UIView {
    
    lazy var message: UILabel = HeaderLabel("Use the app for a couple more days to unlock Highlights and Insights.",.focusTitle)

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
        addSubview(message)
        
        message.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
