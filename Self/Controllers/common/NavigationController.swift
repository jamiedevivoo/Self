import UIKit
import SnapKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [LaunchViewController()]
        setup()
    }
    
    func setup() {
        title = "Self"
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
}
