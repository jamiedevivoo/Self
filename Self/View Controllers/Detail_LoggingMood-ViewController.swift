import UIKit
import SnapKit


final class DetailLoggingMoodViewController: ViewController {
    
    var dataCollectionDelegate: DataCollectionSequenceDelegate?
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
        
}


// MARK: - Override Methods
extension DetailLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


// MARK: - Class Methods
extension DetailLoggingMoodViewController {
    
    @objc func validateName() -> String? {
        guard
            let name: String = self.tagTextFieldWithLabel.textField.text?.trim(),
            self.tagTextFieldWithLabel.textField.text!.trim().count > 1
            else { return nil }
        
        tagTextFieldWithLabel.resetHint()
        self.tagTextFieldWithLabel.textField.text = name
        return name
    }
    
}


// MARK: - TextField Delegate Methods
extension DetailLoggingMoodViewController: UITextFieldDelegate {
    
    func setupKeyboard() {
        tagTextFieldWithLabel.textField.delegate = self
        self.tagTextFieldWithLabel.textField.addTarget(self, action: #selector(validateName), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        tagsStack.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextFieldWithLabel.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
        tagTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagsStack.snp.bottom).offset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
    }
    
}
