import UIKit
import Firebase

final class FinishCreatingAccountViewController: ViewController {
    
    lazy var headerLabel = HeaderLabel("Let's Secure Your Account", .largeScreen)
    lazy var subHeaderLabel = HeaderLabel(StaticMessages.get["completeAccount"]["text"].stringValue, .subheader)
    
    lazy var registerButton = Button(title: "Secure my account 🔑", action: #selector(FinishCreatingAccountViewController.registerButtonAction), type: .primary)
    
    lazy var emailTextField: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.customiseTextField(for: .email)
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Email Address..."
        textFieldWithLabel.labelTitle = "Your email"
        return textFieldWithLabel
    }()
    lazy var passwordTextField: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.customiseTextField(for: .password)
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.placeholder = "Super secret password goes here"
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.autocorrectionType = UITextAutocorrectionType.no
        textFieldWithLabel.labelTitle = "Your password"
        return textFieldWithLabel
    }()
    
    lazy var confirmPasswordTextField: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.customiseTextField(for: .password)
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Super secret password also goes here"
        textFieldWithLabel.labelTitle = "Confirm Your password"
        textFieldWithLabel.textField.autocorrectionType = UITextAutocorrectionType.no
        return textFieldWithLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        addObservers()
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        confirmPasswordTextField.textField.delegate = self
    }

}

// MARK: - Register User
extension FinishCreatingAccountViewController {
    @objc func registerButtonAction() {
        
        print("Register with details: \(emailTextField.textField.text!)  \(passwordTextField.textField.text!)")
        
        guard let email: String = emailTextField.textField.text  else {
            emailTextField.resetHint(withText: "❗️ Don't forget your email!", for: .error)
            return
        }
        
        guard let password: String = passwordTextField.textField.text else {
            passwordTextField.resetHint(withText: "❗️ Don't forget your password!", for: .error)
            return
        }
        
        guard password == confirmPasswordTextField.textField.text else {
            confirmPasswordTextField.resetHint(withText: "❗️ Looks like your passwords don't match.", for: .error)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().currentUser?.linkAndRetrieveData(with: credential) { (authResult, error) in
            guard let registeredCredentials = authResult, error == nil else {
                self.showError(errorDesc: error!.localizedDescription)
                return
            }
            if AccountManager.shared().accountRef?.uid == registeredCredentials.user.uid {
                AccountManager.shared().accountRef?.flags.accountIsComplete = true
                AccountManager.shared().updateAccount {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
}

// MARK: - Functions
extension FinishCreatingAccountViewController {
    func showError(errorDesc: String) {
        let errorAlert: UIAlertController = {
            let alertController = UIAlertController()
            alertController.title = errorDesc
            alertController.message = "Please try again"
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertController
        }()
        self.present(errorAlert, animated: true, completion: nil)
    }
}

extension FinishCreatingAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField.textField:
            passwordTextField.textField.becomeFirstResponder()
            return false
        case passwordTextField.textField:
            confirmPasswordTextField.textField.becomeFirstResponder()
            return false
        case confirmPasswordTextField.textField:
            registerButtonAction()
            return true
        default:
            return true
        }
    }

private func addObservers() {
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
}
    
@objc func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {return}
    guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyboardFrame = keyboardSize.cgRectValue
    
    let textFields: [Textfield] = [emailTextField.textField, passwordTextField.textField, confirmPasswordTextField.textField]
    let currentFirstResponder = textFields.first(where: {$0.isFirstResponder})
    
    let scrollDistance = (view.frame.size.height - keyboardFrame.height - (currentFirstResponder!.frame.origin.y + currentFirstResponder!.frame.size.height + 10))
    if scrollDistance < 0 {
        for subview in view.subviews {
            subview.frame.origin.y += scrollDistance
        }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
    print(notification)
    guard let userInfo = notification.userInfo else {return}
    guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyboardFrame = keyboardSize.cgRectValue
    
    let topElement = view.subviews.max { a, b in a.frame.origin.y > b.frame.origin.y }
    let scrollDistance = view.frame.origin.y - topElement!.frame.origin.y
    
    for subview in view.subviews {
        subview.frame.origin.y -= scrollDistance
    }
}
}


// MARK: - View Building
extension FinishCreatingAccountViewController: ViewBuilding {
    func setupChildViews() {
        
        self.view.addSubview(headerLabel)
        self.view.addSubview(subHeaderLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(confirmPasswordTextField)
        self.view.addSubview(registerButton)
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(30)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(50)
        }
        subHeaderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(50)
        }

        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(30)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
        }
        confirmPasswordTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        registerButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
        }
    }
}
