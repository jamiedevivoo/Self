import UIKit
import SnapKit

class LaunchNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [LoginViewController()]
        setup()
    }
    
    func setup() {
        title = "Login"
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
}
