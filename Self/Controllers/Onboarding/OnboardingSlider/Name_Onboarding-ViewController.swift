import UIKit

class NameOnboardingViewController: ViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self! What should we call you?"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        label.textColor = UIColor.app.text.solidText()
        label.setLineSpacing(lineSpacing: 3)
        return label
    }()
    
    lazy var nameTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textFieldWithLabel.textField.placeholder = "Call me..."
        textFieldWithLabel.labelTitle = "Your name"
        return textFieldWithLabel
    }()
    
    var delegate : OnboardingDelegate?
}

// MARK: - Override Methods
extension NameOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        configureKeyboardBehaviour()
        nameTextFieldWithLabel.textField.delegate = self
        self.nameTextFieldWithLabel.textField.addTarget(self, action: #selector(validateName), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        nameTextFieldWithLabel.textField.becomeFirstResponder()
    }
}

// MARK: - Class Methods
extension NameOnboardingViewController {
    @objc func validateName() -> String? {
        if let name: String = self.nameTextFieldWithLabel.textField.text?.trim(), self.nameTextFieldWithLabel.textField.text!.trim().count > 1 {
            nameTextFieldWithLabel.resetHint()
            self.nameTextFieldWithLabel.textField.text = name
            return name
        } else {
            return nil
        }
    }
}

// MARK: - TextField Delegate Methods
extension NameOnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = validateName() {
            dismissKeyboard()
            delegate?.setData(["name":name])
            return true
        } else {
            nameTextFieldWithLabel.textField.shake()
            nameTextFieldWithLabel.resetHint(withText: "A nickname needs to be at least 2 characters")
        }
        return false
    }
}


// MARK: - View Building
extension NameOnboardingViewController: ViewBuilding {
    func setupChildViews() {
        self.view.addSubview(label)
        self.view.addSubview(nameTextFieldWithLabel)
        label.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        nameTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}
