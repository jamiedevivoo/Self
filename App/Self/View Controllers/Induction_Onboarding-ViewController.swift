import UIKit
import SnapKit

final class InductionOnboardingViewController: ViewController {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = StaticMessages.get["onboarding"]["induction"]["text"].stringValue
        label.numberOfLines = 0
        label.textColor = UIColor.App.Text.text()
        return label
    }()
    lazy var continueButton = Button(title: "Continue", action: #selector(InductionOnboardingViewController.continueOnboarding), type: .disabled)
    
    weak var delegate: DataCollectionSequenceDelegate?
    
}

// MARK: - Override Methods
extension InductionOnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCompletion()
    }
    
}

// MARK: - Class Methods
extension InductionOnboardingViewController {
    
    func checkCompletion() {
        if delegate!.isDataCollectionComplete() {
            continueButton.setup(.primary)
        } else {
            continueButton.setup(.disabled)
        }
    }
    
    @objc func continueOnboarding(_ sender: Any) {
        delegate?.finishDataCollection()
    }
    
}

// MARK: - View Building
extension InductionOnboardingViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        self.view.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
    
}
