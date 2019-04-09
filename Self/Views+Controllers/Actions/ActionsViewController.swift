import UIKit
import SnapKit

class ActionsViewController: UIViewController {
    
    lazy var actionsLabel = ScreenHeaderLabel(title: "Your Actions 🙌")

    lazy var actionsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    lazy var actionCardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stack.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stack.isBaselineRelativeArrangement = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = UIStackView.spacingUseDefault
        return stack
    }()
    
    lazy var actionCardView: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardViewTwo: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button()
        view.clipsToBounds = true
        return view
    }()
    lazy var actionCardViewThree: ActionView = {
        let view = ActionView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.app.button()
        view.clipsToBounds = true
        return view
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
                actionCardStack.addArrangedSubview(actionCardView)
                actionCardStack.addArrangedSubview(actionCardViewTwo)
                actionCardStack.addArrangedSubview(actionCardViewThree)
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
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(80)
        }
            actionCardStack.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
    }
}
