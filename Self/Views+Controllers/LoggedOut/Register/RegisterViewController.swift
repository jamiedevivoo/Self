import UIKit
import Firebase
import SnapKit

class RegisterViewController: UIViewController {
    
    lazy var nameTextField = StandardTextField(placeholder: "Name", fieldType: .text)
    lazy var emailTextField = StandardTextField(placeholder: "Email", fieldType: .text)
    lazy var passwordTextField = StandardTextField(placeholder: "Password", fieldType: .password)
    lazy var confirmPasswordTextField = StandardTextField(placeholder: "Confirm Password", fieldType: .password)
    lazy var registerButton = StandardButton(title: "Register", action: #selector(RegisterViewController.registerButtonAction), type: .primary)

    private lazy var registerStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.nameTextField, self.emailTextField, self.passwordTextField, self.confirmPasswordTextField, self.registerButton])
        stackView.axis = .vertical
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
}

// MARK: - Init
extension RegisterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        addSubViews()
        addConstraints()
    }
}

// MARK: - Register User
extension RegisterViewController {
    @objc func registerButtonAction(_ sender: Any) {
        
        print("Register with details: \(emailTextField.text!)  \(passwordTextField.text!)")
        
        guard let name: String = nameTextField.text else {
            showError(errorDesc: "Missing Name")
            return
        }
        
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
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let registeredCredentials = authResult, error == nil else {
                self.showError(errorDesc: error!.localizedDescription)
                return
            }
            let userData = UserData(withDictionary: [.name:name])
            let account = Account(withID: registeredCredentials.user.uid, withData: userData)
            AccountManager.shared().updateAccount(newAccount: account)
        }
        
    }
    
}

// MARK: - Functions
extension RegisterViewController {
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

// MARK: - View Building
extension RegisterViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(registerStackView)
    }
    
    func addConstraints() {
        registerStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().inset(50)
            make.center.equalToSuperview()
        }
        nameTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
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
