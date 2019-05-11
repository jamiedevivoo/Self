import UIKit
import SnapKit

class DashboardNavigationController: UINavigationController {
}

// MARK: - Init and Setup
extension DashboardNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setup()
    }
    
    func setup() {
        navigationBar.isHidden = true
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        tabBarItem.badgeColor = UIColor.red
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        tabBarController?.leavingRootView()
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Navigation Controller Delegate
extension DashboardNavigationController: UINavigationControllerDelegate {
    
}
