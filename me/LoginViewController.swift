import UIKit
import Firebase
import SnapKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOG: Login Screen")
        
        let emailTextField = UITextField()
        let passwordTextField = UITextField()
        let loginButton = UIButton()
        
        loginButton.backgroundColor = .blue
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
        
        UIView.animate(withDuration: 1) {
            emailTextField.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(100)
                make.center.equalTo(self.view)
            }
            passwordTextField.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(100)
                make.center.equalTo(emailTextField).offset(20)
            }
            loginButton.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(100)
                make.center.equalTo(passwordTextField).offset(20)
            }
        }
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        
    }
    
    weak var emailTextField: UITextField!
    weak var passwordTextField: UITextField!
    
    @objc func login(_ sender: Any) {
        
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let _ = user {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
