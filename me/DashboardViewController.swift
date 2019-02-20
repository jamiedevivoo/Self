import UIKit
import SnapKit

class DashboardViewController: UIViewController {
    
    // Profile Summary Subview
    let profileSummarySubview = UIView()
    let focusCircle = UIView()
    let EngagementCircle = UIView()
    let PerspectiveCircle = UIView()
    let AwarenessCircle = UIView()
    let nameLabel = UILabel()
    let userMeImageView = UIImageView()

    // Task Subview
    let taskSummarySubview = UIView()
    let taskLabel = UILabel()

    // Group Summary Subview
    let socialSummarySubview = UIView()
    let groupLabel = UILabel()
    let mainButton = UIButton()

    // Stat Summary Subview
    let statSubview = UIView()
    let statLabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Dashboard Created")
        
        let profile = UIBarButtonItem(title: "Your Profile", style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItems = [profile]
        
        // Profile Summary View
        profileSummarySubview.backgroundColor = .blue
        focusCircle.layer.cornerRadius = 10
        EngagementCircle.layer.cornerRadius = 10
        PerspectiveCircle.layer.cornerRadius = 10
        AwarenessCircle.layer.cornerRadius = 10
        nameLabel.text = (AccountManager.shared.user?.email)!
        mainButton.backgroundColor = .black
        mainButton.addTarget(self, action: #selector(DashboardViewController.buttonTapped), for: .touchUpInside)
        mainButton.setTitle("View Friends Profile", for: .normal)
        
        self.view.addSubview(profileSummarySubview)
        self.view.addSubview(focusCircle)
        self.view.addSubview(EngagementCircle)
        self.view.addSubview(PerspectiveCircle)
        self.view.addSubview(AwarenessCircle)
        self.view.addSubview(nameLabel)
        self.view.addSubview(userMeImageView)
        self.view.addSubview(mainButton)
        
        UIView.animate(withDuration: 1) {
            self.profileSummarySubview.snp.makeConstraints { (make) in
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.top.equalTo(self.view)
                make.height.equalTo(self.view).multipliedBy(0.25)
            }
            self.mainButton.snp.makeConstraints { (make) in
                make.height.equalTo(100)
                make.width.equalTo(200)
                make.center.equalTo(self.view)
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc func profileButtonTapped() {
        print("Profile Button Tapped")
        let UserProfileViewController = ProfileViewController()
        
        UserProfileViewController.title = "Profile"
        navigationController?.pushViewController(UserProfileViewController, animated: true)
    }
    
    @objc func buttonTapped() {
        print("Button Tapped")
        let friendsProfileViewController = ProfileViewController()
        friendsProfileViewController.view.backgroundColor = .yellow
        friendsProfileViewController.title = "Friends Profile"
        navigationController?.pushViewController(friendsProfileViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
