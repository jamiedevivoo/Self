import UIKit
import SnapKit

final class ActionLogCell: UICollectionViewCell {
    
    var tags: [Tag] = []
    
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
    
    lazy var tagsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 10
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.sectionInsetReference = .fromContentInset
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
        
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    lazy var note: UILabel = {
        let label = UILabel()
        label.text = "Tap to mark complete."
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = UIColor.App.Text.text()
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
extension ActionLogCell {
    private func setupView() {
        setupChildViews()
        print(tags
        )
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


extension ActionLogCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let referenceHeight: CGFloat = 40 // Approximate height of your cell
        let referenceWidth: CGFloat = 100
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    // MARK: - UICollectionViewDataSource -
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as! TagCell
        cell.tagObject = tags[indexPath.row]
        cell.configure()
        return cell
    }
}

// MARK: - View Building
extension ActionLogCell: ViewBuilding {
    func setupChildViews() {
        contentView.addSubview(tagsCollectionView)
        contentView.addSubview(actionCardTitleLabel)
        contentView.addSubview(actionCardDescriptionLabel)
        contentView.addSubview(note)
        
        tagsCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(20)
        }
        actionCardTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(10)
        }
        actionCardDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(actionCardTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(10)
        }
        note.snp.makeConstraints { (make) in
            make.top.equalTo(actionCardDescriptionLabel.snp.bottom).offset(2)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(10)
        }
    }
}
