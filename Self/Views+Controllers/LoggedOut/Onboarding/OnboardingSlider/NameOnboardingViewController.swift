import UIKit

class NameOnboardingViewController: ViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self! What should we call you?"
        return label
    }()
    lazy var nameTextField = StandardTextField(placeholder: "Name", fieldType: .text)
    lazy var continueButton = StandardButton(title: "Continue", action: #selector(NameOnboardingViewController.nextStage), type: .disabled)
}
    
extension NameOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
}

extension NameOnboardingViewController {
    @objc func nextStage(_ sender: Any) {
    }
    @nonobjc func previousStage(_ sender: Any) {
        
    }
}

extension NameOnboardingViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(label)
        self.view.addSubview(nameTextField)
        self.view.addSubview(continueButton)
    }
    
    func addConstraints() {
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.left.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(25)
            make.left.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
    }
}
