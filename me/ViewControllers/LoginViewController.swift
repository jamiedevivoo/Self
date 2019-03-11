import UIKit
import Firebase
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.text = "email@email.com"
        textField.placeholder = "Email Address"
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.textColor = UIColor.app.text.primary
        textField.minimumFontSize = 17.0
        textField.borderStyle = .roundedRect
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.text = "password"
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.textColor = UIColor.app.text.primary
        textField.minimumFontSize = 17.0
        return textField
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.app.text.primary, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(LoginViewController.loginButtonAction), for: .touchUpInside)
        return button
    }()
    private lazy var loginStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField, self.loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.registerButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    var db:Firestore!
    
    // MARK: - Initialisers

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Login Screen")
        
        db = Firestore.firestore()
        
        setup()
        addConstraints()
    }
    
    func setup() {
        title = "Login"
        view.backgroundColor = UIColor.app.background.primary
        
        self.view.addSubview(loginStackView)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(registerButton)
        
    }

    // MARK: - Action Functions
    
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

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let _ = error {
                let alertController = UIAlertController(title: "Details are Incorrect", message: "Please try again", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func registerButtonAction(_ sender: Any) {
        print("Register Button Tapped")
        let onboardingViewController = OnboardingController()
        onboardingViewController.title = "Register"
        navigationController?.pushViewController(onboardingViewController, animated: true)    }
}


extension LoginViewController: ConstraintBuilding {
    
    func addConstraints() {
        welcomeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.top.equalTo(100)
            make.height.equalTo(50)
        }
        loginStackView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().inset(50)
            make.center.equalToSuperview()
            
        }
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(loginButton.snp.bottom).offset(30)
        }
    }
    
}
