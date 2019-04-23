import UIKit
import Firebase
import SnapKit

class LoginViewController: ViewController {
    
    var containingScrollView = UIScrollView()
    
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

    private lazy var loginStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.emailTextFieldWithLabel, self.passwordTextFieldWithLabel, self.loginButton, self.cancelButton])
        stackView.axis = .vertical
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        return stackView
    }()
}

// Override Methods
extension LoginViewController: UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupChildViews()
        configureKeyboardBehaviour()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
//        emailTextFieldWithLabel.textField.becomeFirstResponder()
    }
}

// Setup Methods
extension LoginViewController {
    private func setupScrollView() {
        containingScrollView.contentSize = loginStackView.frame.size
        containingScrollView.frame = self.view.frame
    }
}

// Button Methods
extension LoginViewController {
    @objc func loginButtonAction(_ sender: Any) {
        print("Log in with details: \(String(describing: emailTextFieldWithLabel.textField.text))  \(String(describing: passwordTextFieldWithLabel.textField.text))")
        
        guard let email = emailTextFieldWithLabel.textField.text?.trim() else {
            emailTextFieldWithLabel.textField.shake()
            emailTextFieldWithLabel.resetHint(withText: "Please enter your email")
            return
        }
        guard let password = passwordTextFieldWithLabel.textField.text?.trim() else {
            emailTextFieldWithLabel.textField.shake()
            passwordTextFieldWithLabel.resetHint(withText: "Please enter a password")
            return
        }
        
        emailTextFieldWithLabel.resetHint()
        passwordTextFieldWithLabel.resetHint()
        login(email, password)
    }
    
    @objc func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
        
    private func login(_ email:String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let _ = authResult, error == nil else {
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
}

// MARK: - View Building
extension LoginViewController: ViewBuilding {
    
    func setupChildViews() {
        
        self.view.addSubview(containingScrollView)
        containingScrollView.addSubview(loginStackView)

        loginStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
        }
        emailTextFieldWithLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(60)
        }
        passwordTextFieldWithLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(60)
        }
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalToSuperview()
            
        }
    }
    
}
