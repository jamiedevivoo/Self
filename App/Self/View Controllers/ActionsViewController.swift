import UIKit
import SnapKit
import Firebase
import Lottie

class ActionsViewController: UIViewController {
    
    // MARK: - Dependencies & Delegates
    var actionManager: ActionManager = ActionManager()
    var accountManager: AccountManager = AccountManager.shared()
    var tagManager: TagManager = TagManager(account: AccountManager.shared().accountRef!)

    // MARK: - Views
    lazy var headerLabel = HeaderLabel("Your Actions 🙌", .smallScreen)
    
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
    
    lazy var loader = Loader(.content)
    lazy var noActionsView = NoActionsView()
    
    // MARK: - Properties
    var actionLogs: [ActionManager.Log] = [] {
        didSet {
            addActionViews()
            actionCollectionView.reloadData()
        }
    }
  
}

// MARK: - Overrides
extension ActionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        configureActionView()
        loader.animation.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.returnedToRootView()
    }
}

// MARK: - Class Methods
extension ActionsViewController {
    func configureActionView() {
        actionManager.user(accountManager.accountRef!).getIncompleteActions { [unowned self] actions in
            
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: [.curveEaseInOut],
                animations: {
                    self.loader.alpha = 0
            }, completion: { [unowned self] _ in
                self.loader.removeFromSuperview()
            
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
                
            })
        }
    }
}

// MARK: - Interaction Methods
extension ActionsViewController {
    @objc func unlockAction() {
        let actionSelectionViewController = DailyActionBriefSelectorViewController()
        actionSelectionViewController.delegate = self
        actionSelectionViewController.actionManager = actionManager
        actionSelectionViewController.modalPresentationStyle = .popover
        modalTransitionStyle = .coverVertical
        definesPresentationContext = true
        navigationController?.pushViewController(actionSelectionViewController, animated: true)
    }
}

// MARK: - ActionSelectorDelegate Methods
extension ActionsViewController: ActionSelectorDelegate {
    func actionBriefSelected(actionBrief: ActionManager.Brief) {
        var brief = actionBrief
        brief.tags = tagManager.updateTag(actionBrief.tags)
        let action = actionManager.user(accountManager.accountRef!).constructActionLog(fromBrief: brief)
        actionLogs.append(action)
        navigationController?.popToRootViewController(animated: true)
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
        noActionsView.alpha = 0
        view.addSubview(noActionsView)
        noActionsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(300)
        }
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut],
            animations: {
                self.noActionsView.alpha = 1
        })
    }
    
    func addActionViews() {
        actionCollectionView.alpha = 0
        view.addSubview(actionCollectionView)
        actionCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut],
            animations: {
                self.actionCollectionView.alpha = 1
        })
    }
}

// MARK: - View Building
extension ActionsViewController: ViewBuilding {
    
    func setTabBarItem() {
        navigationController?.title = nil
        navigationController?.tabBarItem.image = UIImage(named: "play")
    }
    
    func setupChildViews() {
        view.addSubview(headerLabel)
        view.addSubview(loader)
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        loader.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }
    }
}
