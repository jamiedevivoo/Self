import UIKit

class MessageStackView: UIStackView {
    
    lazy var greetingLabel = SpecialLabel("", .messageGreeting)
    lazy var nameLabel = SpecialLabel("", .messageName)
    lazy var messageTextLabel = SpecialLabel("", .messageText)
    var messageResponseStack: MessageResponsesStack

    init(frame: CGRect, message: (message: Feed.Status.Message, responses: [Feed.Status.Response])) {
        self.messageResponseStack = MessageResponsesStack(frame: CGRect.zero, messageResponses: message.responses)
        super.init(frame: frame)
        setupView(withMessage: message.message)
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
    func setupView(withMessage message: Feed.Status.Message) {
        axis = .vertical
        spacing = UIStackView.spacingUseSystem
        greetingLabel.text = FeedManager.shared().generateGreeting()
        nameLabel.text = AccountManager.shared().accountRef?.user.name
        messageTextLabel.text = message.text
        nameLabel.adjustsFontSizeToFitWidth = true
    }
}
