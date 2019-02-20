import UIKit
import SnapKit
import Firebase

class AccountSettingsViewController: UIViewController {
    
    let nameTextField = UITextField()
    let surnameTextField = UITextField()
    let emailTextField = UITextField()
    
    var db:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        print("LOG: Account Settings Screen")
        
        view.backgroundColor = .gray
        
        let saveButton = UIButton()
        
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email Address"
        nameTextField.borderStyle = .roundedRect
        nameTextField.placeholder = "First Name"
        surnameTextField.borderStyle = .roundedRect
        surnameTextField.placeholder = "Surname"

        db.collection("users").document((AccountManager.shared.user?.uid)!).getDocument() { document, error in
            if let error = error {
                    print ("\(error)")
            } else if let document = document {
                let data = document.data()!
                self.emailTextField.text = data["email"] as? String ?? ""
                self.surnameTextField.text = data["name"] as? String ?? ""
                self.nameTextField.text = data["surname"] as? String ?? ""
            }
        }

        saveButton.setTitle("Save Details", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(AccountSettingsViewController.saveButtonAction), for: .touchUpInside)
    
        self.view.addSubview(nameTextField)
        self.view.addSubview(surnameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(saveButton)
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.centerX.centerY.equalTo(self.view)
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
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(surnameTextField.snp.bottom).offset(30)
        }

    }
    
    @objc func saveButtonAction(_ sender: Any) {
        
        guard let name = nameTextField.text, let surname = surnameTextField.text, let email = emailTextField.text else { return }
        
//        let user = Auth.auth().currentUser
//        var credential: AuthCredential
//
//        user?.reauthenticate(with: credential) { error in
//            if let error = error {
//                // An error happened.
//            } else {
//                // User re-authenticated.
//            }
//        }
        

        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if let _ = error {
                print ("\(String(describing: error))")
            } else {
            
                let userData: [String:Any] = ["name": name,
                                "surname ": surname,
                                "age": "22",
                                "email":email]
                let uid:String = (AccountManager.shared.user?.uid)!
                
                self.db.collection("users").document(uid).updateData(userData)
                
                print("Updated Details: \(email) and \(name) and \(surname)")
            }
        }
        
    
    }

}
