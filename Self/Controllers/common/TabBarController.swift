import UIKit
import SnapKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
        
        self.delegate = self
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let backgroundPaths = CGMutablePath()
        
        if tabBarController.selectedIndex == 0 {
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 400,y: 150), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 400,y: 700), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            backgroundPaths.addPath(circleOne.cgPath)
            backgroundPaths.addPath(circleTwo.cgPath)
        } else if tabBarController.selectedIndex == 1 {
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            backgroundPaths.addPath(circleOne.cgPath)
            backgroundPaths.addPath(circleTwo.cgPath)
        } else if tabBarController.selectedIndex == 2 {
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 50,y: 100), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 0,y: 700), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            backgroundPaths.addPath(circleOne.cgPath)
            backgroundPaths.addPath(circleTwo.cgPath)
        }
        
        UIView.animate(withDuration: 10.0) {
            self.background.path = backgroundPaths
        }

    }
    
    fileprivate func checkLoggedInUserStatus() {
    }
    
    fileprivate func setUpTabBarViewControllers() {
        
        let homeNavigationController: UIViewController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [HomeViewController()]
            navigationController.title = "Home"
            navigationController.tabBarItem?.image = UIImage(named: "home")
            return navigationController
        }()
        
        let journalNavigationController: UIViewController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [JournalViewController()]
            navigationController.title = "Journal"
            navigationController.tabBarItem?.image = UIImage(named: "for_you")
            return navigationController
        }()
        
        let challengesNavigationController: UIViewController = {
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
