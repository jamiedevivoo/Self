import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpViewControllers()
    }
    
    fileprivate func checkLoggedInUserStatus() {
        
    }
    
    fileprivate func setUpViewControllers() {
        
        let homeNavigationController = MainNavigationController()
        let homeViewController = HomeViewController()
        homeNavigationController.title = "Home"
        homeNavigationController.viewControllers = [homeViewController]
        
        let journalNavigationController = MainNavigationController()
        let journalViewController = JournalViewController()
        journalNavigationController.title = "Journal"
        journalNavigationController.viewControllers = [journalViewController]
        
        let challengesNavigationController = MainNavigationController()
        let challengesViewController = ChallengesViewController()
        challengesNavigationController.title = "Challenges"
        challengesNavigationController.viewControllers = [challengesViewController]
        
        let communitiesNavigationController = MainNavigationController()
        let communitiesViewController = CommunitiesViewController()
        communitiesNavigationController.title = "Communities"
        communitiesNavigationController.viewControllers = [communitiesViewController]
        
//        let profileNavigationController = MainNavigationController()
//        let profileViewController = ProfileViewController()
//        profileViewController.title = "Your Profile"
//        profileNavigationController.title = "Your Profile"
//        profileNavigationController.viewControllers = [profileViewController]
//
//        let settingsNavigationController = MainNavigationController()
//        let settingsViewController = SettingsViewController()
//        settingsViewController.title = "Settings"
//        settingsNavigationController.title = "Settings"
//        settingsNavigationController.viewControllers = [settingsViewController]
        
        viewControllers = [communitiesNavigationController, journalNavigationController, challengesNavigationController, homeNavigationController]
        selectedIndex = 3
    }
    
    
    
}
