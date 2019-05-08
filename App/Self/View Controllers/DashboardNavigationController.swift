import UIKit
import SnapKit

class DashboardNavigationController: UINavigationController {
    
    // MARK: - Views
    lazy var sidebarIcon: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "menu")
        button.style = .plain
        button.target = self
        button.action = #selector(sidebarButtonTapped)
        button.tintColor = UIColor.App.Text.text()
        return button
    }()
}

// MARK: - Init and Setup
extension DashboardNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setup()
    }
    
    func setup() {
        visibleViewController?.navigationItem.rightBarButtonItems = [sidebarIcon]
        //        navigationBar.isHidden = true
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        tabBarItem.badgeColor = UIColor.red
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Functions
extension DashboardNavigationController {
    @objc func sidebarButtonTapped() {
        pushViewController(SettingsViewController(), animated: true)
        //        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Navigation Controller Delegate
extension DashboardNavigationController: UINavigationControllerDelegate {
    
}
