import UIKit
import SnapKit

class ActionsViewController: UIViewController {
    
    lazy var actionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Actions 🙌"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.textColor = UIColor.app.solidText()
        return label
    }()
    lazy var actionsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    lazy var actionCardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stack.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stack.isBaselineRelativeArrangement = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = UIStackView.spacingUseSystem
        return stack
    }()
    lazy var actionCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardTagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .trailing
        return stack
    }()
    lazy var actionCardTagButton: UIButton = {
        let button = UIButton()
        button.setTitle("Be Active", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
        button.setTitleColor(UIColor.app.buttonText(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        return button
    }()
    lazy var actionCardTagButtonTwo: UIButton = {
        let button = UIButton()
        button.setTitle("Outdoors", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
        button.setTitleColor(UIColor.app.buttonText(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        return button
    }()
    lazy var actionCardTagButtonThree: UIButton = {
        let button = UIButton()
        button.setTitle("10 mins", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
        button.setTitleColor(UIColor.app.buttonText(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        return button
    }()
    lazy var actionCardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Go for a walk"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = UIColor.app.solidText()
        return label
    }()
    lazy var actionCardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.text = "Walking is good for you."
        label.textColor = UIColor.app.solidText()
        label.numberOfLines = 0
        return label
    }()
    lazy var actionCardStartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.app.solidText(), for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
}

extension ActionsViewController: ViewBuilding {
    func addSubViews() {
        
        view.addSubview(actionsLabel)
        
        view.addSubview(actionsScrollView)
            actionsScrollView.addSubview(actionCardStack)
                actionCardStack.addSubview(actionCardView)
                    actionCardView.addSubview(actionCardTagsStack)
                        actionCardTagsStack.addArrangedSubview(actionCardTagButton)
                        actionCardTagsStack.addArrangedSubview(actionCardTagButtonTwo)
                        actionCardTagsStack.addArrangedSubview(actionCardTagButtonThree)

                    actionCardView.addSubview(actionCardTitleLabel)
                    actionCardView.addSubview(actionCardDescriptionLabel)
                    actionCardView.addSubview(actionCardStartButton)
    }
    
    func addConstraints() {
        actionsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
        actionsScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(actionsLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(80)
        }
            actionCardStack.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
                actionCardView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.greaterThanOrEqualTo(150)
                }
                    actionCardTagsStack.snp.makeConstraints { (make) in
                        make.left.top.equalToSuperview().offset(10)
                        make.right.equalToSuperview().inset(10)
                        make.height.equalTo(30)
                    }
                    actionCardTitleLabel.snp.makeConstraints { (make) in
                        make.top.equalTo(actionCardTagsStack.snp.bottom).offset(20)
                        make.left.equalToSuperview().offset(20)
                        make.width.equalToSuperview().multipliedBy(0.5)
                    }
                    actionCardDescriptionLabel.snp.makeConstraints { (make) in
                        make.top.equalTo(actionCardTitleLabel.snp.bottom).offset(10)
                        make.width.equalTo(actionCardTitleLabel.snp.width)
                        make.left.equalToSuperview().offset(20)
                    }
                    actionCardStartButton.snp.makeConstraints { (make) in
                        make.top.equalTo(actionCardTagsStack.snp.bottom)
                        make.left.equalTo(actionCardTitleLabel.snp.right)
                        make.right.equalToSuperview().inset(20)
                        make.height.equalTo(50)
                        make.centerY.equalTo(actionCardView)
                    }
    }
}
