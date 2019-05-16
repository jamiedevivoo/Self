import UIKit
import SnapKit

final class AppContainerViewController: ViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppManager.shared.appContainer = self
    }
}
