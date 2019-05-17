import UIKit
import SnapKit

final class TagCell: UICollectionViewCell {
    static let reuseId = "TagCellReuseId"
    
    var tagObject: Tag?
    var button: UIButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are quicker, easier, more seductive. Not stronger then Code.")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure() {
        guard let tag = tagObject else { return }
        button = TagButton(tag)
        
        guard !button.isDescendant(of: self) else {
            return
        }
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
