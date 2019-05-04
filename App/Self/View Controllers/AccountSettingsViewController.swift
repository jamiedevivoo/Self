import UIKit
import SnapKit
import Firebase
import NotificationBannerSwift

class AccountSettingsViewController: UIViewController {
    
    
    // MARK: - Properties
    var user: AccountUser!
    
    // MARK: - SubViews
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.secondaryBackground()
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Use this page to modify the settings related to your account."
        label.textAlignment = .left
        label.textColor = UIColor.app.text.solidText()
        label.numberOfLines = 0
        
        return label
    }()
    lazy var nameTextField = Textfield(placeholder: "First Name", fieldType: .text)
    lazy var emailTextField = Textfield(placeholder: "Email Address", fieldType: .email)
    lazy var updateButton = Button(title: "Update Details", action: #selector(AccountSettingsViewController.saveButtonAction), type: .primary)
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account Settings"
        view.backgroundColor = UIColor.app.background.primaryBackground()
        self.hideKeyboardWhenTappedAround()
        addSubViews()
        setupChildViews()
        
        self.user = AccountManager.shared().accountRef!.user
        updateFields()
    }
    
    
    // MARK: - Functions
    
    func updateFields() {
        if let name = self.user?.name {
            self.nameTextField.text = name
        }
        if let email = Auth.auth().currentUser?.email {
            self.emailTextField.text = email
        }
    }
    
    // MARK: - Actions
    
        @objc func saveButtonAction(_ sender: Any) {
            
            guard let name = nameTextField.text, let email = emailTextField.text else { return }

//            let user = Auth.auth().currentUser
//            var credential: AuthCredential
            
            Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                if let _ = error {
                    let banner = GrowingNotificationBanner(title: "Problem", subtitle: error?.localizedDescription, style: .danger)
                    banner.show()
                } else {
                    AccountManager.shared().accountRef?.user.name = name
                    AccountManager.shared().updateAccount() {
                        let banner = NotificationBanner(title: "Success", subtitle: "Account updated", style: .success)
                        banner.show()
                    }
                }
            }
//            Auth.auth().currentUser?.reauthenticate(with: email, completion: {
//                [weak self]
//                (error) in
//            })
//            let credential = EmailAuthProvider.credential(withEmail: "email", password: "pass")
//
//            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (error) in
//                if let error = error {
//                    // An error happened.
//                } else {
//                    // User re-authenticated.
//                }
//            }
        }
    }
    
extension AccountSettingsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountSettingsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

extension AccountSettingsViewController: ViewBuilding {
    
    func addSubViews() {
        self.view.addSubview(topView)
            topView.addSubview(pageTipLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(updateButton)
    }
    
    func setupChildViews() {
        topView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.greaterThanOrEqualTo(pageTipLabel.snp.height).offset(150)
        }
        pageTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topView.snp.left).offset(20)
            make.right.equalTo(topView.snp.right).offset(-20)
            make.top.equalTo(topView.snp.top).offset(100)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.centerY)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        updateButton.snp.makeConstraints { (make) in
            make.size.equalTo(nameTextField)
            make.centerX.equalTo(self.view)
            make.height.equalTo(60)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
    }
}
