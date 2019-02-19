import UIKit
import SnapKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Profile Screen")
        view.backgroundColor = .brown
        
        let settings = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItems = [settings]
        
    }
    
    @objc func settingsButtonTapped() {
        print("Settings Button Tapped")
        let settingsViewController = SettingsViewController()
        settingsViewController.title = "Settings"
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
}
