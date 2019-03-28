import UIKit
import Firebase
import SnapKit

class RegisterViewController: UIViewController {
    
    // MARK: - Objects
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    lazy var passwordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(RegisterViewController.registerButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var db:Firestore!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        view.backgroundColor = .white
        db = Firestore.firestore()
        
        addSubViews()
        addConstraints()
    }
    
    // MARK: - Action Functions
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
            
            let alertController = UIAlertController(
                title: "Confirmed Password is Incorrect",
                message: "Please re-type password",
                preferredStyle: .alert
            )
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
            
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

extension RegisterViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordConfirmTextField)
        self.view.addSubview(registerButton)
    }
    
    func addConstraints() {
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
}
