import UIKit
import SnapKit
import Firebase

final class HeadlineLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Add A Title", .largeScreen)
    lazy var hintOneLabel = ParaLabel(StaticMessages.get["hint"]["moodTitle"][Int.random(in: 0 ..< StaticMessages.get["hint"]["moodTitle"].count)]["text"].stringValue, .standard)
    
    lazy var headLineTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "I'm feeling..."
        textFieldWithLabel.labelTitle = "Describe how you're feeling"
        return textFieldWithLabel
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))

}

// MARK: - Override Methods
extension HeadlineLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupTextField()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headLineTextFieldWithLabel.textField.text = dataCollector?.headline
        headLineTextFieldWithLabel.textField.placeholder = "I'm feeling \(dataCollector?.emotion?.adj ?? "...")"
        
        if validateHeadline() == nil {
            headLineTextFieldWithLabel.resetHint()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// At this point forward navigation and gestureswping are enabled
        screenSliderDelegate?.backwardNavigationEnabled = false
        screenSliderDelegate?.gestureScrollingEnabled = true
        /// The page indicator is also visible on this page
        screenSliderDelegate?.pageIndicator.isVisible = true
        screenSliderDelegate?.forwardButton.isVisible = true
        UIView.animate(withDuration: 0.3, animations: {
            self.screenSliderDelegate?.backwardButton.alpha = 0.35
            self.screenSliderDelegate?.backwardButton.isEnabled = true
        })
        /// Add the tap gesture
        view.addGestureRecognizer(tapGesture)
        /// Finally, once the view has louaded, make the textfield Active if validation fails
        if validateHeadline() == nil {
            screenSliderDelegate?.forwardNavigationEnabled = false
//            headLineTextFieldWithLabel.textField.becomeFirstResponder()
        } else {
            screenSliderDelegate?.forwardNavigationEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// If the view is about to dissapear we can resign the first responder
        headLineTextFieldWithLabel.textField.resignFirstResponder()
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
            dataCollector?.headline = nil
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
        guard validateHeadline() != nil else {
            dataCollector?.headline = nil
            headLineTextFieldWithLabel.textField.shake()
            headLineTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
            return false
        }
        
        screenSliderDelegate?.goToNextScreen()
        return false
    }
    
    func setupTextField() {
        headLineTextFieldWithLabel.textField.delegate = self
        headLineTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
    }
}

// Gestures
extension HeadlineLoggingMoodViewController {
    @objc func processTap() {
        /// See if the current text validates
        guard validateHeadline() == nil else {
            /// If it does, enable forward navigation and go to the next screen
            screenSliderDelegate?.goToNextScreen()
            return
        }
        /// Disable forward navigation and reset the value since they tried to proceed
        dataCollector?.headline = nil
        /// If it fails and the keyboard isn't displayed, show the keyboard
        guard headLineTextFieldWithLabel.textField.isFirstResponder else {
            headLineTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        headLineTextFieldWithLabel.textField.shake()
        headLineTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
    }
}

// MARK: - View Building
extension HeadlineLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        view.addSubview(headerLabel)
        view.addSubview(headLineTextFieldWithLabel)
        view.addSubview(hintOneLabel)
        hintOneLabel.alpha = 0.5
        hintOneLabel.textAlignment = .left

        hintOneLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-38)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.left.equalToSuperview().offset(30)
            make.height.greaterThanOrEqualTo(30)
        }
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        headLineTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}
