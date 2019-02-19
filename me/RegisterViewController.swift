import UIKit
import Firebase
import SnapKit

class RegisterViewController: UIViewController {
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordConfirmTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let registerButton = UIButton()
        
        print("LOG: Login Screen")
        
        emailTextField.backgroundColor = .gray
        emailTextField.text = "email"
        passwordTextField.backgroundColor = .gray
        passwordTextField.text = "password"
        passwordConfirmTextField.backgroundColor = .gray
        passwordConfirmTextField.text = "password"
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.blue, for: .normal)
        registerButton.addTarget(self, action: #selector(RegisterViewController.registerButtonAction), for: .touchUpInside)
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordConfirmTextField)
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
        passwordConfirmTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
        }
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(30)
        }
        
    }
    
    @objc func registerButtonAction(_ sender: Any) {
        
        print("Register with details: \(emailTextField.text!)  \(passwordTextField.text!)")
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let passwordConfirm = passwordConfirmTextField.text else { return }
        
        if password != passwordConfirm {
            let alertController = UIAlertController(title: "Confirmed Password is Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
        
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let _ = authResult {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
}
