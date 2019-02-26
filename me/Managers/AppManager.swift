import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    var appContainer: AppContainerViewController!
    
    private init() { }
    
    func showApp() {
        
        var newViewController: UIViewController
        
        if Auth.auth().currentUser == nil {
            
            let loginNavigationController = MainNavigationController()
                let loginViewController = LoginViewController()
                loginViewController.title = "Login"
            loginNavigationController.title = "Login"
            loginNavigationController.viewControllers = [loginViewController]
            
            newViewController = loginNavigationController
            print("LOG: USER IS NOT LOGGED IN")
        } else {
            print("LOG: USER IS LOGGED IN")
            
            let homeTabBarController = MainTabBarController()
            newViewController = homeTabBarController
        }
        appContainer.present(newViewController, animated: true, completion: nil)
        
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func loadLoggedInView() {
        
    }
    
}
