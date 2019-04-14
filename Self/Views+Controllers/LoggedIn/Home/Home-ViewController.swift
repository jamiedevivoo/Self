import UIKit
import SnapKit
import Firebase

extension HomeViewController: ViewIsDependantOnAccountData { }

class HomeViewController: UIViewController {
    
    lazy var actionListViewController = ActionListChildViewController(accountRef: self.accountRef)
    lazy var messageViewController = MessageChildViewController(accountRef: self.accountRef)

}

// MARK: - Overrides
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
}

// MARK: - View Building
extension HomeViewController: ViewBuilding {
    
    func addSubViews() {
        add(actionListViewController)
        add(messageViewController)
        self.view.addSubview(messageViewController.view)
        self.view.addSubview(actionListViewController.view)
    }
    
    func addConstraints() {
        messageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalTo(actionListViewController.view.snp.top).offset(-20)
            make.height.greaterThanOrEqualTo(messageViewController.messageStackView.snp.height).priority(.required)
        }
        actionListViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(actionListViewController.actionButtonStack.snp.height).offset(50)
        }
    }
}
