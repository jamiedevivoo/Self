import UIKit
import SnapKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    lazy var background: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        
        let circleOnePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwoPath = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePaths = CGMutablePath()
        circlePaths.addPath(circleOnePath.cgPath)
        circlePaths.addPath(circleTwoPath.cgPath)
        
        shapeLayer.fillColor = UIColor.app.standard.other().cgColor
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
        view.backgroundColor = UIColor.app.standard.background()
        
        tabBar.clipsToBounds = true
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.app.standard.background().cgColor
        
        tabBar.layer.backgroundColor = UIColor.app.standard.button().cgColor
        tabBar.barTintColor =  UIColor.app.standard.background()
        tabBar.tintColor = UIColor.app.standard.buttonText()
        tabBar.unselectedItemTintColor = UIColor.app.standard.solidText()
        view.layer.addSublayer(background)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let newBackgroundPaths = CGMutablePath()
        
        if tabBarController.selectedIndex == 0 {
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 450,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 400,y: 650), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        } else if tabBarController.selectedIndex == 1 {
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        } else if tabBarController.selectedIndex == 2 {
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: -50,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 0,y: 650), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        }
        
        let backgroundAnimation = CABasicAnimation(keyPath: "path")
        backgroundAnimation.fromValue = self.background.path
        backgroundAnimation.toValue = newBackgroundPaths
        backgroundAnimation.duration = 0.3
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.background.path = newBackgroundPaths
        self.background.add(backgroundAnimation, forKey: "path");

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let fromView = selectedViewController?.view
        let toView = viewController.view
        
        if fromView !== toView {
            UIView.transition(from: fromView!, to: toView!, duration: 0.2, options: [.transitionCrossDissolve, .curveEaseInOut], completion: nil)
        } else {
            
        }
        
        return true
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
