import UIKit
import Firebase
import SnapKit

final class WildcardLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
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
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
    
    // Properties
    var wildcard: Mood.Wildcard?
}

// MARK: - Override Methods
extension WildcardLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboard()
    }
    
}

// MARK: - Class Methods
extension WildcardLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        /// Validation Checks
        guard
            let wildcardResponse: String = self.wildcardTextFieldWithLabel.textField.text?.trim(),
            self.wildcardTextFieldWithLabel.textField.text!.trim().count > 1
        /// Return nil if it fails
        else { return nil }
        /// If it passes, reset the hint
        wildcardTextFieldWithLabel.resetHint()
        /// Then update the textfield and send the value to the delegate
        wildcard?.answer = wildcardResponse
        wildcardTextFieldWithLabel.textField.text = wildcardResponse
        moodLogDataCollectionDelegate?.wildcard = wildcard
        /// Finally return the validated value to the caller
        return wildcardResponse
    }
}

// MARK: - TextField Delegate Methods
extension WildcardLoggingMoodViewController: UITextFieldDelegate {
    func setupKeyboard() {
        wildcardTextFieldWithLabel.textField.delegate = self
        self.wildcardTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        view.addGestureRecognizer(tapToTogglekeyboardGesture)
        wildcardTextFieldWithLabel.textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let wildcardResponse = validateHeadline() {
            wildcard?.answer = wildcardResponse
            screenSliderDelegate?.goToNextScreen()
            moodLogDataCollectionDelegate?.wildcard = wildcard
            return true
        } else {
            moodLogDataCollectionDelegate?.wildcard = nil
            wildcardTextFieldWithLabel.textField.shake()
            wildcardTextFieldWithLabel.resetHint(withText: "Your response needs to be at least 2 characters", for: .error)
        }
        return false
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if wildcardTextFieldWithLabel.textField.isFirstResponder {
            wildcardTextFieldWithLabel.textField.resignFirstResponder()
        } else {
            wildcardTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
}

// MARK: - View Building
extension WildcardLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(questionLabel)
        self.view.addSubview(wildcardTextFieldWithLabel)
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        questionLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(headerLabel).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        wildcardTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(questionLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
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
            print(self.wildcard)
        }
    }
}
