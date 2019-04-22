import UIKit

class InductionOnboardingViewController: ViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Placeholder: You've begun a journey to your better self. (cheesy)"
        label.numberOfLines = 0
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    lazy var continueButton = StandardButton(title: "Continue", action: #selector(InductionOnboardingViewController.continueOnboarding), type: .disabled)
    
    weak var delegate: OnboardingDelegate?
}

// MARK: - Override Methods
extension InductionOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        continueButton.isEnabled = false
        print("viewDidLoad")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCompletion()
        print("ViewDidAppear")
    }
}

// MARK: - Class Methods
extension InductionOnboardingViewController {
    func checkCompletion() {
        if (delegate?.onboardingIsComplete())! {
            continueButton.isEnabled = true
            continueButton.customiseButton(for: .primary)
            print("Complete")
        } else {
            if (delegate?.onboardingIsComplete())! {
                continueButton.isEnabled = false
                continueButton.customiseButton(for: .disabled)
                print("Not Complete")
            }
        }
    }
    @objc func continueOnboarding(_ sender: Any) {
        delegate?.finishOnboarding()
        print("ButtonPressed")
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
