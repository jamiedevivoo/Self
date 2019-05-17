//
//import UIKit
//
//class test: UICollectionView {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//}
//
//extension test {
//    
//    func setup() {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .vertical
//        flowLayout.minimumInteritemSpacing = 2
//        flowLayout.minimumLineSpacing = 10
//        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        flowLayout.sectionInsetReference = .fromLayoutMargins
//        
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
//        
//        collectionView.backgroundColor = .clear
//        collectionView.contentInsetAdjustmentBehavior = .always
//        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//    
//}
