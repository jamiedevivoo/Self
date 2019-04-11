import UIKit

class LaunchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
            title = "Self"
            view.backgroundColor = UIColor.app.background.primaryBackground()
            navigationBar.barTintColor = UIColor.app.text.solidText()
            navigationBar.tintColor = UIColor.app.text.solidText()
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            viewControllers = [LaunchScreenViewController()]
    }

}
