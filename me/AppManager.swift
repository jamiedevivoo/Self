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
            
            let homeNavigationController = MainNavigationController()
            let homeViewController = HomeViewController()
            homeViewController.title = "Home"
            homeNavigationController.title = "Home"
            homeNavigationController.viewControllers = [homeViewController]
            
            let journalNavigationController = MainNavigationController()
            let journalViewController = JournalViewController()
            journalViewController.title = "Stats"
            journalNavigationController.title = "Stats"
            journalNavigationController.viewControllers = [journalViewController]
            
            let challengesNavigationController = MainNavigationController()
            let challengesViewController = ChallengesViewController()
            challengesViewController.title = "Challenges"
            challengesNavigationController.title = "Challenges"
            challengesNavigationController.viewControllers = [challengesViewController]
            
            let communitiesNavigationController = MainNavigationController()
            let communitiesViewController = CommunitiesViewController()
            communitiesViewController.title = "Communities"
            communitiesNavigationController.title = "Communities"
            communitiesNavigationController.viewControllers = [communitiesViewController]
            
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
            
            homeTabBarController.viewControllers = [communitiesNavigationController, journalNavigationController, challengesNavigationController, homeNavigationController]
            
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
