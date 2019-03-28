import UIKit
import Firebase

class AppManager {
    
    
    // MARK: - Properties
    
    static let shared = AppManager()
    var appContainer: AppContainerViewController!
    
    enum State {
        case unregistered
        case loggedIn(User)
        case sessionExpired(User)
    }
    
    var state: State = .unregistered
    
    enum ColorMode {
        case light
        case dark
    }
    
    var colorMode: ColorMode = .light
    

    // MARK: - Init
    private init() { }
    
    
    // MARK: - Functions
    
    func showApp() {
        if Auth.auth().currentUser == nil {
            
            let loggedOutNavigationController: UINavigationController = {
                let navigationController = UINavigationController()
                    navigationController.title = "Self"
                    navigationController.view.backgroundColor = .white
                    navigationController.navigationBar.barTintColor = .white
                    navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                    navigationController.navigationBar.shadowImage = UIImage()
                    navigationController.navigationBar.isTranslucent = true
                    navigationController.viewControllers = [LaunchViewController()]
                return navigationController
            }()
            
            appContainer.present(loggedOutNavigationController, animated: true, completion: nil)
        } else {
            AccountManager.shared.loadUser { [unowned self] in
                self.appContainer.present(DashboardTabBarController(), animated: true, completion: nil)
            }
        }
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
