import UIKit
import SnapKit
import Firebase

class AccountSettingsViewController: LoggedInViewController {
    
    // MARK: - Properties
    var ref: DocumentReference!
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.gray
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Use this page to modify your account and app settings."
        label.textAlignment = .left
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Surname"
        return textField
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email Address"
        return textField
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupConstraints()
    }
    
    // MARK: - Set Up View
    
    func setup() {
        title = "Account Settings"
        view.backgroundColor = .white
        
        self.view.addSubview(topView)
        topView.addSubview(pageTipLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(surnameTextField)
        self.view.addSubview(emailTextField)
    }
    
    func setupConstraints() {
        topView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(200)
        }
        pageTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topView.snp.left).offset(20)
            make.right.equalTo(topView.snp.right).offset(-20)
            make.top.equalTo(topView.snp.top).offset(100)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        
        surnameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.centerX.centerY.equalTo(self.view)
        }
    }
    
    
    // MARK: - Actions
    
//        @objc func saveButtonAction(_ sender: Any) {
//    
//            guard let name = nameTextField.text, let surname = surnameTextField.text, let email = emailTextField.text else { return }
//    
//    //        let user = Auth.auth().currentUser
//    //        var credential: AuthCredential
//    //
//    //        user?.reauthenticate(with: credential) { error in
//    //            if let error = error {
//    //                // An error happened.
//    //            } else {
//    //                // User re-authenticated.
//    //            }
//    //        }
    
    
    // MARK: - Functions

    
    
//
////        let user = User()
//
//
//        print("LOG: Account Settings Screen")
//
//        view.backgroundColor = .gray
//
//        let saveButton = UIButton()
//



//
//        self.emailTextField.text = user?.email
//        self.nameTextField.text = user?.name
//        self.surnameTextField.text = user?.surname
//
//        saveButton.setTitle("Save Details", for: .normal)
//        saveButton.setTitleColor(.blue, for: .normal)
//        saveButton.addTarget(self, action: #selector(AccountSettingsViewController.saveButtonAction), for: .touchUpInside)
//
//        self.view.addSubview(saveButton)
//



//        saveButton.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-100)
//            make.height.equalTo(40)
//            make.top.equalTo(surnameTextField.snp.bottom).offset(30)
//        }
//
//    }
//
//
//
//        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
//            if let _ = error {
//                print ("\(String(describing: error))")
//            } else {
//
//                let userData: [String:Any] = ["name": name,
//                                "surname ": surname,
//                                "email":email]
//                let uid:String = (AccountManager.shared.user?.uid)!
//
//                self.db.collection("user").document(uid).updateData(userData)
//
//                print("Updated Details: \(email) and \(name) and \(surname)")
//            }
//        }
//
//
//    }

}
