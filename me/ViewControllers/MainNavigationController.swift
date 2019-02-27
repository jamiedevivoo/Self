import UIKit
import SnapKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = .white
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
}
