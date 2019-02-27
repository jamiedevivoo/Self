import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    var appContainer: AppContainerViewController!
    
    private init() { }
    
    func showApp() {
        
        
        if Auth.auth().currentUser == nil {
            
            let loginNavigationController = MainNavigationController()
            let loginViewController = LoginViewController()

            loginNavigationController.viewControllers = [loginViewController]
            loginNavigationController.title = "Login"
            
            appContainer.present(loginNavigationController, animated: true, completion: nil)
            print("LOG: USER IS NOT LOGGED IN")
        } else {
            print("LOG: USER IS LOGGED IN")
            
            AccountManager.shared.loadUser { [unowned self] in
                self.appContainer.present(MainTabBarController(), animated: true, completion: nil)
                print(AccountManager.shared.user!)
            }
            
        }
        
        
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func loadLoggedInView() {
        
    }
    
}
