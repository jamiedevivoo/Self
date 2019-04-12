import UIKit

class FinishCreatingAccountViewController: ViewController {
    
    lazy var emailTextField = StandardTextField(placeholder: "Email", fieldType: .text)
    lazy var passwordTextField = StandardTextField(placeholder: "Password", fieldType: .password)
    lazy var confirmPasswordTextField = StandardTextField(placeholder: "Confirm Password", fieldType: .password)
    lazy var registerButton = StandardButton(title: "Register", action: #selector(FinishCreatingAccountViewController.registerButtonAction), type: .primary)
    
    private lazy var registerStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField, self.confirmPasswordTextField, self.registerButton])
        stackView.axis = .vertical
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


// MARK: - Register User
extension FinishCreatingAccountViewController {
    @objc func registerButtonAction(_ sender: Any) {
        
        print("Register with details: \(emailTextField.text!)  \(passwordTextField.text!)")
        
        guard let email: String = emailTextField.text  else {
            showError(errorDesc: "Missing Email")
            return
        }
        
        guard let password: String = passwordTextField.text else {
            showError(errorDesc: "Missing Password")
            return
        }
        
        guard password == confirmPasswordTextField.text else {
            showError(errorDesc: "Passwords do not match")
            return
        }
        
        //        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        //            guard let registeredCredentials = authResult, error == nil else {
        //                self.showError(errorDesc: error!.localizedDescription)
        //                return
        //            }
        //            let userData = UserData(withDictionary: [.name:name])
        //            let account = Account(withID: registeredCredentials.user.uid, withData: userData)
        //            AccountManager.shared().updateAccount(newAccount: account)
        //        }
        
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

extension FinishCreatingAccountViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FinishCreatingAccountViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - View Building
extension FinishCreatingAccountViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(registerStackView)
    }
    
    func addConstraints() {
        registerStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().inset(50)
            make.center.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        confirmPasswordTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        registerButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}
