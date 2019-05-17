import UIKit
import SnapKit
import Firebase
import NotificationBannerSwift

final class AccountSettingsViewController: ViewController {
    
    // MARK: - Properties
    var user: Account.User!
    
    // MARK: - SubViews
    lazy var headerLabel = HeaderLabel("Account Settings", HeaderLabel.HeaderType.section)
    lazy var exitButton = IconButton(UIImage(named: "back")!, action: #selector(exit), .standard)
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.App.Background.secondary()
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Use this page to modify the settings related to your account."
        label.textAlignment = .left
        label.textColor = UIColor.App.Text.text()
        label.numberOfLines = 0
        
        return label
    }()
    lazy var nameTextField = Textfield(placeholder: "First Name", fieldType: .text)
    lazy var emailTextField = Textfield(placeholder: "Email Address", fieldType: .email)
    lazy var updateButton = Button(title: "Update Details", action: #selector(AccountSettingsViewController.saveButtonAction), type: .primary)
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
                if let error = error {
                    let banner = GrowingNotificationBanner(title: "Problem", subtitle: error.localizedDescription, style: .danger)
                    banner.show()
                } else {
                    AccountManager.shared().accountRef?.user.name = name
                    AccountManager.shared().updateAccount {
                        let banner = NotificationBanner(title: "Success", subtitle: "Account updated", style: .success)
                        banner.show(bannerPosition: .bottom)
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
    
    
    // Target Actions
    @objc func exit() {
        navigationController?.popViewController(animated: true)
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
    
    func setupChildViews() {
        view.addSubview(topView)
        topView.addSubview(headerLabel)
        topView.addSubview(pageTipLabel)
        topView.addSubview(exitButton)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(updateButton)
        
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(pageTipLabel.snp.bottom).offset(20)
        }
            exitButton.applyConstraints(forPosition: .topLeft, inVC: self)
            headerLabel.snp.makeConstraints { make in
                make.centerY.equalTo(exitButton.snp.centerY)
                make.right.equalToSuperview().inset(30)
                make.left.equalTo(exitButton.snp.right).offset(5)
            }
            pageTipLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(headerLabel.snp.bottom).offset(10)
            }
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(30)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        updateButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.height.equalTo(60)
            make.width.equalToSuperview().inset(30)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
    }
}
