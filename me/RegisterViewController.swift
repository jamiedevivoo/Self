import UIKit
import Firebase
import SnapKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    var db:Firestore!
    
    // MARK: - Objects
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordConfirmTextField = UITextField()
    let registerButton = UIButton()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        view.backgroundColor = .white

        print("LOG: Login Screen")
        
        addEmailTextField()
        addPasswordTextField()
        addConfirmPasswordTextField()
        addRegisterButton()
        
    }
    
    // MARK: - Elements and UI
    func addEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        
        self.view.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.centerX.centerY.equalTo(self.view)
        }
    }
    
    func addPasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        self.view.addSubview(passwordTextField)

        passwordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
    }
    
    func addConfirmPasswordTextField() {
        passwordConfirmTextField.placeholder = "Password"
        passwordConfirmTextField.borderStyle = .roundedRect
        passwordConfirmTextField.isSecureTextEntry = true
        
        self.view.addSubview(passwordConfirmTextField)
        
        passwordConfirmTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
        }
    }
    
    func addRegisterButton() {
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.blue, for: .normal)
        registerButton.addTarget(self, action: #selector(RegisterViewController.registerButtonAction), for: .touchUpInside)
        
        self.view.addSubview(registerButton)
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(30)
        }
    }
    
    // MARK: - Functions
    @objc func registerButtonAction(_ sender: Any) {
        
        print("Register with details: \(emailTextField.text!)  \(passwordTextField.text!)")
        
        guard let email: String = emailTextField.text else {
            print("Please enter an email")
            return
        }
            
        guard let password: String = passwordTextField.text else {
            print("Please enter a password")
            return
        }
        guard let passwordConfirm: String = passwordConfirmTextField.text else {
            print("Please enter a password")
            return
        }
        
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
                    let userData: [String:Any] = ["uid": uid,
                                                  "email": email as Any]
                    self.db.collection("user").document(uid).setData(userData)
                    
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
