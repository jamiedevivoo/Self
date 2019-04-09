import UIKit

class LaunchSlideView: UIView {
    
    let container = UIStackView()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.app.solidText()
        return imageView
    }()
    
    lazy var headline: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.app.solidText()
        return label
    }()
    
    lazy var desc: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.app.solidText()
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

extension LaunchSlideView: ViewBuilding {
    
    func addSubViews() {
        backgroundColor = .clear
        addSubview(container)
        container.addSubview(image)
        container.addSubview(headline)
        container.addSubview(desc)
    }
    func addConstraints() {
        container.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        image.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
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
