import UIKit
import SnapKit
import Firebase

class HomeViewController: LoggedInViewController {
    
    // MARK: - Properties
    
    var ref: DocumentReference!
    
    let profiles = FirebaseAPI.getProfiles()
    
    // MARK: - UI and Views
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(HomeViewController.buttonTapped), for: .touchUpInside)
        button.setTitle("View Friends Profile", for: .normal)
        return button
    }()
    
    lazy var profilesTableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        return table
    }()
    
    var user: User?
    
    // MARK: - Init and ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Dashboard Created")
        
        profilesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        db.collection("user").document(uid).getDocument() { document, error in
            if let error = error {
                print(error)
            } else {
                if let document = document {
                    self.user = User(snapshot: document)
                }
            }
            self.navigationItem.title = "Welcome \(self.user?.name ?? "No Value")"
        }
        setup()
        setupConstraints()
    }
    
    func setup() {
        
        self.view.addSubview(profilesTableView)
        self.view.addSubview(mainButton)
    }
    
    func setupConstraints() {
        self.profilesTableView.snp.makeConstraints{ (make) in
            make.size.equalTo(self.view)
        }
        self.mainButton.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.center.equalTo(self.view)
        }
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
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = profiles[indexPath.row].name
        return cell
    }
}
