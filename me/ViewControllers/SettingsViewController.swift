import UIKit
import SnapKit
import Firebase

class SettingsViewController: LoggedInViewController {
    
    // Mark: - Properties
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor.gray
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
    lazy var accountSettingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(SettingsViewController.accountSettingsButtonAction), for: .touchUpInside)
        button.setTitle("Account Settings", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(SettingsViewController.logoutButtonAction), for: .touchUpInside)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Settings Screen")

        setup()
        setupConstraints()
    }
    
    func setup() {
        title = "Settings"
        view.backgroundColor = .gray
        self.view.addSubview(topView)
        topView.addSubview(pageTipLabel)
        self.view.addSubview(logoutButton)
        self.view.addSubview(accountSettingsButton)
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
    
    // MARK: - Action Functions
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
