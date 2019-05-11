import UIKit
import SnapKit
import Firebase

final class TagsLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
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
    
    lazy var tags: [String] = []
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))
}

// MARK: - Override Methods
extension TagsLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupTextfield()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Update the textfield with the latest value
        tagTextFieldWithLabel.textField.text = dataCollector?.tags.first
        tagTextFieldWithLabel.textField.placeholder = "A tag for \(dataCollector?.headline ?? "")"
        /// Revalidate the value and disable or enable navigation accordingly.
        if (dataCollector?.tags.count)! < 1 {
            tagTextFieldWithLabel.resetHint()
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
     if (dataCollector?.tags.count)! < 1 {
            screenSliderDelegate?.forwardNavigationEnabled = false
//            tagTextFieldWithLabel.textField.becomeFirstResponder()
        } else {
            screenSliderDelegate?.forwardNavigationEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// If the view is about to dissapear we can resign the first responder
        tagTextFieldWithLabel.textField.resignFirstResponder()
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
            tagTextFieldWithLabel.resetHint()
            screenSliderDelegate?.forwardNavigationEnabled = false
            return nil
        }
        screenSliderDelegate?.forwardNavigationEnabled = true
        /// If it passes, reset the hint and show the next button
        tagTextFieldWithLabel.resetHint(withText: "+ Press next to add \(tag) as a tag", for: .info)
        /// Then update the textfield
        dataCollector?.tags.append(tag)
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

//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let tag = validateTagName() else {
            
            // If the user has already added at least one tag, let them proceed with an error
            if dataCollector?.tags.count ?? 0 > 0 {
                screenSliderDelegate?.goToNextScreen()
                return true
            }
            
            tagTextFieldWithLabel.textField.shake()
            tagTextFieldWithLabel.resetHint(withText: "Your log needs at least 1 tag (of 2 characters or more)", for: .error)
            return false
        }
        
        tagTextFieldWithLabel.textField.placeholder = "Another tag..."
        tagTextFieldWithLabel.resetHint(withText: "✓ Add another tag or press next again to continue", for: .info)
        textField.text = nil
        let tagButton = createTagButton(tagName: tag)
        dataCollector?.tags.append(tagButton.titleLabel!.text!)
        return true
        
        }
    
    func setupTextfield() {
        tagTextFieldWithLabel.textField.delegate = self
        tagTextFieldWithLabel.textField.addTarget(self, action: #selector(validateTagName), for: .editingChanged)
    }
}

// Gestures
extension TagsLoggingMoodViewController {
    @objc func processTap() {
        /// See if the current text validates
        guard validateTagName() == nil else {
            /// If it does, enable forward navigation and go to the next screen
            screenSliderDelegate?.goToNextScreen()
            return
        }
        /// If it fails and the keyboard isn't displayed, show the keyboard
        guard tagTextFieldWithLabel.textField.isFirstResponder else {
            tagTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        tagTextFieldWithLabel.textField.shake()
        tagTextFieldWithLabel.resetHint(withText: "Your log needs at least 1 tag (of 2 characters or more)", for: .error)
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
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(tagTextFieldWithLabel)
        self.view.addSubview(tagsStack)
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
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
