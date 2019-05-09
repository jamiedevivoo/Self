import UIKit
import SnapKit
import Firebase

final class DetailLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollectionDelegate: DataCollectionSequenceDelegate?
    weak var moodLoggingDelegate: MoodLoggingDelegate?
    var screenSlider: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("More Details", .largeScreen)
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let btnImage = UIImage(named: "up-circle")?.withRenderingMode(.alwaysTemplate)
        btnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(btnImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = true
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDown)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDragEnter)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchDragExit)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchCancel)
        button.alpha = 0.5
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        return button
    }()
    
    lazy var tagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .trailing
        return stack
    }()
    
    lazy var headLineTextField: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 30, weight: .light)
        textFieldWithLabel.textField.placeholder = "I'm feeling..."
        textFieldWithLabel.labelTitle = "Describe how your feeling"
        return textFieldWithLabel
    }()
    
    lazy var tagTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 30, weight: .light)
        textFieldWithLabel.textField.placeholder = "Add a Tag..."
        textFieldWithLabel.labelTitle = "What did you do today?"
        return textFieldWithLabel
    }()
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
        
}

// MARK: - Override Methods
extension DetailLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
        self.view.addGestureRecognizer(tapToTogglekeyboardGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headLineTextField.textField.placeholder = "I'm Feeling \(moodLoggingDelegate?.emotion?.adj ?? "")?..."
        screenSlider?.backwardNavigationEnabled = false
    }
    
}

// MARK: - Class Methods
extension DetailLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        // Checks and reformats the text
        guard
            let headline: String = self.headLineTextField.textField.text?.trim(),
            self.headLineTextField.textField.text!.trim().count > 1
        else {
            // Provides feedback if this check fails
            headLineTextField.textField.shake()
            headLineTextField.resetHint(withText: "Describe your mood in at least 2 characters")
            
            // Sets the value to nil and returns early
            return nil
        }
        
        // If validation passes, reset the hint
        headLineTextField.resetHint()
        
        // Then update the textfield and inform the delegate of the new value
//        self.headLineTextField.textField.text = headline
        moodLoggingDelegate?.headline = headline
        return headline
    }
    
    @objc func validateTags() -> String? {
        print(self.tagTextFieldWithLabel.textField.text?.trim())
        // Checks and reformats the text
        guard
            let tag: String = self.tagTextFieldWithLabel.textField.text?.trim(),
            self.tagTextFieldWithLabel.textField.text!.trim().count > 1
        else {
            // Provides feedback if this check fails
            tagTextFieldWithLabel.textField.shake()
            tagTextFieldWithLabel.resetHint(withText: "Tags should be at least 2 characters")
            
            // Sets the value to nil and returns early
            return nil
        }
        print(tag)
        // If validation passes, reset the hint
        tagTextFieldWithLabel.resetHint()
        
        let button = UIButton()
        button.setTitle(tag, for: .normal)
        tagsStack.addArrangedSubview(button)
        
        // Then update the textfield and inform the delegate of the new value
        self.tagTextFieldWithLabel.textField.text = tag
        return tag
    }
}

// MARK: - TextField Delegate Methods
extension DetailLoggingMoodViewController: UITextFieldDelegate {
    
    func setupKeyboard() {
        headLineTextField.textField.delegate = self
        tagTextFieldWithLabel.textField.delegate = self
        self.headLineTextField.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        self.tagTextFieldWithLabel.textField.addTarget(self, action: #selector(validateTags), for: .editingChanged)
        toggleFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if headLineTextField.textField.isFirstResponder {
            if validateHeadline() == nil { return false }
        }
        if tagTextFieldWithLabel.textField.isFirstResponder {
            if validateTags() == nil { return false }
        }
//        toggleFirstResponder()
        return true
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if headLineTextField.textField.isFirstResponder { tagTextFieldWithLabel.textField.becomeFirstResponder() }
        if tagTextFieldWithLabel.textField.isFirstResponder { headLineTextField.textField.becomeFirstResponder() }
    }
    
}

// MARK: - Buttons
extension DetailLoggingMoodViewController {
    
    @objc func goBack() {
        screenSlider?.backwardNavigationEnabled = true
        self.screenSlider?.previousScreen()
    }
    
    @objc func buttonActive(sender: UIButton) {
        focusButton(sender)
    }
    
    @objc func buttonCancelled(sender: UIButton) {
        unFocusButton(sender)
    }
    
    private func focusButton(_ button: UIButton) {
        let duration = 0.6
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius += 1.0
        button.layer.shadowOpacity -= 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width + 0.5, height: button.layer.shadowOffset.height + 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha += 0.2
                        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    private func unFocusButton(_ button: UIButton) {
        let duration = 0.4
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius -= 1.0
        button.layer.shadowOpacity += 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width - 0.5, height: button.layer.shadowOffset.height - 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha -= 0.2
                        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
}

// MARK: - View Building
extension DetailLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(headLineTextField)
        self.view.addSubview(tagsStack)
        self.view.addSubview(tagTextFieldWithLabel)
        
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
        headLineTextField.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
        tagTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headLineTextField.snp.bottom).offset(25)
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
