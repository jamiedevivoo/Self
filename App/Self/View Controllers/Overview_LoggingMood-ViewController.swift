import UIKit
import Firebase
import SnapKit

final class OverviewLoggingMoodViewController: ViewController {
    
    weak var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var moodLoggingDelegate: MoodLoggingDelegate?
    var screenSlider: ScreenSliderViewController?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        label.textColor = UIColor.App.Text.text()
        label.setLineSpacing(lineSpacing: 3)
        return label
    }()
    
    lazy var nameTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textFieldWithLabel.textField.placeholder = "Call me..."
        textFieldWithLabel.labelTitle = "Your name"
        return textFieldWithLabel
    }()
    
    lazy var emotionPickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.App.Text.text()
        label.text = "How are you?"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        return label
    }()
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel()
        label.text = "I am..."
        return label
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a tag..."
        return label
    }()
    
    lazy var describeYourDay: UILabel = {
        let label = UILabel()
        label.text = "Describe your day..."
        return label
    }()
    
    lazy var wildcardQuestion: UILabel = {
        let label = UILabel()
        label.text = "Your Wildcard Question"
        return label
    }()
    
    lazy var tapViewRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
    
}

// MARK: - Override Methods
extension OverviewLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupKeyboard()
    }
    
}

// MARK: - Class Methods
extension OverviewLoggingMoodViewController {
    
    @objc func validateName() -> String? {
        guard
            let name: String = self.nameTextFieldWithLabel.textField.text?.trim(),
            self.nameTextFieldWithLabel.textField.text!.trim().count > 1
            else { return nil }
        
        nameTextFieldWithLabel.resetHint()
        self.nameTextFieldWithLabel.textField.text = name
        return name
    }
    
}

// MARK: - TextField Delegate Methods
extension OverviewLoggingMoodViewController: UITextFieldDelegate {
    
    func setupKeyboard() {
        nameTextFieldWithLabel.textField.delegate = self
        self.nameTextFieldWithLabel.textField.addTarget(self, action: #selector(validateName), for: .editingChanged)
        view.addGestureRecognizer(tapViewRecogniser)
        toggleFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = validateName() {
            nameTextFieldWithLabel.textField.resignFirstResponder()
            dataCollectionDelegate?.setData(["name": name])
            screenSlider?.nextScreen()
            return true
        } else {
            dataCollectionDelegate?.setData(["name": nil])
            nameTextFieldWithLabel.textField.shake()
            nameTextFieldWithLabel.resetHint(withText: "A nickname needs to be at least 2 characters")
        }
        return false
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if nameTextFieldWithLabel.textField.isFirstResponder {
            nameTextFieldWithLabel.textField.resignFirstResponder()
        } else {
            nameTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
    
}

// MARK: - View Building
extension OverviewLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(label)
        self.view.addSubview(nameTextFieldWithLabel)
        label.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        nameTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
    }
    
}

extension OverviewLoggingMoodViewController {
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
