import UIKit
import SnapKit
import Firebase

class ActionListChildViewController: UIViewController {
    
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
    lazy var moodButton = DashboardButton(title: "+ Log a mood", action: #selector(ActionListChildViewController.logNewMood))
    lazy var revealChallengesButton = DashboardButton(title: "+ Reveal today's challenges", action: #selector(ActionListChildViewController.messageResponse))
    lazy var newHighlightButton = DashboardButton(title: "+ View new highlight", action: #selector(ActionListChildViewController.messageResponse))
    lazy var settingsButton = DashboardButton(title: "Settings", action: #selector(ActionListChildViewController.settings))
    lazy var finishAccountButton = DashboardButton(title: "Finish Creating Account", action: #selector(ActionListChildViewController.finishAccount))
    lazy var logoutButton = DashboardButton(title: "Logout", action: #selector(ActionListChildViewController.logout))

    
    var accountRef: Account?
    
    init(accountRef: Account) {
        self.accountRef = accountRef
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Init
extension ActionListChildViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        addConstraints()
        
        if Auth.auth().currentUser!.isAnonymous {
            self.actionButtonStack.addArrangedSubview(finishAccountButton)
        } else {
            self.finishAccountButton.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser!.isAnonymous {
            self.actionButtonStack.addArrangedSubview(finishAccountButton)
        }
    }
}

// MARK: - Functions
extension ActionListChildViewController {
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
    @objc func finishAccount() {
        navigationController?.pushViewController(FinishCreatingAccountViewController(), animated: true)
    }
    @objc func logout() {
        AccountManager.logout()
    }
}

// MARK: - View Building
extension ActionListChildViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(actionHeaderLabel)

        self.view.addSubview(actionButtonStack)
        self.actionButtonStack.addArrangedSubview(moodButton)
        self.actionButtonStack.addArrangedSubview(revealChallengesButton)
        self.actionButtonStack.addArrangedSubview(newHighlightButton)
        self.actionButtonStack.addArrangedSubview(settingsButton)
        self.actionButtonStack.addArrangedSubview(logoutButton)
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
