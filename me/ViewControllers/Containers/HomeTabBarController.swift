import UIKit
import SnapKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBarViewControllers()
        setup()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
    fileprivate func checkLoggedInUserStatus() {
        
    }
    
    fileprivate func setUpTabBarViewControllers() {
        
        let homeNavigationController: HomeNavigationController = {
            let navigationController = HomeNavigationController()
            navigationController.title = "Home"
            navigationController.viewControllers = [HomeViewController()]
            return navigationController
        }()
        
        let journalNavigationController: HomeNavigationController = {
            let navigationController = HomeNavigationController()
            navigationController.title = "Journal"
            navigationController.viewControllers = [JournalViewController()]
            return navigationController
        }()
        
        let challengesNavigationController: HomeNavigationController = {
            let navigationController = HomeNavigationController()
            navigationController.title = "Challenges"
            navigationController.viewControllers = [ChallengesViewController()]
            return navigationController
        }()
        
        let communitiesNavigationController: HomeNavigationController = {
            let navigationController = HomeNavigationController()
            navigationController.title = "Communities"
            navigationController.viewControllers = [CommunitiesViewController()]
            return navigationController
        }()
        
        viewControllers = [communitiesNavigationController, journalNavigationController, challengesNavigationController, homeNavigationController]
        selectedIndex = 3
    }
}
