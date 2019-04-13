import UIKit
import Firebase

final class AppManager {
    
    static let shared: AppManager = {
        return AppManager()
    }()
    var appContainer: AppContainerViewController!
    private var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Init
    private init() {
        observeUserState()
    }
}

// Mark: - Firebase User Auth Listener
extension AppManager {
    private func observeUserState() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            print("Auth changed... ")
            self.appContainer.dismiss(animated: true, completion: nil)
            
            guard let _ = user else {
                print("... User no longer exists.")
                self.appContainer.present(LaunchNavigationController(), animated: true, completion: nil)
                return
            }
            
            print("... User now exists.")
            AccountManager.shared().loadAccount { [unowned self] in
                self.appContainer.present(DashboardTabBarController(), animated: true, completion: nil)
            }
        }
    }
}
