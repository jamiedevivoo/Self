import UIKit

class LaunchScreenSlideView: UIView {
    
    let container = UIView()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.app.text.solidText()
        return imageView
    }()
    
    lazy var headline: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    lazy var desc: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.app.text.solidText()
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

extension LaunchScreenSlideView: ViewBuilding {
    
    func addSubViews() {
        backgroundColor = .clear
        addSubview(container)
        container.addSubview(image)
        container.addSubview(headline)
        container.addSubview(desc)
    }
    func addConstraints() {
        container.snp.makeConstraints { (make) in
            make.bottom.top.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
            image.snp.makeConstraints { (make) in
                make.width.height.equalTo(80)
                make.centerX.top.equalToSuperview()
            }
            headline.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.top.equalTo(image.snp.bottom).offset(30)
            }
            desc.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.top.equalTo(headline.snp.bottom).offset(15)
            }
    }
}
