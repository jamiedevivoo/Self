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
        nameTextField.borderStyle = .roundedRect
        surnameTextField.borderStyle = .roundedRect
        
        db.collection("users").getDocuments() { querySnapshot, error in
            if let error = error {
                    print ("\(error.localizedDescription)")
            } else {
                print(querySnapshot!.documents)
            }
        }
        
        nameTextField.text = "name"
        surnameTextField.text = "surname"
        emailTextField.text = AccountManager.shared.user?.email

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
        
        let userData = ["name": name,
                        "surname ": surname,
                        "age": "22"]
        let uid:String = (AccountManager.shared.user?.uid)!
        print(uid)
        db.collection("users").document(uid).updateData(userData)

        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if let _ = error {
                print ("/(error?)")
            } else {
                print("Updated Details: \(email) and \(name) and \(surname)")
            }
        }
    
    }

}
