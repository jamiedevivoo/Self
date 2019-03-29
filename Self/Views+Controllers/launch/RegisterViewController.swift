import UIKit
import Firebase
import SnapKit

class RegisterViewController: UIViewController {
    
    // MARK: - Objects
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
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
        
        guard let name: String = nameTextField.text else {
            let errorAlert: UIAlertController = {
                let alertController = UIAlertController()
                alertController.title = "Missing Name"
                alertController.message = "Please try again"
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                return alertController
            }()
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard let email: String = emailTextField.text  else {
            let errorAlert: UIAlertController = {
                let alertController = UIAlertController()
                alertController.title = "Missing Email"
                alertController.message = "Please try again"
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                return alertController
            }()
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
            
        guard let password: String = passwordTextField.text, let passwordConfirm: String = passwordConfirmTextField.text else {
            let errorAlert: UIAlertController = {
                let alertController = UIAlertController()
                alertController.title = "Missing Password"
                alertController.message = "Please try again"
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                return alertController
            }()
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard password == passwordConfirm else {
            let errorAlert: UIAlertController = {
                let alertController = UIAlertController()
                alertController.title = "Passwords don't match"
                alertController.message = "Please try again"
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                return alertController
            }()
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        let user = User(dictionary: ["email": "\(self.nameTextField.text)",
                                     "name": "\(self.nameTextField.text)"])
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let registeredCredentials = authResult, error == nil else {
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
            
//                let user = User(dictionary: ["uid": registeredCredentials.user.uid,
//                                             "email": "\(registeredCredentials.user.email)",
//                                             "name": "\(self.nameTextField.text)"])
            
//                let user = User(user: registeredCredentials.user)
//                print(user)

//              self.db.collection("user").document(uid).setData(userData)
//            print(Auth.auth().currentUser!.uid)
//            AccountManager.shared.update()
//
                self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
}

extension RegisterViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordConfirmTextField)
        self.view.addSubview(registerButton)
    }
    
    func addConstraints() {
        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.centerX.centerY.equalTo(self.view)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
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
