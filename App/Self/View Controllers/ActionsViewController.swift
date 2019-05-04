import UIKit
import SnapKit
import Firebase

class ActionsViewController: UIViewController {
    
    // MARK: - Views
    lazy var actionsLabel = ScreenHeaderLabel(title: "Your Actions 🙌")
    
    lazy var actionButton: UIButton = {
        let button = UIButton.tagButton
        button.setTitle("Open Today's Challenge", for: .normal)
        button.addTarget(nil, action: #selector(ActionsViewController.unlockAction), for: .touchUpInside)
        button.action
        return button
    }()
  
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
        ActionManager.getSelectedAction() { todaysActions in
            if todaysActions.count > 0 {
                guard let todaysAction = todaysActions.documents.first else { return}
                print("Found an action for today")
                if todaysAction.get("completed") as! Bool == false {
                    print(todaysActions.documents.first?.data() as AnyObject)
                } else {
                    ActionManager.getIncompleteActions() { incompleteActions in
                        print("Today's action was completed, displaying incomplete actions.")
                        dump(incompleteActions.documents)
                    }
                }
            } else {
                print("No Selected Action For Today, pick one.")
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
