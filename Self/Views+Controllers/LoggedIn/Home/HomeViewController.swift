import UIKit
import SnapKit
import Firebase

class HomeViewController: UIViewController {
    
    lazy var actionListViewController: ActionListViewController = {
        let viewController = ActionListViewController()
        viewController.user = self.user
        add(viewController)
        return viewController
    }()
    
    lazy var messageViewController: MessageViewController = {
        let viewController = MessageViewController()
        viewController.user = self.user
        add(viewController)
        return viewController
    }()
    
    var user: AccountUser?

}

// MARK: - Init
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = AccountManager.shared().account?.user
        addSubViews()
        addConstraints()
    }
}

extension HomeViewController {
    
}

// MARK: - View Building
extension HomeViewController: ViewBuilding {
    
    func addSubViews() {        
        self.view.addSubview(messageViewController.view)
        self.view.addSubview(actionListViewController.view)
    }
    
    func addConstraints() {
        messageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalTo(actionListViewController.view.snp.top).offset(-20)
            make.height.greaterThanOrEqualTo(messageViewController.messageView.snp.height).priority(.required)
        }
        actionListViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(actionListViewController.actionButtonStack.snp.height).offset(50)
        }
    }
}
