import UIKit

class ViewController: UIViewController {

}

// MARK: - Overrides
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Set Up
extension ViewController {
    func setupViewController() {
        updateBackgroundColour()
        navigationController?.isNavigationBarHidden = true
    }
    func updateBackgroundColour() {
        view.backgroundColor = UIColor.App.Background.primary()
    }
}
