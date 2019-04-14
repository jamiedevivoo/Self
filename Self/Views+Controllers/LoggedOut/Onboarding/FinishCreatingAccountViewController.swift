import UIKit
import Firebase

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
        addSubViews()
        addConstraints()
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
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().currentUser?.linkAndRetrieveData(with: credential) { (authResult, error) in
            guard let registeredCredentials = authResult, error == nil else {
                self.showError(errorDesc: error!.localizedDescription)
                return
            }
            if AccountManager.shared().accountRef?.uid == registeredCredentials.user.uid {
                AccountManager.shared().accountRef?.user.name = "Stranger"
                AccountManager.shared().accountRef?.flags.accountIsComplete = true
                AccountManager.shared().updateAccount()
                self.navigationController?.popToRootViewController(animated: true)
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
            make.width.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        }
    }
}
