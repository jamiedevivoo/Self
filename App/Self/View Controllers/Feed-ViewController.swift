import UIKit
import SnapKit
import Firebase

extension FeedViewController: ViewIsDependantOnAccountData { }

class FeedViewController: UIViewController {
    
    lazy var actionListViewController = FeedActionListChildViewController(accountRef: self.accountRef)
    lazy var messageViewController = FeedMessageChildViewController(accountRef: self.accountRef)
}

// MARK: - Overrides
extension FeedViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
        
        let collectionRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid).collection("mood_logs")
        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                if let error = error { print("Error Loading User Data: \(error.localizedDescription)") }
                return
            }
            print(snapshot)
            for document in snapshot.documents {
                var documentData = document.data()
                documentData["uid"] = document.documentID
                print(documentData as AnyObject)
                print(Mood.Log(documentData).dictionary as AnyObject)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - View Building
extension FeedViewController: ViewBuilding {
    
    func setTabBarItem() {
        navigationController?.title = "Home"
        navigationController?.tabBarItem.image = UIImage(named: "home-outline")
        navigationController?.tabBarItem.selectedImage = UIImage(named: "home-dot")
    }
    
    func addSubViews() {
        add(actionListViewController)
        add(messageViewController)
        self.view.addSubview(messageViewController.view)
        self.view.addSubview(actionListViewController.view)
    }
    
    func setupChildViews() {
        messageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalTo(actionListViewController.view.snp.top).offset(-20)
            make.height.greaterThanOrEqualTo(messageViewController.messageStackView.snp.height).priority(.required)
        }
        actionListViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(actionListViewController.actionButtonStack.snp.height).offset(50)
        }
    }
}
