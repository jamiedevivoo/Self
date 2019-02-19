import UIKit
import SnapKit
import Firebase

class AccountSettingsViewController: UIViewController {
    
    let nameTextField = UITextField()
    let surnameTextField = UITextField()
    let emailTextField = UITextField()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOG: Account Settings Screen")
        
        view.backgroundColor = .gray
        
        let saveButton = UIButton()
        
        emailTextField.backgroundColor = .white
        nameTextField.backgroundColor = .white
        surnameTextField.backgroundColor = .white

        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            // ...
        }
        
        nameTextField.text = user?.uid
        surnameTextField.text = user?.uid
        emailTextField.text = user?.email

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
        
        print("Save Details: \(String(describing: nameTextField.text))")
        guard let name = nameTextField.text, let surname = surnameTextField.text, let email = emailTextField.text else { return }
        
        let userData = ["name": name,
                        "surname ": surname
        ]
        let ref = Database.database().reference()
//        let ref = Firestore.firestore().collection("users").document("jamie")
            ref.child("users").child("jamie").setValue(["name": name])
//        ref.setValue(userData)
        
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            print("LOG: Updated")
        }
    
    }

}
