import UIKit
import Firebase
import SnapKit

class RegisterViewController: UIViewController {
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordConfirmTextField = UITextField()
    var db:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        view.backgroundColor = .white

        let registerButton = UIButton()
        
        print("LOG: Login Screen")
        
        emailTextField.placeholder = "Email"
        emailTextField.text = "email"
        emailTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "Password"
        passwordTextField.text = "password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        passwordConfirmTextField.placeholder = "Password"
        passwordConfirmTextField.text = "password"
        passwordConfirmTextField.borderStyle = .roundedRect
        passwordConfirmTextField.isSecureTextEntry = true

        
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
        
        guard let email: String = emailTextField.text, let password: String = passwordTextField.text, let passwordConfirm: String = passwordConfirmTextField.text else { return }
        
        if password != passwordConfirm {
            let alertController = UIAlertController(title: "Confirmed Password is Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
        
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let _ = user {
                    
                    let uid = user!.user.uid
                    let email = user!.user.email
                    let userData = ["uid": uid,
                                    "email": email]
                    self.db.collection("users").document(uid).setData(userData as [String : Any])
                    
                    self.dismiss(animated: true, completion: nil)
                }
                if let _ = error {
                    if error != nil {
                        
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            
                            switch errCode {
                            case .invalidEmail:
                                print("The email entered is invalid")
                            case .emailAlreadyInUse:
                                print("Email already in use")
                            default:
                                print("There was another error!")
                            }
                            
                        }
                    }
                }
            }
            
        }
        
        
    }
    
}
