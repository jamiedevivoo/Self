import UIKit
import SnapKit

class ActionCell: UICollectionViewCell {
  
  lazy var titleLable: UILabel = {
    return UILabel()
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .lightGray
    contentView.addSubview(titleLable)
    titleLable.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(20)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
  }
  
  
  
}
