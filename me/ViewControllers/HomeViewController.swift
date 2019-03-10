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
        self.navigationItem.title = greeting() + " \(self.user?.name ?? "No Value")!"
    
        self.view.addSubview(topView)
    }
    
    func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        print(hour)
        
        switch hour {
        case 00...01:
            return "Night"
        case 01...04:
            return "Night"
        case 04...06:
            return "Early Morning"
        case 06...10:
            return "Morning"
        case 10...13:
            return "Morning"
        case 13...17:
            return "Afternoon"
        case 17...22:
            return "Evening"
        case 22...24:
            return "Night"
        default:
            return "Welcome"
        }
    }
    
}

extension HomeViewController: ConstraintBuilding {
    func addConstraints() {
        topView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.greaterThanOrEqualTo(300)
        }
        
    }
}
