import UIKit
import SnapKit

class MessageChildViewController: UIViewController {
    
    var messageStackView: MessageStackView
    
    init(accountRef: Account) {
        let message = MessageManager.generateMessage(forAccount: accountRef)
        self.messageStackView = MessageStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), message: message)
        super.init(nibName: nil, bundle: nil)
        print(message)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Init
extension MessageChildViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
    }
}

// MARK: - Functions
extension MessageChildViewController {
    @objc func logNewMood() {
        navigationController?.pushViewController(AddMoodViewController(), animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func messageResponse() {
        
    }
}

// MARK: - View Building
extension MessageChildViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(messageStackView)
    }
    
    func setupChildViews() {
        messageStackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
    }
}
