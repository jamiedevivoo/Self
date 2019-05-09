import UIKit
import SnapKit
import Firebase

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var topDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.App.Background.secondary()
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Use this page to modify your account and app settings."
        label.textAlignment = .left
        label.textColor = UIColor.App.Text.text()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let btnImage = UIImage(named: "back")
        btnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(btnImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = true
        button.tintColor = UIColor.darkText
        button.addTarget(self, action: #selector(exit), for: .touchUpInside)
        button.alpha = 0.5
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        return button
    }()
    
    lazy var settingsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.App.Background.primary()
        table.isScrollEnabled = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    var settingOptions = ["Account Settings", "App Settings", "Logout"]
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = UIColor.App.Background.primary()
        navigationItem.leftBarButtonItems = nil
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        settingsTableView.tableFooterView = UIView()
        
        addSubViews()
        setupChildViews()
    }
    
    // MARK: - Functions
    
}

// MARK: - Extension: Table View Controller

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ settingsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ settingsTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        let settingTitle = settingOptions[indexPath.row]
        cell.textLabel?.text = settingTitle
        cell.backgroundColor = UIColor.App.Background.primary()
        if settingTitle == "Logout" { cell.textLabel?.textColor = .red }
        return cell
    }
    
    func tableView(_ settingsTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell Selected \(indexPath)")
        
        if indexPath.row == 0 {
            navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(AppSettingsViewController(), animated: true)
        } else if indexPath.row == 2 {
            AccountManager.logout()
        }
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - Extension: Constraints Building

extension SettingsViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(topDescriptionView)
        topDescriptionView.addSubview(pageTipLabel)
        self.view.addSubview(settingsTableView)
        self.view.addSubview(exitButton)
    }
    
    func setupChildViews() {
        topDescriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(200)
        }
        pageTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topDescriptionView.snp.left).offset(20)
            make.right.equalTo(topDescriptionView.snp.right).offset(-20)
            make.top.equalTo(topDescriptionView.snp.top).offset(100)
        }
        settingsTableView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.top.equalTo(topDescriptionView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
}
