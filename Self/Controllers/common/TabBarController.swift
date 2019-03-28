import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    lazy var background: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        
        let circleOnePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwoPath = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePaths = CGMutablePath()
        circlePaths.addPath(circleOnePath.cgPath)
        circlePaths.addPath(circleTwoPath.cgPath)
        
        shapeLayer.fillColor = UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1).cgColor
        shapeLayer.strokeColor = UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.path = circlePaths
        shapeLayer.zPosition = -1
        return shapeLayer
    }()
    
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
        view.layer.addSublayer(background)
    }
    
    fileprivate func checkLoggedInUserStatus() {
        
    }
    
    fileprivate func setUpTabBarViewControllers() {
        
        let homeNavigationController: DashboardNavigationController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [HomeViewController()]
            navigationController.title = "Home"
            navigationController.tabBarItem?.image = UIImage(named: "home")
            return navigationController
        }()
        
        let journalNavigationController: DashboardNavigationController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [JournalViewController()]
            navigationController.title = "Journal"
            navigationController.tabBarItem?.image = UIImage(named: "for_you")
            return navigationController
        }()
        
        let challengesNavigationController: DashboardNavigationController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [ChallengesViewController()]
            navigationController.title = "Challenges"
            navigationController.tabBarItem?.image = UIImage(named: "globe")
            return navigationController
        }()
        
        self.viewControllers = [journalNavigationController, homeNavigationController, challengesNavigationController,]
        self.selectedIndex = 1
    }
}
