import UIKit
import SnapKit

final class NameOnboardingViewController: ViewController {
    
    // Delegates
    weak var dataCollector: OnboardingDataCollectorDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel("Welcome to Self! What should we call you?", .largeScreen)
    
    lazy var nameTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textFieldWithLabel.textField.placeholder = "Call me..."
        textFieldWithLabel.labelTitle = "Your name"
        return textFieldWithLabel
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))
    
}

// MARK: - Override Methods
extension NameOnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupKeyboard()
        addObservers()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Update the textfield with the latest value
        nameTextFieldWithLabel.textField.text = dataCollector?.name
        /// Revalidate the value and disable or enable navigation accordingly.
        if validateName() == nil {
            screenSliderDelegate?.forwardNavigationEnabled = false
            nameTextFieldWithLabel.resetHint()
        } else {
            screenSliderDelegate?.forwardNavigationEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// At this point forward navigation and gestureswping are enabled
        screenSliderDelegate?.backwardNavigationEnabled = true
        screenSliderDelegate?.gestureScrollingEnabled = true
        /// The page indicator is also visible on this page
        screenSliderDelegate?.pageIndicator.isVisible = true
        /// Add the tap gesture
        view.addGestureRecognizer(tapGesture)
        /// Finally, once the view has louaded, make the textfield Active if validation fails
        if validateName() == nil {
            screenSliderDelegate?.forwardNavigationEnabled = false
            nameTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// If the view is about to dissapear we can resign the first responder
        nameTextFieldWithLabel.textField.resignFirstResponder()
    }
}

// MARK: - Class Methods
extension NameOnboardingViewController {
    
    @objc func validateName() -> String? {
        /// Continuous Validation conditions to check for
        guard
            let name: String = self.nameTextFieldWithLabel.textField.text?.trim(),
            self.nameTextFieldWithLabel.textField.text!.trim().count > 1
            
        /// If validaiton fails, disable forward navigationa nd show the hint
        else {
            nameTextFieldWithLabel.resetHint()
            screenSliderDelegate?.forwardNavigationEnabled = false
            return nil
        }
        /// Otherwise enable navigation and update the field and delegate with the validated version
        screenSliderDelegate?.forwardNavigationEnabled = true
        dataCollector?.name = name
        nameTextFieldWithLabel.textField.text = name
        /// Also display a hint to let the user know they can continue
        nameTextFieldWithLabel.resetHint(withText: "✓ Looks good \(name)! Press next when you're ready")
        return name
    }
}

// MARK: - TextField Delegate Methods
extension NameOnboardingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /// Validate the text before returning
        guard validateName() != nil else {
            /// If validation fails (with the user attempting to return), update the delegates value to nil
            dataCollector?.name = nil
            /// Shake the textfield and update the hint
            nameTextFieldWithLabel.textField.shake()
            nameTextFieldWithLabel.resetHint(withText: "A nickname needs to be at least 2 characters", for: .error)
            /// Then refuse the request to return
            return false
        }
        /// Otherwise, vslidation succeeded so enable forward navigation and go to the next screen
        screenSliderDelegate?.goToNextScreen()
        return true
    }
    
    func setupKeyboard() {
        nameTextFieldWithLabel.textField.delegate = self
        nameTextFieldWithLabel.textField.addTarget(self, action: #selector(validateName), for: .editingChanged)
    }
    
}

// Gestures
extension NameOnboardingViewController {
    @objc func processTap() {
        /// See if the current text validates
        guard validateName() == nil else {
            /// If it does, enable forward navigation and go to the next screen
            screenSliderDelegate?.goToNextScreen()
            return
        }
        /// Disable forward navigation and reset the value since they tried to proceed
        dataCollector?.name = nil
        /// If it fails and the keyboard isn't displayed, show the keyboard
        guard nameTextFieldWithLabel.textField.isFirstResponder else {
            nameTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        nameTextFieldWithLabel.textField.shake()
        nameTextFieldWithLabel.resetHint(withText: "A nickname needs to be at least 2 characters", for: .error)
    }
}

// Observers
extension NameOnboardingViewController {
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        guard let pageIndicator = screenSliderDelegate?.pageIndicator else { return }
        if (pageIndicator.frame.origin.y + pageIndicator.frame.height) > (self.view.frame.height - keyboardFrame.height) {
            screenSliderDelegate?.pageIndicator.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        guard let pageIndicator = screenSliderDelegate?.pageIndicator else { return }
        screenSliderDelegate?.pageIndicator.frame.origin.y = keyboardFrame.height
        if (pageIndicator.frame.origin.y + pageIndicator.frame.height) == (self.view.frame.height - keyboardFrame.height) {
            screenSliderDelegate?.pageIndicator.frame.origin.y -= keyboardFrame.height
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
