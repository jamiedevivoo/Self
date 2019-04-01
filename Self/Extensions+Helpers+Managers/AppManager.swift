import UIKit
import Firebase

class AppManager {
    
    // MARK: - Types
    enum State {
        case unregistered
        case loggedIn(User)
        case sessionExpired(UserInfo)
    }
    
    enum ColorMode {
        case light
        case dark
    }
    
    // MARK: - Properties
    static let shared = AppManager()
    var appContainer: AppContainerViewController!

    var state: State = .unregistered  {
        didSet(oldState) {
            self.appContainer.dismiss(animated: true, completion: nil)
        }
    }
    
    var colorMode: ColorMode = {
        if Calendar.current.component(.hour, from: Date()) > 08 && Calendar.current.component(.hour, from: Date()) < 19 {
            return ColorMode.light
        } else {
            return ColorMode.dark
        }
    }()

    // MARK: - Init
    private init() {
        if Auth.auth().currentUser !== nil {
            self.state = .loggedIn(Auth.auth().currentUser!)
        }
    }
    
    // MARK: - Functions
    func showApp() {
        switch self.state {
        case .loggedIn(_):
            AccountManager.shared.loadUser { [unowned self] in
                self.appContainer.present(DashboardTabBarController(), animated: true, completion: nil)
            }
            
        case .sessionExpired(_):
            self.appContainer.present(LoginViewController(), animated: true, completion: nil)
            
        default:
            let loggedOutNavigationController: UINavigationController = {
                let navigationController = UINavigationController()
                navigationController.title = "Self"
                navigationController.view.backgroundColor = UIColor.app.background()
                navigationController.navigationBar.barTintColor = UIColor.app.solidText()
                navigationController.navigationBar.tintColor = UIColor.app.solidText()
                navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                navigationController.navigationBar.shadowImage = UIImage()
                navigationController.navigationBar.isTranslucent = true
                navigationController.viewControllers = [LaunchViewController()]
                return navigationController
            }()
            self.appContainer.present(loggedOutNavigationController, animated: true, completion: nil)
        }
    
    }
    
    
    
}
