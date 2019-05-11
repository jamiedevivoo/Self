import UIKit
import Firebase
import SnapKit

final class DiaryLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Add A Note", .largeScreen)
    
    lazy var diaryTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Personal note..."
        textFieldWithLabel.labelTitle = "Make your log more meaningful by adding context."
        return textFieldWithLabel
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))
    
    // Properties
    var wildcard: Mood.Wildcard?
}

// MARK: - Override Methods
extension DiaryLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupTextField()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaryTextFieldWithLabel.textField.text = dataCollector?.headline
        diaryTextFieldWithLabel.textField.placeholder = "I'm feeling \(dataCollector?.emotion?.adj ?? "...")"
        
        if validateHeadline() == nil {
            diaryTextFieldWithLabel.resetHint()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// At this point forward navigation and gestureswping are enabled
        screenSliderDelegate?.backwardNavigationEnabled = true
        screenSliderDelegate?.gestureScrollingEnabled = true
        /// The page indicator is also visible on this page
        screenSliderDelegate?.pageIndicator.isVisible = true
        screenSliderDelegate?.backwardButton.isVisible = true
        screenSliderDelegate?.forwardButton.isVisible = true
        /// Add the tap gesture
        view.addGestureRecognizer(tapGesture)
        /// Finally, once the view has louaded, make the textfield Active if validation fails
        if validateHeadline() == nil {
            screenSliderDelegate?.forwardNavigationEnabled = false
            diaryTextFieldWithLabel.textField.becomeFirstResponder()
        } else {
            screenSliderDelegate?.forwardNavigationEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// If the view is about to dissapear we can resign the first responder
        diaryTextFieldWithLabel.textField.resignFirstResponder()
    }
}

// MARK: - Class Methods
extension DiaryLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        
        /// Validation Checks
        guard
            let text: String = self.diaryTextFieldWithLabel.textField.text?.trim(),
            diaryTextFieldWithLabel.textField.text!.trim().count > 1
            
            /// Return nil if it fails
            else {
                diaryTextFieldWithLabel.resetHint()
                screenSliderDelegate?.forwardNavigationEnabled = false
                dataCollector?.headline = nil
                return nil
        }
        
        /// If it passes, reset the hint
        diaryTextFieldWithLabel.resetHint(withText: "✓ Press next when you're ready", for: .info)
        screenSliderDelegate?.forwardNavigationEnabled = true
        
        /// Then update the textfield and send the value to the delegate
        diaryTextFieldWithLabel.textField.text = text
        dataCollector?.headline = text
        /// Finally return the validated value to the caller
        return text
    }
}

// MARK: - TextField Delegate Methods
extension DiaryLoggingMoodViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard validateHeadline() != nil else {
            dataCollector?.headline = nil
            diaryTextFieldWithLabel.textField.shake()
            diaryTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
            return false
        }
        
        screenSliderDelegate?.goToNextScreen()
        return false
    }
    
    func setupTextField() {
        diaryTextFieldWithLabel.textField.delegate = self
        diaryTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
    }
}


// MARK: - TextField Delegate Methods
extension DiaryLoggingMoodViewController {
}

// Gestures
extension DiaryLoggingMoodViewController {
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
        guard diaryTextFieldWithLabel.textField.isFirstResponder else {
            diaryTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        diaryTextFieldWithLabel.textField.shake()
        diaryTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
    }
}

// MARK: - View Building
extension DiaryLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(diaryTextFieldWithLabel)
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        
        diaryTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}
