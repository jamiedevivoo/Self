import UIKit
import SnapKit
import Firebase

final class HeadlineLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
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
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
}

// MARK: - Override Methods
extension HeadlineLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
        headLineTextFieldWithLabel.textField.placeholder = "I'm Feeling \(moodLogDataCollectionDelegate?.emotion?.adj ?? "")..."
        setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenSliderDelegate?.backwardNavigationEnabled = false
    }
    
}

// MARK: - Class Methods
extension HeadlineLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        
        /// Validation Checks
        guard
            let headline: String = self.headLineTextFieldWithLabel.textField.text?.trim(),
            self.headLineTextFieldWithLabel.textField.text!.trim().count > 1
        /// Return nil if it fails
        else { return nil }
        
        /// If it passes, reset the hint
        headLineTextFieldWithLabel.resetHint(withText: "Press next to continue", for: .info)
        /// Then update the textfield and send the value to the delegate
        self.headLineTextFieldWithLabel.textField.text = headline
        moodLogDataCollectionDelegate?.headline = headline
        /// Finally return the validated value to the caller
        return headline
    }
}

// MARK: - TextField Delegate Methods
extension HeadlineLoggingMoodViewController: UITextFieldDelegate {
    func setupKeyboard() {
        view.addGestureRecognizer(tapToTogglekeyboardGesture)
        headLineTextFieldWithLabel.textField.delegate = self
        headLineTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        headLineTextFieldWithLabel.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let headline = validateHeadline() {
            screenSliderDelegate?.nextScreen()
            moodLogDataCollectionDelegate?.headline = headline
            return true
        } else {
            moodLogDataCollectionDelegate?.headline = nil
            headLineTextFieldWithLabel.textField.shake()
            headLineTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
        }
        return false
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if headLineTextFieldWithLabel.textField.isFirstResponder {
            headLineTextFieldWithLabel.textField.resignFirstResponder()
        } else {
            headLineTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
}

// MARK: - Buttons
extension HeadlineLoggingMoodViewController {
    @objc func goBack() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.previousScreen()
    }
}

// MARK: - View Building
extension HeadlineLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(headLineTextFieldWithLabel)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        headLineTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}
