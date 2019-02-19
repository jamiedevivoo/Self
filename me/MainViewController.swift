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
        let welcomeText = UITextView()
        let mainButton = UIButton()
        
        subViewOne.backgroundColor = .red
        subViewTwo.backgroundColor = .purple
        subViewThree.backgroundColor = .blue
        subViewFour.backgroundColor = .green
        
        welcomeText.text = "Welcome " + (AccountManager.shared.user?.email)!
        welcomeText.backgroundColor = .none
        
        mainButton.backgroundColor = .black
        mainButton.addTarget(self, action: #selector(MainViewController.buttonTapped), for: .touchUpInside)
        mainButton.setTitle("View Friends Profile", for: .normal)

        self.view.addSubview(subViewOne)
        self.view.addSubview(subViewTwo)
        self.view.addSubview(subViewThree)
        self.view.addSubview(subViewFour)
        self.view.addSubview(mainButton)
        self.view.addSubview(welcomeText)
        
        UIView.animate(withDuration: 1) {
            welcomeText.snp.makeConstraints { (make) in
                make.height.equalTo(100)
                make.width.equalTo(200)
                make.top.equalTo(self.view).offset(100)
                make.centerX.equalTo(self.view)
            }
            mainButton.snp.makeConstraints { (make) in
                make.height.equalTo(100)
                make.width.equalTo(200)
                make.center.equalTo(self.view)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
