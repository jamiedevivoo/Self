import UIKit
import SnapKit

class HomeNavigationController: UINavigationController {
    
    
    // MARK: - Views
    
    lazy var sidebarIcon: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Sidebar"
        button.style = .plain
        button.target = self
        button.action = #selector(sidebarButtonTapped)
        return button
    }()
    
    
    // MARK: - Init and viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    // Mark: - Functions
    
    func setup() {
        navigationController?.navigationItem.leftBarButtonItems = [sidebarIcon]
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    
    // MARK: - Actions
    
    @objc func sidebarButtonTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
}
