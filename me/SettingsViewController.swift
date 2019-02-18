import UIKit
import SnapKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOG: Settings Screen")

        view.backgroundColor = .gray
        
        let accountSettingsButton = UIButton()
        let logoutButton = UIButton()
        
        accountSettingsButton.backgroundColor = .white
        accountSettingsButton.addTarget(self, action: #selector(SettingsViewController.accountSettingsButtonAction), for: .touchUpInside)
        accountSettingsButton.setTitle("Account Settings", for: .normal)
        accountSettingsButton.setTitleColor(.black, for: .normal)
        
        logoutButton.backgroundColor = .black
        logoutButton.addTarget(self, action: #selector(SettingsViewController.logoutButtonAction), for: .touchUpInside)
        logoutButton.setTitle("Logout", for: .normal)
        
        self.view.addSubview(logoutButton)
        self.view.addSubview(accountSettingsButton)
        
        UIView.animate(withDuration: 1) {
            accountSettingsButton.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(100)
                make.center.equalTo(self.view)
            }
            logoutButton.snp.makeConstraints { (make) in
                make.size.equalTo(100)
                make.centerX.equalTo(self.view)
                make.top.equalTo(accountSettingsButton.snp.bottom).offset(20)
            }
        }
        
    }
    
    @objc func logoutButtonAction() {
        print("Lougout Tapped")
        AppManager.shared.logout()
    }
    @objc func accountSettingsButtonAction() {
        print("Account Settings Tapped")
        
        let accountSettingsViewController = AccountSettingsViewController()
        accountSettingsViewController.title = "Account Settings"
        navigationController?.pushViewController(accountSettingsViewController, animated: true)
    }
    
}
