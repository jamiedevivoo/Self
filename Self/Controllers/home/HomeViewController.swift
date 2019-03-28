import UIKit
import SnapKit
import Firebase

class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    let profiles = FirebaseAPI.getProfiles()
    var user: User?

    
    // MARK: - UI and Views
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
        label.textColor = .gray
        return label
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = greeting() + ","
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.ultraLight)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 46, weight: UIFont.Weight.bold)
        label.text = user?.name
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
        label.text = "Did you know Mondays are your happiest days? Let’s rock today!"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var messageResponseOne: UIButton = {
        let button = UIButton()
        button.setTitle("💪", for: .normal)
        button.setTitleColor(UIColor(red: 94/255, green: 86/255, blue: 113/255, alpha: 1), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 10,bottom: 6,right: 10)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        button.addTarget(self, action: #selector(HomeViewController.logNewMood), for: .touchUpInside)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)

        return button
    }()
    
    lazy var messageResponseTwo: UIButton = {
        let button = UIButton()
        button.setTitle("😔", for: .normal)
        button.setTitleColor(UIColor(red: 94/255, green: 86/255, blue: 113/255, alpha: 1), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 10,bottom: 6,right: 10)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        button.addTarget(self, action: #selector(HomeViewController.messageResponse), for: .touchUpInside)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        
        return button
    }()
    
    lazy var moodButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Log a mood", for: .normal)
        button.setTitleColor(UIColor(red: 94/255, green: 86/255, blue: 113/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 10,bottom: 6,right: 10)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        button.addTarget(self, action: #selector(HomeViewController.logNewMood), for: .touchUpInside)
        return button
    }()
    
    lazy var revealChallengesButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Reveal today's challenges", for: .normal)
        button.setTitleColor(UIColor(red: 94/255, green: 86/255, blue: 113/255, alpha: 1), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 10,bottom: 6,right: 10)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        button.addTarget(self, action: #selector(HomeViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    lazy var newHighlightButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ View new highlight", for: .normal)
        button.setTitleColor(UIColor(red: 94/255, green: 86/255, blue: 113/255, alpha: 1), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 10,bottom: 6,right: 10)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        button.addTarget(self, action: #selector(HomeViewController.messageResponse), for: .touchUpInside)
        return button
    }()

    // MARK: - Init and ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = AccountManager.shared.user
        self.navigationItem.title = "Home"
        
        addSubViews()
        addConstraints()
    }
    
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
            print("Button Clicked")
        
    }
    
    @objc func messageResponse() {
        
    }
    
}

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
