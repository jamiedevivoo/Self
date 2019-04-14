import UIKit

class MessageStackView: UIStackView {
    
    lazy var greetingLabel = UILabel.messageGreeting
    lazy var nameLabel = UILabel.messageName
    lazy var messageTextLabel = UILabel.messageText
    var messageResponseStack: MessageResponsesStack

    init(frame: CGRect, message: Message) {
        self.messageResponseStack = MessageResponsesStack(frame: CGRect.zero, messageResponses: message.actions)
        super.init(frame: frame)
        setupView(withMessage: message)
        addSubviews()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension MessageStackView {
    func addSubviews() {
        addArrangedSubview(greetingLabel)
        addArrangedSubview(nameLabel)
        addArrangedSubview(messageTextLabel)
        addArrangedSubview(messageResponseStack)
    }
    func setupView(withMessage message: Message) {
        axis = .vertical
        spacing = UIStackView.spacingUseSystem
        greetingLabel.text = message.greeting
        nameLabel.text = message.name
        messageTextLabel.text = message.messageText
    }
}
