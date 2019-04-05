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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.app.pinkColor()
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.app.pinkColor().cgColor
        button.addTarget(self, action: #selector(RegisterViewController.registerButtonAction), for: .touchUpInside)
        return button
    }()
    private lazy var registerStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.nameTextField, self.emailTextField, self.passwordTextField, self.passwordConfirmTextField, self.registerButton])
        stackView.axis = .vertical
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
        }()
    
    // MARK: - Properties
    var db:Firestore!
    var user: UserInfo!
    
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
    
    func showError(errorDesc: String) {
        let errorAlert: UIAlertController = {
            let alertController = UIAlertController()
            alertController.title = errorDesc
            alertController.message = "Please try again"
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertController
        }()
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    @objc func registerButtonAction(_ sender: Any) {
        
        print("Register with details: \(emailTextField.text!)  \(passwordTextField.text!)")
        
        guard let name: String = nameTextField.text else {
            showError(errorDesc: "Missing Name")
            return
        }
        
        guard let email: String = emailTextField.text  else {
            showError(errorDesc: "Missing Email")
            return
        }
            
        guard let password: String = passwordTextField.text else {
            showError(errorDesc: "Missing Password")
            return
        }
        
        guard password == passwordConfirmTextField.text else {
            showError(errorDesc: "Passwords do not match")
            return
        }
        
        user.name = name
        user.email = email
        
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
        self.view.addSubview(registerStackView)
    }
    
    func addConstraints() {
        registerStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().inset(50)
            make.center.equalToSuperview()
        }
        nameTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        passwordConfirmTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        registerButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}
