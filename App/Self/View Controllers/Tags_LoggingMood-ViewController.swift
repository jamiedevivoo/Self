import UIKit
import SnapKit
import Firebase

final class TagsLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Tag Your Log", .largeScreen)
    
    lazy var tagTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Tag name ..."
        textFieldWithLabel.labelTitle = "For example, what have you done today?"
        return textFieldWithLabel
    }()
    
    lazy var tagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .trailing
        return stack
    }()
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
}

// MARK: - Override Methods
extension TagsLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagTextFieldWithLabel.textField.placeholder = "A tag for \(moodLogDataCollectionDelegate?.headline ?? "")..."
        screenSliderDelegate?.backwardNavigationEnabled = true
        setupKeyboard()
    }
    
}

// MARK: - Class Methods
extension TagsLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        guard
            let headline: String = self.tagTextFieldWithLabel.textField.text?.trim(),
            self.tagTextFieldWithLabel.textField.text!.trim().count > 1
            else { return nil }
        moodLogDataCollectionDelegate?.headline = headline
        tagTextFieldWithLabel.resetHint(withText: "Press next to add tag", for: .info)
        tagTextFieldWithLabel.textField.returnKeyType = UIReturnKeyType.next
        return headline
    }
}

// MARK: - TextField Delegate Methods
extension TagsLoggingMoodViewController: UITextFieldDelegate {
    func setupKeyboard() {
        tagTextFieldWithLabel.textField.delegate = self
        self.tagTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        view.addGestureRecognizer(tapToTogglekeyboardGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tag = validateHeadline() {
            let button = UIButton()
            button.setTitle(tag, for: .normal)
            tagsStack.addArrangedSubview(button)
            textField.text = nil
            tagTextFieldWithLabel.textField.placeholder = "Another tag..."
            tagTextFieldWithLabel.resetHint(withText: "Press next again to save", for: .info)
            tagTextFieldWithLabel.textField.returnKeyType = UIReturnKeyType.continue
            moodLogDataCollectionDelegate?.tags.append(tag)
            return true
        } else {
            
            // If the user has already added at least one tag, let them proceed with an error
            if moodLogDataCollectionDelegate?.tags.count ?? 0 > 0 {
                tagTextFieldWithLabel.textField.resignFirstResponder()
                screenSliderDelegate?.nextScreen()
                return true
            }
            
            tagTextFieldWithLabel.textField.shake()
            tagTextFieldWithLabel.resetHint(withText: "Your log needs at least 1 tag", for: .error)
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
extension TagsLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(tagTextFieldWithLabel)
        self.view.addSubview(tagsStack)
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        tagTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
        tagsStack.snp.makeConstraints { (make) in
            make.top.equalTo(tagTextFieldWithLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(40)
        }
    }
}
