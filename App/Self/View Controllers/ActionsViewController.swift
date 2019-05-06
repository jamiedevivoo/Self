import UIKit
import SnapKit
import Firebase

class ActionsViewController: UIViewController {
    
    // MARK: - Dependencies & Delegates
    var actionManager: ActionManager = ActionManager()
    var accountManager: AccountManager = AccountManager.shared()

    // MARK: - Views
    lazy var headerLabel = HeaderLabel("Your Actions 🙌", .screen)
    
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
    
    lazy var noActionsView = NoActionsView()
    
    // MARK: - Properties
    var actionLogs = [ActionManager.Log]() {
        didSet {
            addActionViews()
            self.actionCollectionView.reloadData()
        }
    }
  
}

// MARK: - Overrides
extension ActionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        configureActionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Class Methods
extension ActionsViewController {
    func configureActionView() {
        actionManager.user(accountManager.accountRef!).getIncompleteActions { actions in
            
            // Check actions were returned
            guard let actions = actions, actions.count > 0 else {
                self.addNoActionsView()
                return
            }
            
            // Check actions aren't completed
            guard let action = actions.first, actions.first?.completed == false else {
                self.addNoActionsView()
                return
            }
            
            // Set actions
            self.actionLogs = [action]
        }
    }
}

// MARK: - Interaction Methods
extension ActionsViewController {
    @objc func unlockAction() {
        print("Clicked Unlick")
        let actionSelectionViewController = DailyActionBriefSelectorViewController()
        actionSelectionViewController.delegate = self
        actionSelectionViewController.actionManager = actionManager
        self.navigationController?.pushViewController(actionSelectionViewController, animated: true)
    }
}

// MARK: - ActionSelectorDelegate Methods
extension ActionsViewController: ActionSelectorDelegate {
    func actionBriefSelected(action: ActionManager.Brief) {
        let action = actionManager.user(accountManager.accountRef!).constructActionLog(fromBrief: action)
        self.actionLogs = [action]
        self.navigationController?.popToRootViewController(animated: true)
        noActionsView.removeFromSuperview()
    }
}

// MARK: - CollectionViewDelegate Methods
extension ActionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actionLog = actionLogs[indexPath.row]
        actionManager.user(accountManager.accountRef!).markLogComplete(actionLog)
        actionLogs.remove(at: indexPath.row)
        addNoActionsView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionLogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionCell
        let action = actionLogs[indexPath.row]
        cell.actionCardTitleLabel.text = action.title
        cell.actionCardDescriptionLabel.text = action.description
        return cell
    }
}

// Mark - Adding Appropriate Views
extension ActionsViewController {
    func addNoActionsView() {
        self.view.addSubview(self.noActionsView)
        noActionsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(300)
        }
    }
    
    func addActionViews() {
        self.view.addSubview(self.actionCollectionView)
        actionCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - View Building
extension ActionsViewController: ViewBuilding {
    
    func setTabBarItem() {
        navigationController?.title = "Actions"
        navigationController?.tabBarItem.image = UIImage(named: "challenge-glyph")
        navigationController?.tabBarItem.badgeValue = ""
    }
    
    func setupChildViews() {
        view.addSubview(headerLabel)
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
    }
}
