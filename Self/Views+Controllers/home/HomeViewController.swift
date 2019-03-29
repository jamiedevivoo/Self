import UIKit
import SnapKit
import Firebase

class HomeViewController: UIViewController {
    
    // MARK: - Views
    lazy var messageView: UIView = {
        let stackView = UIView()
        return stackView
    }()
    
    lazy var messageResponseButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .fillProportionally // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    lazy var actionButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    lazy var actionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Recommended Actions"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = UIColor.app.standard.solidText()
        return label
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = greeting() + ","
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.ultraLight)
        label.textColor = UIColor.app.standard.solidText()
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 46, weight: UIFont.Weight.bold)
        label.textColor = UIColor.app.standard.solidText()
        label.text = user?.name
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
        label.text = "Did you know Mondays are your happiest days? Let’s rock today!"
        label.textColor = UIColor.app.standard.solidText()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var messageResponseOne: UIButton = {
        let button = DashboardButton()
        button.setTitle("💪", for: .normal)
        button.addTarget(self, action: #selector(HomeViewController.logNewMood), for: .touchUpInside)
        return button
    }()
    
    lazy var messageResponseTwo: UIButton = {
        let button = DashboardButton()
        button.setTitle("😔", for: .normal)
        button.addTarget(self, action: #selector(HomeViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    lazy var moodButton: UIButton = {
        let button = DashboardButton()
        button.setTitle("+ Log a mood", for: .normal)
        button.addTarget(self, action: #selector(HomeViewController.logNewMood), for: .touchUpInside)
        return button
    }()
    
    lazy var revealChallengesButton: UIButton = {
        let button = DashboardButton()
        button.setTitle("+ Reveal today's challenges", for: .normal)
        button.addTarget(self, action: #selector(HomeViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    lazy var newHighlightButton: UIButton = {
        let button = DashboardButton()
        button.setTitle("+ View new highlight", for: .normal)
        button.addTarget(self, action: #selector(HomeViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var user: User?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = AccountManager.shared.user
        addSubViews()
        addConstraints()
    }
    
    // MARK: - Functions
    func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 00...01:
            return "Good Night"
        case 01...04:
            return "Good Night"
        case 04...06:
            return "Early Morning"
        case 06...10:
            return "Good Morning"
        case 10...13:
            return "Good Morning"
        case 13...17:
            return "Good Afternoon"
        case 17...22:
            return "Good Evening"
        case 22...24:
            return "Good Night"
        default:
            return "Welcome"
        }
    }
    
    @objc func logNewMood() {
        navigationController?.pushViewController(AddMoodViewController(), animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func messageResponse() {
    }
    
}

// MARK: -
extension HomeViewController: ViewBuilding {
    func addSubViews() {        
        view.addSubview(messageView)
        messageView.addSubview(greetingLabel)
        messageView.addSubview(nameLabel)
        messageView.addSubview(messageLabel)
        
        messageView.addSubview(messageResponseButtonStack)
        messageResponseButtonStack.addArrangedSubview(messageResponseOne)
        messageResponseButtonStack.addArrangedSubview(messageResponseTwo)
        
        view.addSubview(actionButtonStack)
        actionButtonStack.addArrangedSubview(moodButton)
        actionButtonStack.addArrangedSubview(revealChallengesButton)
        actionButtonStack.addArrangedSubview(newHighlightButton)
        
        view.addSubview(actionHeaderLabel)
    }
    
    func addConstraints() {
        messageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalTo(moodButton.snp.top)
        }
            greetingLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalToSuperview()
            }
            nameLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(greetingLabel.snp.bottom).inset(5)
                make.width.equalToSuperview()
            }
            messageLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.width.equalToSuperview()
            }
            messageResponseButtonStack.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.width.equalToSuperview()
            }
        actionButtonStack.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).inset(120)
            make.left.equalTo(20)
            make.width.equalToSuperview()
        }
        actionHeaderLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(actionButtonStack.snp.top).offset(-20)
            make.left.equalToSuperview().offset(20)
        }
    }
}
