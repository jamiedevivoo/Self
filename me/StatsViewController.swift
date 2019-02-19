import UIKit

class StatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Profile Screen Created")
        view.backgroundColor = .green
        
        let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItems = [profile]
    }
    
    @objc func profileButtonTapped() {
        print("Profile Button Tapped")
        let UserProfileViewController = ProfileViewController()
        UserProfileViewController.title = "Profile"
        navigationController?.pushViewController(UserProfileViewController, animated: true)
    }
}
