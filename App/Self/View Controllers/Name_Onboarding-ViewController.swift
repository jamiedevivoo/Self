import UIKit
import SnapKit

final class NameOnboardingViewController: ViewController {
    
    lazy var headerLabel = HeaderLabel("Welcome to Self! What should we call you?", .largeScreen)
    
    lazy var nameTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textFieldWithLabel.textField.placeholder = "Call me..."
        textFieldWithLabel.labelTitle = "Your name"
        return textFieldWithLabel
    }()
    
    lazy var tapToToggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
    
    weak var delegate: DataCollectionSequenceDelegate?
    
}

// MARK: - Override Methods
extension NameOnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameTextFieldWithLabel.textField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameTextFieldWithLabel.textField.resignFirstResponder()
    }
    
}

// MARK: - Class Methods
extension NameOnboardingViewController {
    
    @objc func validateName() -> String? {
        guard
            let name: String = self.nameTextFieldWithLabel.textField.text?.trim(),
            self.nameTextFieldWithLabel.textField.text!.trim().count > 1
            else { return nil }
        
        nameTextFieldWithLabel.resetHint()
        self.nameTextFieldWithLabel.textField.text = name
        return name
    }
    
}

// MARK: - TextField Delegate Methods
extension NameOnboardingViewController: UITextFieldDelegate {
    
    func setupKeyboard() {
        nameTextFieldWithLabel.textField.delegate = self
        self.nameTextFieldWithLabel.textField.addTarget(self, action: #selector(validateName), for: .editingChanged)
        view.addGestureRecognizer(tapToToggleKeyboard)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = validateName() {
            nameTextFieldWithLabel.textField.resignFirstResponder()
            delegate?.setData(["name": name])
            (self.parent as! OnboardingScreenSliderViewController).nextScreen()
            return true
        } else {
            delegate?.setData(["name": nil])
            nameTextFieldWithLabel.textField.shake()
            nameTextFieldWithLabel.resetHint(withText: "A nickname needs to be at least 2 characters", for: .error)
        }
        return false
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if nameTextFieldWithLabel.textField.isFirstResponder {
            nameTextFieldWithLabel.textField.resignFirstResponder()
        } else {
            nameTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
    
}

// MARK: - View Building
extension NameOnboardingViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(nameTextFieldWithLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        nameTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
    }
    
}
