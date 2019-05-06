import UIKit
import SnapKit
import Firebase


final class DetailLoggingMoodViewController: ViewController {
    
    weak var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var moodLoggingDelegate: MoodLoggingDelegate?
    var screenSlider: ScreenSliderViewController?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "More Details"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        label.textColor = UIColor.app.text.solidText()
        label.setLineSpacing(lineSpacing: 3)
        return label
    }()
    
    lazy var tagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .trailing
        return stack
    }()
    
    lazy var nameTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textFieldWithLabel.textField.placeholder = "I'm feeling..."
        textFieldWithLabel.labelTitle = "Describe how your feeling"
        return textFieldWithLabel
    }()
    
    lazy var tagTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textFieldWithLabel.textField.placeholder = "Add a Tag..."
        textFieldWithLabel.labelTitle = "What did you do today?"
        return textFieldWithLabel
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
        let lavel = UILabel()
        return label
    }()
    
    lazy var tapViewRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
        
}


// MARK: - Override Methods
extension DetailLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupKeyboard()
        self.view.addGestureRecognizer(tapViewRecogniser)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextFieldWithLabel.textField.placeholder = "I'm Feeling \(moodLoggingDelegate?.emotion?.adj ?? "")?..."
    }
    
}


// MARK: - Class Methods
extension DetailLoggingMoodViewController {
    
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
extension DetailLoggingMoodViewController: UITextFieldDelegate {
    
    func setupKeyboard() {
        nameTextFieldWithLabel.textField.delegate = self
        tagTextFieldWithLabel.textField.delegate = self
        self.tagTextFieldWithLabel.textField.addTarget(self, action: #selector(validateName), for: .editingChanged)
        toggleFirstResponder()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: Remove dangerous assumption
        if let tag = validateName() {
            let button = UIButton()
            button.setTitle(tag, for: .normal)
            tagsStack.addArrangedSubview(button)
            toggleFirstResponder()
            tagTextFieldWithLabel.textField.text = ""
            return true
        } else {
            dataCollectionDelegate?.setData(["name":nil])
            tagTextFieldWithLabel.textField.shake()
            tagTextFieldWithLabel.resetHint(withText: "Tags need to be at least 2 characters")
        }
        return false
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if tagTextFieldWithLabel.textField.isFirstResponder {
            tagTextFieldWithLabel.textField.resignFirstResponder()
        } else {
            tagTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
    
}


// MARK: - View Building
extension DetailLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(label)
        self.view.addSubview(nameTextFieldWithLabel)
        self.view.addSubview(tagsStack)
        self.view.addSubview(tagTextFieldWithLabel)
        self.view.addSubview(wildcardQuestion)

        label.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        nameTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
        tagsStack.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextFieldWithLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(40)
        }
        tagTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagsStack.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
        tagTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagTextFieldWithLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
    }
    
}

/// TEMP
extension DetailLoggingMoodViewController {
    func getWildcard() {
        let wildcardRef:CollectionReference = Firestore.firestore().collection("wildcards")
        let randomDocumentID = String(Int.random(in: 0..<6))
        
        wildcardRef.document(randomDocumentID).getDocument { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            print(documentSnapshot.data() as AnyObject)
            self.wildcardQuestion.text = documentSnapshot.get("question") as? String ?? ""
        }
    }
}
