import UIKit
import SnapKit
import Firebase

class LoggedInViewController: UIViewController {
    
    let uid: String = Auth.auth().currentUser!.uid
    var db: Firestore = Firestore.firestore()
    
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
