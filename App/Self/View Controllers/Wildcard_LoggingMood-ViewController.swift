import UIKit
import Firebase
import SnapKit

final class WildcardLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel("Wildcard Question", .largeScreen)
    lazy var questionLabel = HeaderLabel("", .smallScreen)
    
    lazy var wildcardTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Your response..."
        textFieldWithLabel.labelTitle = "There's no right or wrong answers."
        return textFieldWithLabel
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))

    // Properties
    var wildcard: Mood.Wildcard?
}

// MARK: - Override Methods
extension WildcardLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupTextField()
        view.backgroundColor = .clear
        view.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wildcardTextFieldWithLabel.textField.text = dataCollector?.headline
        wildcardTextFieldWithLabel.textField.placeholder = "I'm feeling \(dataCollector?.emotion?.adj ?? "...")"
        
        if validateHeadline() == nil {
            wildcardTextFieldWithLabel.resetHint()
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
            wildcardTextFieldWithLabel.textField.becomeFirstResponder()
        } else {
            screenSliderDelegate?.forwardNavigationEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// If the view is about to dissapear we can resign the first responder
        wildcardTextFieldWithLabel.textField.resignFirstResponder()
    }
}

// MARK: - Class Methods
extension WildcardLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        
        /// Validation Checks
        guard
            let text: String = self.wildcardTextFieldWithLabel.textField.text?.trim(),
            wildcardTextFieldWithLabel.textField.text!.trim().count > 1
            
            /// Return nil if it fails
            else {
                wildcardTextFieldWithLabel.resetHint()
                screenSliderDelegate?.forwardNavigationEnabled = false
                dataCollector?.headline = nil
                return nil
        }
        
        /// If it passes, reset the hint
        wildcardTextFieldWithLabel.resetHint(withText: "✓ Press next when you're ready", for: .info)
        screenSliderDelegate?.forwardNavigationEnabled = true
        
        /// Then update the textfield and send the value to the delegate
        wildcardTextFieldWithLabel.textField.text = text
        dataCollector?.headline = text
        /// Finally return the validated value to the caller
        return text
    }
}

// MARK: - TextField Delegate Methods
extension WildcardLoggingMoodViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard validateHeadline() != nil else {
            dataCollector?.headline = nil
            wildcardTextFieldWithLabel.textField.shake()
            wildcardTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
            return false
        }
        
        screenSliderDelegate?.goToNextScreen()
        return false
    }
    
    func setupTextField() {
        wildcardTextFieldWithLabel.textField.delegate = self
        wildcardTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
    }
}

// Gestures
extension WildcardLoggingMoodViewController {
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
        guard wildcardTextFieldWithLabel.textField.isFirstResponder else {
            wildcardTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        wildcardTextFieldWithLabel.textField.shake()
        wildcardTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters", for: .error)
    }
}

// MARK: - View Building
extension WildcardLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(wildcardTextFieldWithLabel)
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        wildcardTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}

extension WildcardLoggingMoodViewController {
    func getWildcard() {
        let wildcardRef: CollectionReference = Firestore.firestore().collection("wildcards")
        let randomDocumentID = String(Int.random(in: 0..<6))
        
        wildcardRef.document(randomDocumentID).getDocument { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            guard let questionData = documentSnapshot.data()?["question"] else {
                self.screenSliderDelegate?.goToNextScreen()
                return
            }
            self.wildcard = Mood.Wildcard(questionData as! [String: Any])
            self.questionLabel.text = self.wildcard?.question
        }
    }
}
