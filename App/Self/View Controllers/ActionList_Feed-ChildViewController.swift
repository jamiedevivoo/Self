import UIKit
import SnapKit
import Firebase

class FeedActionListChildViewController: UIViewController {
    
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
    
    lazy var actionHeaderLabel = HeaderLabel("Your Recommended Actions", .section)
    lazy var moodButton = Button(title: "+ Log a mood", action: #selector(FeedActionListChildViewController.logNewMood), type: .dashboard)
    lazy var revealChallengesButton = Button(title: "+ Reveal today's challenges", action: #selector(FeedActionListChildViewController.messageResponse), type: .dashboard)
    lazy var newHighlightButton = Button(title: "+ View new highlight", action: #selector(FeedActionListChildViewController.messageResponse), type: .dashboard)
    lazy var finishAccountButton = Button(title: "Finish Creating Account", action: #selector(FeedActionListChildViewController.finishAccount), type: .dashboard)
    
    
    var accountRef: Account?
    
    init(accountRef: Account) {
        self.accountRef = accountRef
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Init
extension FeedActionListChildViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setupChildViews()
        
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
extension FeedActionListChildViewController {
    @objc func logNewMood() {
        navigationController?.pushViewController(LoggingAMoodScreenSliderViewController(), animated: true)
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
extension FeedActionListChildViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(actionHeaderLabel)

        self.view.addSubview(actionButtonStack)
        self.actionButtonStack.addArrangedSubview(moodButton)
        self.actionButtonStack.addArrangedSubview(revealChallengesButton)
        self.actionButtonStack.addArrangedSubview(newHighlightButton)
    }
    
    func setupChildViews() {
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
