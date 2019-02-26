import UIKit
import Firebase
import SnapKit

class LoginViewController: UIViewController {
    
    let accountManager = AccountManager()

    let welcomeLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    var db:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        let loginButton = UIButton()
        let registerButton = UIButton()
        
        print("LOG: Login Screen")
        
        welcomeLabel.text = "Welcome"
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .black
        
        emailTextField.text = "email@email.com"
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.placeholder = "Email Address"
        emailTextField.borderStyle = .roundedRect
        
        passwordTextField.text = "password"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect

        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonAction), for: .touchUpInside)
        
        registerButton.setTitle("Get started", for: .normal)
        registerButton.setTitleColor(.red, for: .normal)
        registerButton.addTarget(self, action: #selector(LoginViewController.registerButtonAction), for: .touchUpInside)
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.top.equalTo(100)
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.centerX.centerY.equalTo(self.view)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
        }
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(loginButton.snp.bottom).offset(30)
        }
        
    }

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
        let onboardingViewController = Onboarding1ViewController()
        onboardingViewController.title = "Register"
        navigationController?.pushViewController(onboardingViewController, animated: true)    }
}
