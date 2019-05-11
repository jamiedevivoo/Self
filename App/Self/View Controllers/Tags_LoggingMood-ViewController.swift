import UIKit
import SnapKit
import Firebase

final class TagsLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Tag Your Log", .largeScreen)
    lazy var forwardButton = IconButton(UIImage(named: "down-circle")!, action: #selector(goForward), .standard)
    
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
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))
}

// MARK: - Override Methods
extension TagsLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
        setupTextfield()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagTextFieldWithLabel.textField.placeholder = "A tag for \(moodLogDataCollectionDelegate?.headline ?? "")..."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenSliderDelegate?.backwardNavigationEnabled = true
        screenSliderDelegate?.forwardNavigationEnabled = false
//        tagTextFieldWithLabel.textField.becomeFirstResponder()
//        becomeFirstResponder()
    }
    
}

// MARK: - Class Methods
extension TagsLoggingMoodViewController {
    
    @objc func validateTagName() -> String? {
        /// Validation Checks
        guard
            let tag: String = self.tagTextFieldWithLabel.textField.text?.trim(),
            self.tagTextFieldWithLabel.textField.text!.trim().count > 1
        /// Return nil if it fails
        else {
            forwardButton.isHidden = false
            return nil
        }
        
        /// If it passes, reset the hint and show the next button
        tagTextFieldWithLabel.resetHint(withText: "Press next to add tag", for: .info)
        configureForwardButtonPosition()
        forwardButton.isHidden = false
        /// Then update the textfield
        moodLogDataCollectionDelegate?.tags.append(tag)
        tagTextFieldWithLabel.textField.returnKeyType = UIReturnKeyType.next
        /// Finally return the validated value to the caller
        return tag
    }

//    func createTag(tagName: String) -> Tag {
//        return Tag()
//    }
    
    func createTagButton(tagName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(tagName, for: .normal)
        button.addTarget(nil, action: #selector(removeTag), for: .touchUpInside)
        tagsStack.addArrangedSubview(button)
        return button
    }
    
    @objc func removeTag(sender: UIButton) {
        sender.removeFromSuperview()
    }
}

// MARK: - TextField Delegate Methods
extension TagsLoggingMoodViewController: UITextFieldDelegate {
    func setupTextfield() {
        tagTextFieldWithLabel.textField.delegate = self
        self.tagTextFieldWithLabel.textField.addTarget(self, action: #selector(validateTagName), for: .editingChanged)
    }

//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tagName = validateTagName() {
            let tag = createTagButton(tagName: tagName)
            textField.text = nil
            tagTextFieldWithLabel.textField.placeholder = "Another tag..."
            tagTextFieldWithLabel.resetHint(withText: "Press next again to save", for: .info)
            tagTextFieldWithLabel.textField.returnKeyType = UIReturnKeyType.continue
            moodLogDataCollectionDelegate?.tags.append(tag.titleLabel!.text!)
            return true
        } else {
            
            // If the user has already added at least one tag, let them proceed with an error
            if moodLogDataCollectionDelegate?.tags.count ?? 0 > 0 {
                screenSliderDelegate?.goToNextScreen()
                return true
            }
            
            tagTextFieldWithLabel.textField.shake()
            tagTextFieldWithLabel.resetHint(withText: "Your log needs at least 1 tag (2 characters)", for: .error)
        }
        return false
    }
    
    @objc func processTap() {
        if !tagTextFieldWithLabel.textField.isFirstResponder {
            tagTextFieldWithLabel.textField.becomeFirstResponder()
        }
        
        if validateTagName() != nil {
            screenSliderDelegate?.forwardNavigationEnabled = true
            screenSliderDelegate?.goToNextScreen()
        }
    }
}

// MARK: - Buttons
extension TagsLoggingMoodViewController {
    
    @objc func goForward() {
        screenSliderDelegate?.forwardNavigationEnabled = true
        self.screenSliderDelegate?.goToNextScreen()
    }
}

// MARK: - View Building
extension TagsLoggingMoodViewController: ViewBuilding {
    
    func configureForwardButtonPosition() {
        forwardButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(tagTextFieldWithLabel)
        self.view.addSubview(tagsStack)
        self.view.addSubview(forwardButton)
        
        configureForwardButtonPosition()
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(40)
        }
        tagTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
        tagsStack.snp.makeConstraints { (make) in
            make.top.equalTo(tagTextFieldWithLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(40)
        }
    }
}
