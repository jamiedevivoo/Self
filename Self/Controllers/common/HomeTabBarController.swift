import UIKit
import SnapKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBarViewControllers()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.white.cgColor
        tabBar.clipsToBounds = true
    }
    
    fileprivate func checkLoggedInUserStatus() {
        
    }
    
    fileprivate func setUpTabBarViewControllers() {
        
        let homeNavigationController: HomeNavigationController = {
            let navigationController = HomeNavigationController()
            navigationController.viewControllers = [HomeViewController()]
            navigationController.title = "Home"
            navigationController.tabBarItem?.image = UIImage(named: "home")
            return navigationController
        }()
        
        let journalNavigationController: HomeNavigationController = {
            let navigationController = HomeNavigationController()
            navigationController.viewControllers = [JournalViewController()]
            navigationController.title = "Journal"
            navigationController.tabBarItem?.image = UIImage(named: "for_you")
            return navigationController
        }()
        
        let challengesNavigationController: HomeNavigationController = {
            let navigationController = HomeNavigationController()
            navigationController.viewControllers = [ChallengesViewController()]
            navigationController.title = "Challenges"
            navigationController.tabBarItem?.image = UIImage(named: "globe")
            return navigationController
        }()
        
        self.viewControllers = [journalNavigationController, homeNavigationController, challengesNavigationController,]
        self.selectedIndex = 1
    }
}
