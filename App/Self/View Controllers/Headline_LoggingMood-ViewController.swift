import UIKit
import SnapKit
import Firebase

final class HeadlineLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Add A Title", .largeScreen)
    
    lazy var backButton = IconButton(UIImage(named: "up-circle")!, action: #selector(goBack), .standard)
    
    lazy var headLineTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "I'm feeling..."
        textFieldWithLabel.labelTitle = "Describe how you're feeling"
        return textFieldWithLabel
    }()
    
    lazy var tapToToggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))

}

// MARK: - Override Methods
extension HeadlineLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headLineTextFieldWithLabel.textField.placeholder = "I'm Feeling \(dataCollector?.emotion?.adj ?? "")..."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headLineTextFieldWithLabel.becomeFirstResponder()
        screenSliderDelegate?.pageIndicator.isVisible = true
        screenSliderDelegate?.backwardNavigationEnabled = false
        screenSliderDelegate?.liveGestureSwipingEnabled = true
    }
    
}

// MARK: - Class Methods
extension HeadlineLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        
        /// Validation Checks
        guard
            let text: String = self.headLineTextFieldWithLabel.textField.text?.trim(),
            headLineTextFieldWithLabel.textField.text!.trim().count > 1
            
        /// Return nil if it fails
        else {
            headLineTextFieldWithLabel.resetHint()
            screenSliderDelegate?.forwardNavigationEnabled = false
            return nil
        }
        
        /// If it passes, reset the hint
        headLineTextFieldWithLabel.resetHint(withText: "✓ Press next when you're ready", for: .info)
        screenSliderDelegate?.forwardNavigationEnabled = true
        
        /// Then update the textfield and send the value to the delegate
        headLineTextFieldWithLabel.textField.text = text
        dataCollector?.headline = text
        /// Finally return the validated value to the caller
        return text
    }
}

// MARK: - TextField Delegate Methods
extension HeadlineLoggingMoodViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if validateHeadline() != nil {
            screenSliderDelegate?.forwardNavigationEnabled = true
            screenSliderDelegate?.goToNextScreen()
            return false
        } else {
            dataCollector?.headline = nil
            screenSliderDelegate?.forwardNavigationEnabled = false
            headLineTextFieldWithLabel.textField.shake()
            headLineTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
        }
        return false
    }
    
    func setupTextField() {
        headLineTextFieldWithLabel.textField.delegate = self
        headLineTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        view.addGestureRecognizer(tapToToggleKeyboard)
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if !headLineTextFieldWithLabel.textField.isFirstResponder {
            headLineTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
}

// MARK: - Buttons
extension HeadlineLoggingMoodViewController {
    @objc func goBack() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.goToPreviousScreen()
    }
}

// MARK: - View Building
extension HeadlineLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(headLineTextFieldWithLabel)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(40)
        }
        headLineTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}
