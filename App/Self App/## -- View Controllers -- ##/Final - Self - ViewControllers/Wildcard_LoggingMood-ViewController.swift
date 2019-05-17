import UIKit
import Firebase
import SnapKit

final class WildcardLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel("Question Of The Day", .largeScreen)
    lazy var questionLabel = HeaderLabel("", .SmallScreen)
    lazy var hintOneLabel = ParaLabel(StaticMessages.get["hint"]["moodWildcard"][Int.random(in: 0 ..< StaticMessages.get["hint"]["moodWildcard"].count)]["text"].stringValue, .standard)
    
    lazy var wildcardTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Your response..."
        textFieldWithLabel.textField.textColor = UIColor.App.Text.text().withAlphaComponent(0.9)
        textFieldWithLabel.labelTitle = "There's no right or wrong answers."
        return textFieldWithLabel
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))

    // Stored Properties
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
        getWildcard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wildcardTextFieldWithLabel.textField.text = dataCollector?.wildcard?.answer
        
        if validateWildcard() == nil {
            wildcardTextFieldWithLabel.resetHint()
            wildcard?.isComplete = false
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
        if validateWildcard() == nil {
//            wildcardTextFieldWithLabel.textField.becomeFirstResponder()
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
    
    @objc func validateWildcard() -> String? {
        
        /// Validation Checks
        guard
            let text: String = self.wildcardTextFieldWithLabel.textField.text?.trim(),
            wildcardTextFieldWithLabel.textField.text!.trim().count > 1
            
            /// Return nil if it fails
            else {
                wildcardTextFieldWithLabel.resetHint()
                dataCollector?.wildcard = nil
                wildcard?.isComplete = false
                return nil
        }
        
        /// If it passes, reset the hint
        wildcardTextFieldWithLabel.resetHint(withText: "✓ Press next when you're ready", for: .info)
        
        /// Then update the textfield and send the value to the delegate
        wildcardTextFieldWithLabel.textField.text = text
        self.wildcard?.answer = text
        self.wildcard?.isComplete = true
        dataCollector?.wildcard = self.wildcard
        /// Finally return the validated value to the caller
        return text
    }
}

// MARK: - TextField Delegate Methods
extension WildcardLoggingMoodViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard validateWildcard() != nil else {
            dataCollector?.wildcard = nil
            self.wildcard?.isComplete = false
            wildcardTextFieldWithLabel.textField.shake()
            wildcardTextFieldWithLabel.resetHint(withText: "Your response isn't long enough", for: .error)
            return false
        }
        
        screenSliderDelegate?.goToNextScreen()
        return false
    }
    
    func setupTextField() {
        wildcardTextFieldWithLabel.textField.delegate = self
        wildcardTextFieldWithLabel.textField.addTarget(self, action: #selector(validateWildcard), for: .editingChanged)
    }
}

// Gestures
extension WildcardLoggingMoodViewController {
    @objc func processTap() {
        /// See if the current text validates
        guard validateWildcard() == nil else {
            /// If it does, enable forward navigation and go to the next screen
            screenSliderDelegate?.goToNextScreen()
            return
        }
        /// Disable forward navigation and reset the value since they tried to proceed
        dataCollector?.wildcard = nil
        self.wildcard?.isComplete = false
        /// If it fails and the keyboard isn't displayed, show the keyboard
        guard wildcardTextFieldWithLabel.textField.isFirstResponder else {
            wildcardTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        wildcardTextFieldWithLabel.textField.shake()
        wildcardTextFieldWithLabel.resetHint(withText: "Your response isn't long enough", for: .error)
    }
}

// MARK: - View Building
extension WildcardLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(questionLabel)
        self.view.addSubview(wildcardTextFieldWithLabel)
        
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
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(50)
        }
        wildcardTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(questionLabel.snp.bottom).offset(30)
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
            guard var questionData: [String: Any] = documentSnapshot.data(), let _ = documentSnapshot.data()?["question"] else {
                self.screenSliderDelegate?.goToNextScreen()
                return
            }
            questionData["wildcard_ref"] = documentSnapshot.reference
            self.wildcard = Mood.Wildcard(questionData)
            self.questionLabel.text = self.wildcard?.question
            print(self.wildcard as AnyObject)
        }
    }
}
