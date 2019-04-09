import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    var appContainer: AppContainerViewController! {
        didSet {
            AppManager.shared.showApp()
        }
    }
    
    var state: State = .unregistered  {
        didSet(oldState) {
            // FIXME: Should probably make sure the view isn't dismissed if the new state is the same as the old state
            self.appContainer.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Init
    private init() {
        if Auth.auth().currentUser !== nil {
            self.state = .loggedIn(Auth.auth().currentUser!)
        }
    }
}

// MARK: - Show App
extension AppManager {
    func showApp() {
        switch self.state {
        case .loggedIn(_):
            AccountManager.shared.loadUser { [unowned self] in
                self.appContainer.present(DashboardTabBarController(), animated: true, completion: nil)
            }
        case .sessionExpired(_):
            self.appContainer.present(LoginViewController(), animated: true, completion: nil)
        default:
            self.appContainer.present(LaunchNavigationController(), animated: true, completion: nil)
        }
    }
}

// Mark: - State
extension AppManager {
    enum State {
        case unregistered
        case loggedIn(User)
        case sessionExpired(UserInfo)
    }
}
