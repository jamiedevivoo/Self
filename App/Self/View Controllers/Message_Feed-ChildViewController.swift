import UIKit
import SnapKit

class FeedMessageChildViewController: UIViewController {
    
    var messageStackView: MessageStackView
    
    init(accountRef: Account) {
        let message = FeedManager.shared().generateMessage(
            forAccount: AccountManager.shared(),
            withMoods: [],
            withInsight: [],
            withActions: [],
            withSentimentLogs: [])
        
        self.messageStackView = MessageStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), message: message)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Init
extension FeedMessageChildViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
    }
}

// MARK: - Functions
extension FeedMessageChildViewController {
//    withResponse response: Feed.Status.Response, forMessage message: Feed.Status.Message
    @objc func messageResponse() {
        print("Message Tapped")
    }
}

// MARK: - View Building
extension FeedMessageChildViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(messageStackView)
    }
    
    func setupChildViews() {
        messageStackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalToSuperview()
            make.right.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(100)
        }
    }
}
