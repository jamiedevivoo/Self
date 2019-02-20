import UIKit
import SnapKit

class LoggedInContainerViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.view.addSubview(homeTabBarController)

    }

}
