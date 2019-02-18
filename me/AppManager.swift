import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    var appContainer: LaunchViewController!
    
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
            
            let dashboardTabBarController = MainTabBarController()
            
                let homeNavigationController = MainNavigationController()
                    let homeViewController = MainViewController()
                    homeViewController.title = "Home"
                homeNavigationController.title = "Home"
                homeNavigationController.viewControllers = [homeViewController]

            
                let profileNavigationController = MainNavigationController()
                    let profileViewController = ProfileViewController()
                    profileViewController.title = "Your Profile"
                profileNavigationController.title = "Your Profile"
                profileNavigationController.viewControllers = [profileViewController]

            
                let settingsNavigationController = MainNavigationController()
                    let settingsViewController = SettingsViewController()
                    settingsViewController.title = "Settings"
                settingsNavigationController.title = "Settings"
                settingsNavigationController.viewControllers = [settingsViewController]
    
            dashboardTabBarController.viewControllers = [homeNavigationController, profileNavigationController, settingsNavigationController]
            
            newViewController = dashboardTabBarController
            print("LOG: USER IS LOGGED IN")
        }
        appContainer.present(newViewController, animated: true, completion: nil)
        
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
