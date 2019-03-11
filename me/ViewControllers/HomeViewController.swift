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
    
    lazy var messageBox: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var messageText: UILabel = {
        let label = UILabel()
        label.text = greeting() + " \(self.user?.name ?? "No Value")!"
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init and ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addConstraints()
    }
    
    func setup() {
        self.user = AccountManager.shared.user
        self.navigationItem.title = "Home"
    
        self.view.addSubview(topView)
        topView.addSubview(messageBox)
        messageBox.addSubview(messageText)

    }
    
    func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
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
        messageBox.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(100)
            make.width.equalTo(topView.snp.width).inset(20)
            make.centerX.equalTo(topView)
            make.centerY.equalTo(topView.snp.bottomMargin)
        }
        messageText.snp.makeConstraints { (make) in
            make.height.equalTo(messageBox.snp.height).inset(10)
            make.width.equalTo(messageBox.snp.width).inset(10)
            make.centerX.equalTo(messageBox)
            make.centerY.equalTo(messageBox)
        }
        
    }
}
