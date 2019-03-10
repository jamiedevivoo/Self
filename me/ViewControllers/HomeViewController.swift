import UIKit
import SnapKit
import Firebase

class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    let profiles = FirebaseAPI.getProfiles()
    var user: User?

    
    // MARK: - UI and Views
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.primary
        return view
    }()

    // MARK: - Init and ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addConstraints()
    }
    
    func setup() {
        self.user = AccountManager.shared.user
        self.navigationItem.title = "Welcome \(self.user?.name ?? "No Value")"
    
        self.view.addSubview(topView)
    }
    
}

extension HomeViewController: ConstraintBuilding {
    func addConstraints() {
        topView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(200)
        }
        
    }
}
