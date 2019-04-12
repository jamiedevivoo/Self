import UIKit

class NameOnboardingViewController: ViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self! What should we call you?"
        label.numberOfLines = 0
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    lazy var nameTextField = StandardTextField(placeholder: "Name", fieldType: .text)
    lazy var continueButton = StandardButton(title: "Continue", action: #selector(NameOnboardingViewController.continueOnboarding), type: .disabled)
}
    
extension NameOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
}

extension NameOnboardingViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if nameTextField.text == "" {
            print("Wrong")
            continueButton.isEnabled = false
            continueButton.customiseButton(for: .disabled)
        } else {
            print("RIGHT")
            continueButton.isEnabled = true
            continueButton.customiseButton(for: .primary)
        }
    }
    @objc func continueOnboarding(_ sender: Any) {
        print("ButtonPressed")
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
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(100)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}
