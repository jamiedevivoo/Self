import UIKit

class LoggedInViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let sidebar = SidebarViewController()
        
//        self.present(sidebar, animated: true, completion: nil)

        
        let settings = UIBarButtonItem(title: "Sidebar", style: .plain, target: self, action: #selector(sidebarButtonTapped))
        navigationItem.leftBarButtonItems = [settings]
    }
    
    @objc func sidebarButtonTapped() {
        print("Sidebar Button Tapped")
        let settingsViewController = SettingsViewController()
        settingsViewController.title = "Settings"
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
}
