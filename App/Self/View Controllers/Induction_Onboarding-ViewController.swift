import UIKit
import SnapKit

final class InductionOnboardingViewController: ViewController {

    // Delegates
    weak var dataCollector: OnboardingDataCollectorDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel("Hey...", .largeScreen)
    lazy var paraLabel = ParaLabel(StaticMessages.get["onboarding"]["induction"]["text"].stringValue, .doubleStandard)
    
    lazy var continueButton = Button(title: "Continue", action: #selector(InductionOnboardingViewController.continueOnboarding), type: .primary)
}

// MARK: - Override Methods
extension InductionOnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerLabel.text = "Hi \(dataCollector?.name ?? "...")!"
        screenSliderDelegate?.pageIndicator.isVisible = false
        checkCompletion()
    }
}

// MARK: - Class Methods
extension InductionOnboardingViewController {
    
    func checkCompletion() {
        if dataCollector!.isDataCollectionComplete() {
            continueButton.applyState(.normal)
        } else {
            continueButton.applyState(.disabled)
        }
    }
    
    @objc func continueOnboarding(_ sender: UIButton) {
        dataCollector?.finishDataCollection()
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
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        
        paraLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(50)
        }
        continueButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
    
}
