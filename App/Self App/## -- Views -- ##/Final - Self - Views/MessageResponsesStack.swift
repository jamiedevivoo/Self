import UIKit

final class MessageResponsesStack: UIStackView {
    
    var responseButtons: [UIButton] = []
    
    init(frame: CGRect, messageResponses: [Feed.Status.Response]) {
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
    
    func addActions(usingResponses responses: [Feed.Status.Response]) {
        for action in responses {
            let button = Button(title: action.title, action: action.action, type: .dashboard)
            responseButtons.append(button)
            addArrangedSubview(button)
        }
    }
}
