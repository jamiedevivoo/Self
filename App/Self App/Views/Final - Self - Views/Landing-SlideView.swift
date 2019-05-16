import UIKit
import Lottie

final class LandingSlideView: UIView {
    
    lazy var animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.tintColor = UIColor.App.General.blackWhite()
        animationView.loopMode = LottieLoopMode.autoReverse
        return animationView
    }()
    
    lazy var headline: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = UIColor.App.General.blackWhite()
        return label
    }()
    
    lazy var desc: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.App.Text.text()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        setupChildViews()
        backgroundColor = .clear
    }
    
}

extension LandingSlideView: ViewBuilding {
    
    internal func setupChildViews() {
        self.addSubview(animationView)
        self.addSubview(headline)
        self.addSubview(desc)
        animationView.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.centerX.top.equalToSuperview()
        }
        headline.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(animationView.snp.bottom).offset(30)
        }
        desc.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(headline.snp.bottom).offset(15)
        }
    }
}
