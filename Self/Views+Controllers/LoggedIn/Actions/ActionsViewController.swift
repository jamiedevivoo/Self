import UIKit
import SnapKit
import Firebase

class ActionsViewController: UIViewController {
    
    // MARK: - Views
    lazy var actionsLabel = ScreenHeaderLabel(title: "Your Actions 🙌")
    
    lazy var actionCollectionView: UICollectionView = {
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.scrollDirection = .vertical
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
      collectionView.register(ActionCell.self, forCellWithReuseIdentifier: "Cell")
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.backgroundColor = .clear
      return collectionView
    }()

    var actionSnapshots: [DocumentSnapshot] = []

    var actionsData = [String]()
  
}

// MARK: - Init
extension ActionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
        addActions()
    }
    
    func addActions() {
        ActionManager.getActions() { [unowned self] allActions in
//            guard let allActions = allActions else { print("No Actions"); return }
            for action in allActions.documents {
                print(action)
//                let actionCardView = ActionView(actionCardTitleLabel: action.get("title") as! String, actionCardDescriptionLabel: action.get("description") as! String)
                self.actionsData.append(action.documentID)
            }
            self.actionCollectionView.reloadData()
        }
    }
}

extension ActionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: 180)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return actionsData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionCell
    let action = actionsData[indexPath.row]
    cell.titleLable.text = action
    return cell
  }
  
}

// MARK: - View Building
extension ActionsViewController: ViewBuilding {
    func addSubViews() {
        
        view.addSubview(actionsLabel)
        view.addSubview(actionCollectionView)
    }
    
    func addConstraints() {
        actionsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
        actionCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(actionsLabel.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
