import UIKit
import SnapKit

class DashboardNavigationController: UINavigationController {
}

// MARK: - Init and Setup
extension DashboardNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setup()
    }
    
    func setup() {
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        tabBarItem.badgeColor = UIColor.red
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        tabBarController?.leavingRootView()
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Navigation Controller Delegate
extension DashboardNavigationController: UINavigationControllerDelegate {
    
}
