import UIKit
import SnapKit

class AppContainerViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.app.background.primaryBackground()
        AppManager.shared.appContainer = self
    }
}

