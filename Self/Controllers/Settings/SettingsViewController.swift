import UIKit
import SnapKit
import Firebase

class SettingsViewController: UIViewController {
    
    
    // MARK: - Properties
    
    lazy var topDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.secondaryBackground()
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Use this page to modify your account and app settings."
        label.textAlignment = .left
        label.textColor = UIColor.app.text.solidText()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var settingsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.app.background.primaryBackground()
        table.isScrollEnabled = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    var settingOptions = ["Account Settings","App Settings","Logout"]
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = UIColor.app.background.primaryBackground()
        navigationItem.leftBarButtonItems = nil
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        settingsTableView.tableFooterView = UIView()
        
        addSubViews()
        addConstraints()
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
        cell.backgroundColor = UIColor.app.background.primaryBackground()
        if settingTitle == "Logout" { cell.textLabel?.textColor = .red }
        return cell
    }
    
    func tableView(_ settingsTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell Selected \(indexPath)")
        
        if indexPath.row == 0 {
            navigationController?.pushViewController(AccountSettingsViewController(), animated: true);
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(AppSettingsViewController(), animated: true);
        } else if indexPath.row == 2 {
            AccountManager.logout()
        }
    }

}

// MARK: - Extension: Constraints Building

extension SettingsViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(topDescriptionView)
        topDescriptionView.addSubview(pageTipLabel)
        self.view.addSubview(settingsTableView)
    }
    
    func addConstraints() {
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
    }
}
