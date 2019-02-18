import UIKit
import SnapKit
import Firebase

class AccountSettingsViewController: UIViewController {
    
    let nameTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOG: Account Settings Screen")
        
        view.backgroundColor = .gray
        
        let saveButton = UIButton()
        
        nameTextField.backgroundColor = .gray
        nameTextField.text = "email"
        
        saveButton.setTitle("Save Details", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(AccountSettingsViewController.saveButtonAction), for: .touchUpInside)
        

        
        self.view.addSubview(nameTextField)
        self.view.addSubview(saveButton)
        
        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.centerX.centerY.equalTo(self.view)
        }
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
        }

    }
    
    @objc func saveButtonAction(_ sender: Any) {
        
        print("Save Details: \(String(describing: nameTextField.text))")
        
        guard let name = nameTextField.text else { return }
        
//        var ref: DocumentReference? = nil
//        ref = AppDelegate.db.collection("users").addDocument(data: [
//            "name": name
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
    }

}
