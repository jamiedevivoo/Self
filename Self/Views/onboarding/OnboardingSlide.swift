import UIKit

class OnboardingSlide: UIView {
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var headline: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var desc: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    internal func setupView() {
        backgroundColor = .white
        addSubViews()
        addConstraints()
    }
    
}

extension OnboardingSlide: ViewBuilding {
    
    func addSubViews() {
        backgroundColor = .clear
        addSubview(image)
        addSubview(headline)
        addSubview(desc)
    }
    func addConstraints() {
        image.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(50)
        }
        headline.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(20)
            make.top.equalTo(image.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        desc.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(headline.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
