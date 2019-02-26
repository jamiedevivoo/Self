import UIKit
import SnapKit
import Firebase

class AccountSettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    var db: Firestore!
    var ref: DocumentReference!
    lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "First Name"
        return textfield
    }()
    lazy var surnameTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Surname"
        return textfield
    }()
    lazy var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Email Address"
        return textfield
    }()
    
    // MARK: - init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        db = Firestore.firestore()
//        ref = db.reference()
        
        self.view.addSubview(nameTextField)
        self.view.addSubview(surnameTextField)
        self.view.addSubview(emailTextField)
        
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
    
    // MARK: - Programmatic UI
    
    // MARK: - Actions
    
    //    @objc func saveButtonAction(_ sender: Any) {
    //
    //        guard let name = nameTextField.text, let surname = surnameTextField.text, let email = emailTextField.text else { return }
    //
    ////        let user = Auth.auth().currentUser
    ////        var credential: AuthCredential
    ////
    ////        user?.reauthenticate(with: credential) { error in
    ////            if let error = error {
    ////                // An error happened.
    ////            } else {
    ////                // User re-authenticated.
    ////            }
    ////        }
    
    
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
