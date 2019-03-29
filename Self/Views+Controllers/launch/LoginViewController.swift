import UIKit
import Firebase
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - Views
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.text = "email@email.com"
        textField.placeholder = "Email Address"
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.textColor = UIColor.app.text.primary
        textField.minimumFontSize = 25.0
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
//        textField.clipsToBounds = true
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.text = "password"
        textField.placeholder = "Password"
        textField.keyboardType = UIKeyboardType.default
        textField.isSecureTextEntry = true
        textField.textColor = UIColor.app.text.primary
        textField.minimumFontSize = 25.0
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        return textField
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(LoginViewController.loginButtonAction), for: .touchUpInside)
        return button
    }()
    private lazy var loginStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField, self.loginButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    // MARK: - Properties
    var db:Firestore!
    
    // MARK: - Initialisers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        title = "Login"
        view.backgroundColor = .white
        
        addSubViews()
        addConstraints()
    }

    // MARK: - Functions
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
            
            self.dismiss(animated: true, completion: nil)
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
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.height.equalTo(50.0)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(50.0)
        }
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(50.0)
        }

    }
    
}
