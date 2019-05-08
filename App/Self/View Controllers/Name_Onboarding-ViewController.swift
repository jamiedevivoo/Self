import UIKit
import SnapKit

final class NameOnboardingViewController: ViewController {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self! What should we call you?"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        label.textColor = UIColor.App.Text.text()
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
    
    lazy var tapViewRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
    
    weak var delegate: DataCollectionSequenceDelegate?
    
}

// MARK: - Override Methods
extension NameOnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextFieldWithLabel.textField.becomeFirstResponder()
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
        view.addGestureRecognizer(tapViewRecogniser)
        toggleFirstResponder()
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
            nameTextFieldWithLabel.resetHint(withText: "A nickname needs to be at least 2 characters")
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
