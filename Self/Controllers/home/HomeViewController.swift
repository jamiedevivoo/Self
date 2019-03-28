import UIKit
import SnapKit
import Firebase

class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    let profiles = FirebaseAPI.getProfiles()
    var user: User?

    
    // MARK: - UI and Views
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.primary
        return view
    }()
    
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
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = greeting() + ","
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 46)
        label.text = user?.name
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Did you know Mondays are your happiest days? Let’s rock today!"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var messageActionOne: UIButton = {
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
    
    lazy var messageActionTwo: UIButton = {
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
        button.addTarget(self, action: #selector(HomeViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    lazy var revealChallengesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reveal today's challenges", for: .normal)
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
        button.setTitle("View new highlight", for: .normal)
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
    
    lazy var messageBox: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        
        let circleOnePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwoPath = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePaths = CGMutablePath()
        circlePaths.addPath(circleOnePath.cgPath)
        circlePaths.addPath(circleTwoPath.cgPath)
        
        shapeLayer.fillColor = UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1).cgColor
        shapeLayer.strokeColor = UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.path = circlePaths
        return shapeLayer
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
            return "Night"
        case 01...04:
            return "Night"
        case 04...06:
            return "Early Morning"
        case 06...10:
            return "Good Morning"
        case 10...13:
            return "Good Morning"
        case 13...17:
            return "Afternoon"
        case 17...22:
            return "Evening"
        case 22...24:
            return "Night"
        default:
            return "Welcome"
        }
    }
    
    @objc func logNewMood() {
        
    }
    
    @objc func messageResponse() {
        
    }
    
}

extension HomeViewController: ViewBuilding {
    func addSubViews() {
        view.layer.addSublayer(shapeLayer)
        
        view.addSubview(messageView)
        messageView.addSubview(greetingLabel)
        messageView.addSubview(nameLabel)
        messageView.addSubview(messageLabel)
        
        messageView.addSubview(messageResponseButtonStack)
        messageResponseButtonStack.addArrangedSubview(messageActionOne)
        messageResponseButtonStack.addArrangedSubview(messageActionTwo)
        
        view.addSubview(actionButtonStack)
        actionButtonStack.addArrangedSubview(moodButton)
        actionButtonStack.addArrangedSubview(revealChallengesButton)
        actionButtonStack.addArrangedSubview(newHighlightButton)
    }
    
    func addConstraints() {
        messageView.snp.makeConstraints{ (make) in
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
            make.bottom.equalToSuperview().inset(50)
            make.left.equalTo(20)
            make.width.equalToSuperview()
        }
    }
}
