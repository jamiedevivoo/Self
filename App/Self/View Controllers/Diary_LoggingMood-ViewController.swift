import UIKit
import Firebase
import SnapKit

final class DiaryLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Add A Note", .largeScreen)
    lazy var hintOneLabel = ParaLabel(StaticMessages.get["hint"]["moodNote"][Int.random(in: 0 ..< 1)]["text"].stringValue, .standard)


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
        diaryTextFieldWithLabel.textField.text = dataCollector?.note?.text
        
        if validateNote() == nil {
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
        if validateNote() == nil {
//            diaryTextFieldWithLabel.textField.becomeFirstResponder()
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
    
    @objc func validateNote() -> String? {
        
        /// Validation Checks
        guard
            let text: String = self.diaryTextFieldWithLabel.textField.text?.trim(),
            diaryTextFieldWithLabel.textField.text!.trim().count > 1
            
            /// Return nil if it fails
            else {
                diaryTextFieldWithLabel.resetHint()
                dataCollector?.note = nil
                return nil
        }
        
        /// If it passes, reset the hint
        diaryTextFieldWithLabel.resetHint(withText: "✓ Press next when you're ready", for: .info)
        
        /// Then update the textfield and send the value to the delegate
        diaryTextFieldWithLabel.textField.text = text
        dataCollector?.note = Note(text: text)
        /// Finally return the validated value to the caller
        return text
    }
}

// MARK: - TextField Delegate Methods
extension DiaryLoggingMoodViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard validateNote() != nil else {
            dataCollector?.note = nil
            diaryTextFieldWithLabel.textField.shake()
            diaryTextFieldWithLabel.resetHint(withText: "Your Note needs to be at least 2 characters", for: .error)
            return false
        }
        
        screenSliderDelegate?.goToNextScreen()
        return false
    }
    
    func setupTextField() {
        diaryTextFieldWithLabel.textField.delegate = self
        diaryTextFieldWithLabel.textField.addTarget(self, action: #selector(validateNote), for: .editingChanged)
    }
}


// MARK: - TextField Delegate Methods
extension DiaryLoggingMoodViewController {
}

// Gestures
extension DiaryLoggingMoodViewController {
    @objc func processTap() {
        /// See if the current text validates
        guard validateNote() == nil else {
            /// If it does, enable forward navigation and go to the next screen
            screenSliderDelegate?.goToNextScreen()
            return
        }
        /// Disable forward navigation and reset the value since they tried to proceed
        dataCollector?.note = nil
        /// If it fails and the keyboard isn't displayed, show the keyboard
        guard diaryTextFieldWithLabel.textField.isFirstResponder else {
            diaryTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        diaryTextFieldWithLabel.textField.shake()
        diaryTextFieldWithLabel.resetHint(withText: "Your note needs to be at least 2 characters", for: .error)
    }
}

// MARK: - View Building
extension DiaryLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(diaryTextFieldWithLabel)
        
        view.addSubview(hintOneLabel)
        hintOneLabel.alpha = 0.5
        hintOneLabel.textAlignment = .left
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        hintOneLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-38)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.left.equalToSuperview().offset(30)
            make.height.greaterThanOrEqualTo(30)
        }
        diaryTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}
