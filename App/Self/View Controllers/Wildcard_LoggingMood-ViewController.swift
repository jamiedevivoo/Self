import UIKit
import Firebase
import SnapKit

final class WildcardLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Wildcard Question", .largeScreen)
    
    lazy var backButton = IconButton(UIImage(named: "up-circle")!, action: #selector(goBack), .standard)
    
    lazy var wildcardTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Question..."
        textFieldWithLabel.labelTitle = "Describe how your feeling"
        return textFieldWithLabel
    }()
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
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
        wildcardTextFieldWithLabel.textField.placeholder = "I'm Feeling \(moodLogDataCollectionDelegate?.emotion?.adj ?? "")..."
        setupKeyboard()
    }
    
}

// MARK: - Class Methods
extension WildcardLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        guard
            let headline: String = self.wildcardTextFieldWithLabel.textField.text?.trim(),
            self.wildcardTextFieldWithLabel.textField.text!.trim().count > 1
            else { return nil }
        moodLogDataCollectionDelegate?.headline = headline
        wildcardTextFieldWithLabel.resetHint()
        self.wildcardTextFieldWithLabel.textField.text = headline
        return headline
    }
}

// MARK: - TextField Delegate Methods
extension WildcardLoggingMoodViewController: UITextFieldDelegate {
    func setupKeyboard() {
        wildcardTextFieldWithLabel.textField.delegate = self
        self.wildcardTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        view.addGestureRecognizer(tapToTogglekeyboardGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let headline = validateHeadline() {
            wildcardTextFieldWithLabel.textField.resignFirstResponder()
            screenSliderDelegate?.nextScreen()
            moodLogDataCollectionDelegate?.headline = headline
            return true
        } else {
            moodLogDataCollectionDelegate?.headline = nil
            wildcardTextFieldWithLabel.textField.shake()
            wildcardTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters")
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

// MARK: - Buttons
extension WildcardLoggingMoodViewController {
    
    @objc func goBack() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.previousScreen()
    }
}

// MARK: - View Building
extension WildcardLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(wildcardTextFieldWithLabel)
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
        wildcardTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
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
            print(documentSnapshot.data() as AnyObject)
        }
    }
}
