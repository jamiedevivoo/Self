import UIKit
import Firebase
import SnapKit
import MaterialComponents

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
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
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.registerButtonAction), for: .touchUpInside)
        return button
    }()
    private lazy var loginStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.logoView, self.emailTextField, self.passwordTextField, self.loginButton, self.registerButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
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
        title = "Welcome to Me"
        view.backgroundColor = UIColor.app.standard.background
        
        self.view.addSubview(loginStackView)
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
        logoView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
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
