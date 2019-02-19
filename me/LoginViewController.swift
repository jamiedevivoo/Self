import UIKit
import Firebase
import SnapKit

class LoginViewController: UIViewController {
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = UIButton()
        let registerButton = UIButton()
        
        print("LOG: Login Screen")
        
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
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.red, for: .normal)
        registerButton.addTarget(self, action: #selector(LoginViewController.registerButtonAction), for: .touchUpInside)
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)

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

        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let _ = error {
                print(error)
                let alertController = UIAlertController(title: "Details are Incorrect", message: "Please try again", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            if let _ = user {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func registerButtonAction(_ sender: Any) {
        print("Register Button Tapped")
        let regiterViewController = RegisterViewController()
        regiterViewController.title = "Register Today"
        navigationController?.pushViewController(regiterViewController, animated: true)    }
}