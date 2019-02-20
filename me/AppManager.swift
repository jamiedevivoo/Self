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
            
            let dashboardNavigationController = MainNavigationController()
            let dashboardViewController = DashboardViewController()
            dashboardViewController.title = "Home"
            dashboardNavigationController.title = "Home"
            dashboardNavigationController.viewControllers = [dashboardViewController]
            
            let statsNavigationController = MainNavigationController()
            let statsViewController = StatsViewController()
            statsViewController.title = "Stats"
            statsNavigationController.title = "Stats"
            statsNavigationController.viewControllers = [statsViewController]
            
            let challengesNavigationController = MainNavigationController()
            let challengesViewController = ChallengesViewController()
            challengesViewController.title = "Challenges"
            challengesNavigationController.title = "Challenges"
            challengesNavigationController.viewControllers = [challengesViewController]
            
            
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
            
            homeTabBarController.viewControllers = [dashboardNavigationController, statsNavigationController, challengesNavigationController]
            
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
