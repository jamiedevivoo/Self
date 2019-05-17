import UIKit
import SnapKit
import Firebase

final class SettingsViewController: ViewController {
    
    // MARK: - Properties
    lazy var headerLabel = HeaderLabel("Looking for something?", HeaderLabel.HeaderType.section)
    lazy var exitButton = IconButton(UIImage(named: "back")!, action: #selector(exit), .standard)
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.App.Background.secondary()
        return view
    }()
    
    lazy var settingsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.App.Background.primary()
        table.isScrollEnabled = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    lazy var settingOptions: [(label:String, destination: UIViewController)] = [
        ("Account Settings", AccountSettingsViewController()),
        ("App Settings", AppSettingsViewController()),
        ("Help Information", HelpSOSViewController()),
        ("Acknowledgement", AcknowledgementViewController())
    ]
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        settingsTableView.tableFooterView = UIView()
        
        setupChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let selectedCell = settingsTableView.indexPathForSelectedRow {
//            settingsTableView.deselectRow(at: selectedCell, animated: false)
//        }
        
    }
}

// MARK: - Extension: Table View Controller

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ settingsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count + 1
    }
    
    func tableView(_ settingsTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        
        if indexPath.row < settingOptions.count {
            cell.textLabel?.text = settingOptions[indexPath.row].label
            cell.textLabel?.textColor = UIColor.App.Text.text()
        } else {
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = UIColor.App.Colour(.Red)
        }
        cell.backgroundColor = UIColor.App.Background.primary()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cell.frame.size = CGSize(width: view.frame.width, height: 30)
        return cell
    }
    
    func tableView(_ settingsTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < settingOptions.count {
            navigationController?.pushViewController(settingOptions[indexPath.row].destination, animated: true)
        } else {
            AccountManager.logout()
        }
    }
    
    @objc func exit() {
        navigationController?.popToRootViewController(animated: true)
    }

}

// MARK: - Extension: Constraints Building

extension SettingsViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(settingsTableView)
        view.addSubview(topView)
        topView.addSubview(headerLabel)
        topView.addSubview(exitButton)
        
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(headerLabel.snp.bottom).offset(20)
        }
            exitButton.applyConstraints(forPosition: .topLeft, inVC: self)
            headerLabel.snp.makeConstraints { make in
                make.centerY.equalTo(exitButton.snp.centerY)
                make.right.equalToSuperview().inset(30)
                make.left.equalTo(exitButton.snp.right).offset(5)
            }
        settingsTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}
