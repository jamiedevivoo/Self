import UIKit
import SnapKit

class ActionListViewController: UIViewController {
    
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
        label.textColor = UIColor.app.solidText()
        return label
    }()
    
    lazy var moodButton: UIButton = {
        let button = DashboardButton()
        button.setTitle("+ Log a mood", for: .normal)
        button.addTarget(self, action: #selector(ActionListViewController.logNewMood), for: .touchUpInside)
        return button
    }()
    
    lazy var revealChallengesButton: UIButton = {
        let button = DashboardButton()
        button.setTitle("+ Reveal today's challenges", for: .normal)
        button.addTarget(self, action: #selector(ActionListViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    lazy var newHighlightButton: UIButton = {
        let button = DashboardButton()
        button.setTitle("+ View new highlight", for: .normal)
        button.addTarget(self, action: #selector(ActionListViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var user: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        addConstraints()
    }
    
    // MARK: - Functions
    @objc func logNewMood() {
        navigationController?.pushViewController(AddMoodViewController(), animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func messageResponse() {
    }
    
}

extension ActionListViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(actionHeaderLabel)

        self.view.addSubview(actionButtonStack)
        self.actionButtonStack.addArrangedSubview(moodButton)
        self.actionButtonStack.addArrangedSubview(revealChallengesButton)
        self.actionButtonStack.addArrangedSubview(newHighlightButton)
    }
    
    func addConstraints() {
        actionButtonStack.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
        actionHeaderLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(actionButtonStack.snp.top).offset(-20)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
    }
}
