import UIKit

class InductionOnboardingViewController: ViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Placeholder: You've begun a journey to your better self. (cheesy)"
        label.numberOfLines = 0
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    lazy var continueButton = StandardButton(title: "Continue", action: #selector(InductionOnboardingViewController.continueOnboarding), type: .primary)
}

extension InductionOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
    }
}

extension InductionOnboardingViewController {
    @objc func continueOnboarding(_ sender: Any) {
        print("ButtonPressed")
    }
}

extension InductionOnboardingViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(label)
        self.view.addSubview(continueButton)
    }
    
    func setupChildViews() {
        label.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
}
