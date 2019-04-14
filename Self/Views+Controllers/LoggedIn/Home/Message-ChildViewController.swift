import UIKit
import SnapKit

class MessageChildViewController: UIViewController {
    
    // FIXME: Will need protection if messengeView height get's too tall (ScrollView)
    
    lazy var messageView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.ultraLight)
        label.textColor = UIColor.app.text.solidText()
        label.text = "Good Morning, "
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = accountRef?.user.name
        label.font = UIFont.systemFont(ofSize: 46, weight: UIFont.Weight.bold)
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
        label.text = message.messageText
        label.textColor = UIColor.app.text.solidText()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var messageResponseButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .fillProportionally // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    var accountRef: Account?
    var message = Message()
    
    init(accountRef: Account) {
        self.accountRef = accountRef
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Init
extension MessageChildViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
        createResponses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = accountRef?.user.name
    }
}

// MARK: - Functions
extension MessageChildViewController {
    func createResponses() {
        guard let messageActions = message.actions else { return }
        for action in messageActions {
            let button = DashboardButton(title: action, action: #selector(MessageChildViewController.logNewMood))
            messageResponseButtonStack.addArrangedSubview(button)
        }
    }
    
    @objc func logNewMood() {
        navigationController?.pushViewController(AddMoodViewController(), animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func messageResponse() {
        
    }
}

// MARK: - View Building
extension MessageChildViewController: ViewBuilding {
    func addSubViews() {
        
        self.view.addSubview(messageView)
            messageView.addArrangedSubview(greetingLabel)
            messageView.addArrangedSubview(nameLabel)
            messageView.addArrangedSubview(messageLabel)
            messageView.addArrangedSubview(messageResponseButtonStack)
    }
    
    func addConstraints() {
        messageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
            greetingLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalToSuperview()
            }
            nameLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalToSuperview()
            }
            messageLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalToSuperview()
            }
            messageResponseButtonStack.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalToSuperview()
            }
    }
}
