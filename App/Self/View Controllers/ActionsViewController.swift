import UIKit
import SnapKit
import Firebase

class ActionsViewController: UIViewController {
    
    // Dependencies
    var actionManager: Actions = Actions().self

    // MARK: - Views
    lazy var actionsLabel = ScreenHeaderLabel(title: "Your Actions 🙌")
    var actionLogs: [Actions.Log] = []
    lazy var noActionsView = NoActionsView()
  
}

// MARK: - Init
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

extension ActionsViewController {
    func configureActionView() {
        actionManager.user(AccountManager.shared().accountRef!).getIncompleteActions { actions in
            guard let actions = actions, actions.count > 0 else {
                self.addNoChallengesView()
                return
            }

            let action = actions.first
            if action!.completed == true {
                self.actionLogs = [action!]
            }
        }
    }
}


extension ActionsViewController {
    @objc func unlockAction() {
        self.navigationController?.pushViewController(DailyActionSelectorViewController(), animated: true)
    }
}


extension ActionsViewController {
    func addNoChallengesView() {
        self.view.addSubview(self.noActionsView)
        noActionsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(100)
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
        
        view.addSubview(actionsLabel)
        
        actionsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
    }
}
