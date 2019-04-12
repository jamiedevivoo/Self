import UIKit

class ViewController: UIViewController {

}

// MARK: - Overrides
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

// MARK: - Set Up
extension ViewController {
    func setupViewController() {
        view.backgroundColor = UIColor.app.background.primaryBackground()
    }
}
