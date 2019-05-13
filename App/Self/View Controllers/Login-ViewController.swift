import UIKit
import Firebase
import SnapKit

class LoginViewController: ViewController {
    
    lazy var headerLabel = HeaderLabel("Welcome back! 👋", .largeScreen)
    lazy var subHeaderLabel = HeaderLabel(StaticMessages.get["login"]["welcome"]["text"].stringValue, .subheader)

    lazy var emailTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.customiseTextField(for: .email)
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.text = "email@email.com"
        textFieldWithLabel.textField.placeholder = "Email Address..."
        textFieldWithLabel.labelTitle = "Your email"
        return textFieldWithLabel
    }()
    lazy var passwordTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.customiseTextField(for: .password)
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.placeholder = "Password..."
        textFieldWithLabel.textField.text = "password"
        textFieldWithLabel.labelTitle = "Your password"
        return textFieldWithLabel
    }()
    lazy var loginButton = Button(title: "Log In", action: #selector(LoginViewController.loginButtonAction), type: .primary)
    lazy var cancelButton = Button(title: "Cancel", action: #selector(LoginViewController.cancelAction), type: .secondary)
}

// Override Methods
extension LoginViewController: UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupChildViews()
        configureKeyboardBehaviour()
        addObservers()
        passwordTextFieldWithLabel.textField.delegate = self
        emailTextFieldWithLabel.textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextFieldWithLabel.textField:
            passwordTextFieldWithLabel.textField.becomeFirstResponder()
            return false
        case passwordTextFieldWithLabel.textField:
            loginButtonAction()
            return true
        default:
            return true
        }
    }

}

// Button Methods
extension LoginViewController {
    @objc func loginButtonAction() {
        print("Log in with details: \(String(describing: emailTextFieldWithLabel.textField.text))  \(String(describing: passwordTextFieldWithLabel.textField.text))")
        
        guard let email = emailTextFieldWithLabel.textField.text?.trim() else {
            emailTextFieldWithLabel.textField.shake()
            emailTextFieldWithLabel.resetHint(withText: "Please enter your email", for: .error)
            return
        }
        guard let password = passwordTextFieldWithLabel.textField.text?.trim() else {
            emailTextFieldWithLabel.textField.shake()
            passwordTextFieldWithLabel.resetHint(withText: "Please enter a password", for: .error)
            return
        }
        
        emailTextFieldWithLabel.resetHint()
        passwordTextFieldWithLabel.resetHint()
        login(email, password)
    }
    
    @objc func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
        
    private func login(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard authResult != nil, error == nil else {
                let errorAlert: UIAlertController = {
                    let alertController = UIAlertController()
                    alertController.title = error!.localizedDescription
                    alertController.message = "Please try again"
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    return alertController
                }()
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        let bottomElement = view.subviews.max { a, b in a.frame.origin.y < b.frame.origin.y }
        let scrollDistance = (view.frame.size.height - keyboardFrame.height - (bottomElement!.frame.origin.y + bottomElement!.frame.size.height + 10))
            
        for subview in view.subviews {
            subview.frame.origin.y += scrollDistance
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
extension LoginViewController: ViewBuilding {
    
    func setupChildViews() {
        
        self.view.addSubview(headerLabel)
        self.view.addSubview(subHeaderLabel)
        self.view.addSubview(emailTextFieldWithLabel)
        self.view.addSubview(passwordTextFieldWithLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(cancelButton)

        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        subHeaderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(headerLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }

        emailTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(30)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
        passwordTextFieldWithLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
            make.top.equalTo(emailTextFieldWithLabel.snp.bottom).offset(10)
        }
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(passwordTextFieldWithLabel.snp.bottom).offset(20)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(loginButton.snp.bottom).offset(10)
        }
    }
    
}
