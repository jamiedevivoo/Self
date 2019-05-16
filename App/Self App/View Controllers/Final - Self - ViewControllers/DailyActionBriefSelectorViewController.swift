import UIKit
import SnapKit
import Firebase

final class DailyActionBriefSelectorViewController: ViewController {
    
    // Dependencies & Delegates
    weak var actionManager: ActionManager?
    weak var delegate: ActionSelectorDelegate?

    // MARK: - Views
    lazy var headerLabel = HeaderLabel("Today's Challenges", .smallScreen)
    lazy var subHeaderLabel = HeaderLabel("Tap on the challenge you want to work on today.", .subheader)
    
    lazy var actionCollectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ActionBriefCell.self, forCellWithReuseIdentifier: "Cell")
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
        actionManager!.getDailyActions { actions in
            self.actionsData = actions
            self.actionCollectionView.reloadData()
        }
    }
}

extension DailyActionBriefSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actionsData[indexPath.row]
        delegate?.actionBriefSelected(actionBrief: action)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionBriefCell
        let action = actionsData[indexPath.row]
        cell.actionCardTitleLabel.text = action.title
        cell.completedBy.text = "Completed by \(action.completionCount) users - "
        cell.selectedBy.text = "Selected by \(action.selectionCount) users."
        cell.actionCardDescriptionLabel.text = action.description
        for tag in action.tags {
            let tagButton = Button(title: tag.title, action: nil, type: .tag)
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
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
            make.height.lessThanOrEqualTo(50)
        }
        actionCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(30)
            make.right.left.equalToSuperview().inset(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
