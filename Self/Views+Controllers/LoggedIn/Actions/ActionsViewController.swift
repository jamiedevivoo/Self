import UIKit
import SnapKit

class ActionsViewController: UIViewController {
    
    // MARK: - Views
    lazy var actionsLabel = ScreenHeaderLabel(title: "Your Actions 🙌")

    lazy var actions: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var actionsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize.width = 100
        scrollView.contentSize.height = actions.frame.height
        scrollView.bounces = false
        return scrollView
    }()
    lazy var actionCardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()
    
    lazy var actionCardView: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button.tag.fill()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardViewTwo: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button.tag.fill()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardViewThree: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button.tag.fill()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardViewFour: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button.tag.fill()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardViewFive: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button.tag.fill()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardViewSix: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button.tag.fill()
        view.clipsToBounds = true
        return view
    }()
    
}

// MARK: - Init
extension ActionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
}

// MARK: - View Building
extension ActionsViewController: ViewBuilding {
    func addSubViews() {
        
        view.addSubview(actionsLabel)
        view.addSubview(actionsScrollView)
            actionsScrollView.addSubview(actions)
                actions.addSubview(actionCardStack)
                        actionCardStack.addArrangedSubview(actionCardView)
                        actionCardStack.addArrangedSubview(actionCardViewTwo)
                        actionCardStack.addArrangedSubview(actionCardViewThree)
                        actionCardStack.addArrangedSubview(actionCardViewFour)
                        actionCardStack.addArrangedSubview(actionCardViewFive)
                        actionCardStack.addArrangedSubview(actionCardViewSix)
    }
    
    func addConstraints() {
        actionsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
        actionsScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(actionsLabel.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        actions.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
            actionCardStack.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.left.equalToSuperview()
            }
    }
}
