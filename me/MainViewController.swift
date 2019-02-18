import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOG: Main Screen")
        
        let subViewOne = UIView()
        let subViewTwo = UIView()
        let subViewThree = UIView()
        let subViewFour = UIView()
        let mainButton = UIButton()
        let logoutButton = UIButton()
        
        subViewOne.backgroundColor = .red
        subViewTwo.backgroundColor = .purple
        subViewThree.backgroundColor = .blue
        subViewFour.backgroundColor = .green
        
        mainButton.backgroundColor = .black
        mainButton.addTarget(self, action: #selector(MainViewController.buttonTapped), for: .touchUpInside)
        mainButton.setTitle("Test Button", for: .normal)
        
        logoutButton.backgroundColor = .black
        logoutButton.addTarget(self, action: #selector(MainViewController.logoutButton), for: .touchUpInside)
        logoutButton.setTitle("Logout", for: .normal)

        self.view.addSubview(subViewOne)
        self.view.addSubview(subViewTwo)
        self.view.addSubview(subViewThree)
        self.view.addSubview(subViewFour)
        self.view.addSubview(mainButton)
        self.view.addSubview(logoutButton)
        
        UIView.animate(withDuration: 1) {
            mainButton.snp.makeConstraints { (make) in
                make.size.equalTo(100)
                make.center.equalTo(self.view)
            }
            logoutButton.snp.makeConstraints { (make) in
                make.size.equalTo(100)
                make.centerX.equalTo(self.view)
                make.top.equalTo(mainButton.snp.bottom).offset(20)
            }
            subViewOne.snp.makeConstraints { (make) in
                make.size.equalTo(self.view).multipliedBy(0.5)
                make.left.equalTo(self.view)
                make.top.equalTo(self.view)
            }
            subViewTwo.snp.makeConstraints { (make) in
                make.size.equalTo(self.view).multipliedBy(0.5)
                make.bottom.equalTo(self.view)
                make.left.equalTo(self.view)
            }
            subViewThree.snp.makeConstraints { (make) in
                make.size.equalTo(self.view).multipliedBy(0.5)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            subViewFour.snp.makeConstraints { (make) in
                make.size.equalTo(self.view).multipliedBy(0.5)
                make.right.equalTo(self.view)
                make.top.equalTo(self.view)
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    
    @objc func buttonTapped() {
        print("Button Tapped")
        let friendsProfileViewController = ProfileViewController()
        friendsProfileViewController.title = "Friends Profile"
        navigationController?.pushViewController(friendsProfileViewController, animated: true)
    }
    
    @objc func logoutButton() {
        print("Lougout Tapped")
        AppManager.shared.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
