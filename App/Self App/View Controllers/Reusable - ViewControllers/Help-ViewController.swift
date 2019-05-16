import UIKit
import SnapKit
import Firebase

class HelpViewController: ViewController {
    
    // MARK: - Views
    lazy var exitButton = IconButton(UIImage(named: "back")!, action: #selector(exit), .standard)
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Functions
    
}

// MARK: - Extension: Table View Controller

extension HelpViewController {
    
    @objc func exit() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Extension: Constraints Building

extension HelpViewController: ViewBuilding {
    func setupChildViews() {
        view.addSubview(exitButton)
        exitButton.applyConstraints(forPosition: .topLeft, inVC: self)
    }
}
