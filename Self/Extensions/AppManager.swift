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
    
    
    // MARK: - Init
    private init() { }
    
    
    // MARK: - Functions
    
    func showApp() {
        if Auth.auth().currentUser == nil {
            appContainer.present(NavigationController(), animated: true, completion: nil)
        } else {
            AccountManager.shared.loadUser { [unowned self] in
                self.appContainer.present(TabBarController(), animated: true, completion: nil)
            }
        }
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
