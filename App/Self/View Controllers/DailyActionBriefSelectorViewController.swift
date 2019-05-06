import UIKit
import SnapKit
import Firebase

class DailyActionBriefSelectorViewController: ViewController {
    
    // Dependencies & Delegates
    weak var actionManager: ActionManager?
    weak var delegate: ActionSelectorDelegate?

    // MARK: - Views
    lazy var headerLabel = HeaderLabel("Today's Challenges", type: .screen)
    lazy var subHeaderLabel = HeaderLabel("Tap on the challenge you want to work on today.", type: .subheader)
    
    lazy var actionCollectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ActionCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
var actionsData: [ActionManager.Brief] = []
    
}

// MARK: - Init
extension DailyActionBriefSelectorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        addActions()
    }
    
    func addActions() {
        actionManager!.getDailyActions() { actions in
            self.actionsData = actions
            self.actionCollectionView.reloadData()
        }
    }
}

extension DailyActionBriefSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actionsData[indexPath.row]
        delegate?.actionBriefSelected(action: action)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionCell
        let action = actionsData[indexPath.row]
        cell.actionCardTitleLabel.text = action.title
        cell.actionCardDescriptionLabel.text = action.description
        for tag in action.tags {
            let tagButton = UIButton.tagButton
            tagButton.setTitle(tag.title, for: .normal)
            cell.tags.append(tagButton)
        }
        return cell
    }
    
}

// MARK: - View Building
extension DailyActionBriefSelectorViewController: ViewBuilding {
    func setupChildViews() {
        
        view.addSubview(headerLabel)
        view.addSubview(subHeaderLabel)
        view.addSubview(actionCollectionView)
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)

        subHeaderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
        actionCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
