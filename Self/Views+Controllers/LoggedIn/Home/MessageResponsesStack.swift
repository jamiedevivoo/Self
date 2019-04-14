import UIKit

class MessageResponsesStack: UIStackView {
    
    init(frame: CGRect, messageResponses: [MessageResponse]) {
        super.init(frame: frame)
        setupView()
        addActions(usingResponses: messageResponses)
    }
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension MessageResponsesStack {
    func setupView() {
        axis = .horizontal
        alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        distribution = .fillProportionally // .fillEqually .fillProportionally .equalSpacing .equalCentering
        spacing = UIStackView.spacingUseSystem
    }
    
    func addActions(usingResponses responses: [MessageResponse]) {
        for action in responses {
            let button = DashboardButton(title: action.title, action: #selector(MessageChildViewController.logNewMood))
            addArrangedSubview(button)
        }
    }
}