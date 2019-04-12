import UIKit
import Firebase
import SnapKit

class LoginViewController: ViewController {
    
    // MARK: - Views
    lazy var emailTextField = StandardTextField(text: "email@email.com",placeholder: "Email Address", fieldType: .email)
    lazy var passwordTextField = StandardTextField(text: "password",placeholder: "Password", fieldType: .password)
    lazy var loginButton = StandardButton(title: "Log In", action: #selector(LoginViewController.loginButtonAction), type: .primary)

    private lazy var loginStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField, self.loginButton])
        stackView.axis = .vertical
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        addSubViews()
        addConstraints()
    }
}

extension LoginViewController {
    @objc func loginButtonAction(_ sender: Any) {
        print("Log in with details: \(String(describing: emailTextField.text))  \(String(describing: passwordTextField.text))")
        
        guard let email = emailTextField.text else {
            print("Please enter an email")
            return
        }
        guard let password = passwordTextField.text else {
            print("Please enter a password")
            return
        }
        
        login(email, password)
      
    }
        
    private func login(_ email:EmailString, _ password: String) {
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

// MARK: -
extension LoginViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(loginStackView)
    }
    
    
    func addConstraints() {
        loginStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().inset(50)
            make.center.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.width.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.width.equalToSuperview()
        }
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }

    }
    
}
