import UIKit
import SnapKit

class DashboardNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    
    // MARK: - Views
    
    lazy var sidebarIcon: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "menu")
        button.style = .plain
        button.target = self
        button.action = #selector(sidebarButtonTapped)
        button.tintColor = UIColor.app.text.primary
        return button
    }()
    
    
    // MARK: - Init and viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setup()
    }
    
    // Mark: - Functions
    
    func setup() {
        visibleViewController?.navigationItem.rightBarButtonItems = [sidebarIcon]
//        navigationBar.isHidden = true
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }

    
    
    // MARK: - Actions
    
    @objc func sidebarButtonTapped() {
    pushViewController(SettingsViewController(), animated: true)
//        tabBarController?.tabBar.isHidden = true
    }
    
}

