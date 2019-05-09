import UIKit
import SnapKit

final class InductionOnboardingViewController: ViewController {
    
    lazy var headerLabel = HeaderLabel("Hey Jamie...", .largeScreen)
    lazy var paraLabel = ParaLabel(StaticMessages.get["onboarding"]["induction"]["text"].stringValue, .standard)
    
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
    
    @objc func continueOnboarding(_ sender: UIButton) {
        delegate?.finishDataCollection()
        sender.isEnabled = false

    }
    
}

// MARK: - View Building
extension InductionOnboardingViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(paraLabel)
        self.view.addSubview(continueButton)
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        
        paraLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(paraLabel.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
    
}
