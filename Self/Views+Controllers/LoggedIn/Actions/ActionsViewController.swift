import UIKit
import SnapKit
import Firebase

class ActionsViewController: UIViewController {
    
    // MARK: - Views
    lazy var actionsLabel = ScreenHeaderLabel(title: "Your Actions 🙌")

    lazy var actions: UIView = {
        let view = UIView()
        return view
    }()
    lazy var actionCardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()
    lazy var actionsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize.width = self.view.frame.width
        scrollView.contentSize.height = actions.frame.height
        scrollView.bounces = false
        return scrollView
    }()
    var actionSnapshots: [DocumentSnapshot] = []
    
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
        ActionManager.getActions() { (allActions) -> () in
//            guard let allActions = allActions else { print("No Actions"); return }
            for action in allActions.documents {
                print(action)
                let actionCardView = ActionView(actionCardTitleLabel: action.get("title") as! String, actionCardDescriptionLabel: action.get("description") as! String)
                self.actionCardStack.addArrangedSubview(actionCardView)
            }
            self.actionsScrollView.contentSize.height = self.actions.frame.height
        }
    }
}

// MARK: - View Building
extension ActionsViewController: ViewBuilding {
    func addSubViews() {
        
        view.addSubview(actionsLabel)
        view.addSubview(actionsScrollView)
            actionsScrollView.addSubview(actions)
                actions.addSubview(actionCardStack)
    }
    
    func addConstraints() {
        actionsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
        actionsScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(actionsLabel.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        actions.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
            actionCardStack.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.left.equalToSuperview()
            }
    }
}
