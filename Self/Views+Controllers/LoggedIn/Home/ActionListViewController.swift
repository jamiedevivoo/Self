import UIKit
import SnapKit

class ActionListViewController: UIViewController {
    
    lazy var actionButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    lazy var actionHeaderLabel = SectionHeaderLabel(title: "Your Recommended Actions")
    lazy var moodButton = DashboardButton(title: "+ Log a mood", action: #selector(ActionListViewController.logNewMood))
    lazy var revealChallengesButton = DashboardButton(title: "+ Reveal today's challenges", action: #selector(ActionListViewController.messageResponse))
    lazy var newHighlightButton = DashboardButton(title: "+ View new highlight", action: #selector(ActionListViewController.messageResponse))
    lazy var logoutButton = DashboardButton(title: "Logout", action: #selector(ActionListViewController.logout))
    lazy var settingsButton = DashboardButton(title: "Settings", action: #selector(ActionListViewController.settings))

    
    var user: AccountUser?
    
}

// MARK: - Init
extension ActionListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        addConstraints()
    }
}

// MARK: - Functions
extension ActionListViewController {
    @objc func logNewMood() {
        navigationController?.pushViewController(AddMoodViewController(), animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func messageResponse() {
        AccountManager.logout()
    }
    @objc func settings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    @objc func logout() {
        AccountManager.logout()
    }
}

// MARK: - View Building
extension ActionListViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(actionHeaderLabel)

        self.view.addSubview(actionButtonStack)
        self.actionButtonStack.addArrangedSubview(moodButton)
        self.actionButtonStack.addArrangedSubview(revealChallengesButton)
        self.actionButtonStack.addArrangedSubview(newHighlightButton)
        self.actionButtonStack.addArrangedSubview(logoutButton)
        self.actionButtonStack.addArrangedSubview(settingsButton)
    }
    
    func addConstraints() {
        actionHeaderLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(actionButtonStack.snp.top).offset(-20)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        
        actionButtonStack.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
    }
}
