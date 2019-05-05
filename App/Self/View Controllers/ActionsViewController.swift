import UIKit
import SnapKit
import Firebase

class ActionsViewController: UIViewController {
    
    // MARK: - Views
    lazy var actionsLabel = ScreenHeaderLabel(title: "Your Actions 🙌")
    
    var actionManager: Actions = Actions().self
    
    lazy var actionButton: UIButton = {
        let button = UIButton.tagButton
        button.setTitle("Open Today's Challenge", for: .normal)
        button.addTarget(nil, action: #selector(ActionsViewController.unlockAction), for: .touchUpInside)
        button.action
        return button
    }()
    var actionLogs: [Actions.Log] = []
  
}

// MARK: - Init
extension ActionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
        configureActionView()
    }
}

extension ActionsViewController {
    func configureActionView() {
        actionManager.user(AccountManager.shared().accountRef!).getActiveActions { actions in
            guard let actions = actions, actions.count > 0 else {
                print("No Selected Action For Today, pick one.")
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

// MARK: - View Building
extension ActionsViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(actionsLabel)
        view.addSubview(actionButton)
    }
    
    func setupChildViews() {
        actionsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(actionsLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}
