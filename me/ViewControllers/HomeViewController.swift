import UIKit
import SnapKit
import Firebase

class HomeViewController: LoggedInViewController {
    
    // MARK: - Properties
    
    var db: Firestore!
    var ref: DocumentReference!
    
    // MARK: - UI and Views
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(HomeViewController.buttonTapped), for: .touchUpInside)
        button.setTitle("View Friends Profile", for: .normal)
        return button
    }()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Dashboard Created")
        navigationItem.title = "Home"
        
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        db.collection("user").document(uid).getDocument() { document, error in
            if let error = error {
                print(error)
            } else {
                
                self.user = User(snapshot: document as! DocumentSnapshot)
            }
        }
        
        welcomeLabel.text = "Welcome \(self.user?.name ?? "No Value")"
        
        // Profile Summary View
        
        self.view.addSubview(mainButton)
        self.view.addSubview(welcomeLabel)
        
        UIView.animate(withDuration: 1) {
            self.mainButton.snp.makeConstraints { (make) in
                make.height.equalTo(100)
                make.width.equalTo(200)
                make.center.equalTo(self.view)
            }
            self.welcomeLabel.snp.makeConstraints { (make) in
                make.height.equalTo(100)
                make.top.equalTo(100)
                make.left.right.equalTo(0)
            }
            
        }
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
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
