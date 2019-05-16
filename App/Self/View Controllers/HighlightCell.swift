import UIKit
import SnapKit

class HighlightCell: UICollectionViewCell {
    
    lazy var actionCardTagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .trailing
        return stack
    }()
    var tags: [UIButton] = []
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.App.Text.text()
        return label
    }()
    
    lazy var actionCardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Go for a walk"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = UIColor.App.Text.text()
        return label
    }()
    
    lazy var actionCardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.text = "Walking is good for you."
        label.textColor = UIColor.App.Text.text()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Setup View
extension HighlightCell {
    private func setupView() {
        addSubViews()
        for tag in tags {
            actionCardTagsStack.addArrangedSubview(tag)
        }
        setupChildViews()
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = UIColor.App.Button.Tag.fill().withAlphaComponent(0.8)
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

// MARK: - View Building
extension HighlightCell: ViewBuilding {
    func addSubViews() {
        contentView.addSubview(actionCardTagsStack)
        contentView.addSubview(actionCardTitleLabel)
        contentView.addSubview(date)
        contentView.addSubview(actionCardDescriptionLabel)
    }
    
    func setupChildViews() {
        actionCardTagsStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(10)
        }
        actionCardTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(actionCardTagsStack.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(10)
        }
        
        date.snp.makeConstraints { (make) in
            make.top.equalTo(actionCardTitleLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(10)
        }
        
        actionCardDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(date.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(10)
        }
    }
}
