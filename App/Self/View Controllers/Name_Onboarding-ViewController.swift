import UIKit
import SnapKit

final class NameOnboardingViewController: ViewController {
    
    // Delegates
    weak var dataCollector: OnboardingDataCollectorDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel("Welcome to Self! What should we call you?", .largeScreen)
    
    lazy var nameTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textFieldWithLabel.textField.placeholder = "Call me..."
        textFieldWithLabel.labelTitle = "Your name"
        return textFieldWithLabel
    }()
    
    lazy var tapToToggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
}

// MARK: - Override Methods
extension NameOnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupKeyboard()
        screenSliderDelegate?.forwardNavigationEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextFieldWithLabel.textField.text = dataCollector?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        screenSliderDelegate?.backwardNavigationEnabled = true
        screenSliderDelegate?.liveGestureSwipingEnabled = true
        nameTextFieldWithLabel.textField.becomeFirstResponder()
        screenSliderDelegate?.pageIndicator.isVisible = true
    }
    
}

// MARK: - Class Methods
extension NameOnboardingViewController {
    
    @objc func validateName() -> String? {
        guard
            let name: String = self.nameTextFieldWithLabel.textField.text?.trim(),
            self.nameTextFieldWithLabel.textField.text!.trim().count > 1
        else {
            nameTextFieldWithLabel.resetHint()
            screenSliderDelegate?.forwardNavigationEnabled = false
            return nil
        }
        screenSliderDelegate?.forwardNavigationEnabled = true
        dataCollector?.name = name
        nameTextFieldWithLabel.textField.text = name
        nameTextFieldWithLabel.resetHint(withText: "✓ Ready to go, press next to continue")
        return name
    }
}

// MARK: - TextField Delegate Methods
extension NameOnboardingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if validateName() != nil {
            screenSliderDelegate?.forwardNavigationEnabled = true
            screenSliderDelegate?.goToNextScreen()
            return true
        } else {
            dataCollector?.name = nil
            screenSliderDelegate?.forwardNavigationEnabled = false
            nameTextFieldWithLabel.textField.shake()
            nameTextFieldWithLabel.resetHint(withText: "A nickname needs to be at least 2 characters", for: .error)
        }
        return false
    }
    
    func setupKeyboard() {
        nameTextFieldWithLabel.textField.delegate = self
        nameTextFieldWithLabel.textField.addTarget(self, action: #selector(validateName), for: .editingChanged)
        view.addGestureRecognizer(tapToToggleKeyboard)
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if !nameTextFieldWithLabel.textField.isFirstResponder {
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
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        nameTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
    }
    
}
