import UIKit
import Firebase
import SnapKit

final class DiaryLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Add A Note", .largeScreen)
    lazy var forwardButton = IconButton(UIImage(named: "down-circle")!, action: #selector(goForward), .standard)
    
    lazy var diaryTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Personal note..."
        textFieldWithLabel.labelTitle = "Make your log more meaningful by adding context."
        return textFieldWithLabel
    }()
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
}

// MARK: - Override Methods
extension DiaryLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenSliderDelegate?.forwardNavigationEnabled = false
        setupKeyboard()
    }
    
}

// MARK: - Class Methods
extension DiaryLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        guard
            let note: String = self.diaryTextFieldWithLabel.textField.text?.trim(),
            self.diaryTextFieldWithLabel.textField.text!.trim().count > 1
            else { return nil }
        moodLogDataCollectionDelegate?.note = note
        diaryTextFieldWithLabel.resetHint()
        self.diaryTextFieldWithLabel.textField.text = note
        return note
    }
}

// MARK: - TextField Delegate Methods
extension DiaryLoggingMoodViewController: UITextFieldDelegate {
    func setupKeyboard() {
        diaryTextFieldWithLabel.textField.delegate = self
        self.diaryTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        view.addGestureRecognizer(tapToTogglekeyboardGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let note = validateHeadline() {
            diaryTextFieldWithLabel.textField.resignFirstResponder()
            goForward()
            moodLogDataCollectionDelegate?.note = note
            return true
        } else {
            moodLogDataCollectionDelegate?.note = nil
            diaryTextFieldWithLabel.textField.shake()
            diaryTextFieldWithLabel.resetHint(withText: "Your note should be at least 2 characters")
        }
        return false
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if diaryTextFieldWithLabel.textField.isFirstResponder {
            diaryTextFieldWithLabel.textField.resignFirstResponder()
        } else {
            diaryTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
}

// MARK: - Buttons
extension DiaryLoggingMoodViewController {
    
    @objc func goForward() {
        screenSliderDelegate?.forwardNavigationEnabled = true
        self.screenSliderDelegate?.goToNextScreen()
    }
}

// MARK: - View Building
extension DiaryLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(diaryTextFieldWithLabel)
        self.view.addSubview(forwardButton)
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(40)
        }
        diaryTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
        forwardButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
}
