import UIKit

class ChallengesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Challenges Screen Created")
        view.backgroundColor = .purple

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
