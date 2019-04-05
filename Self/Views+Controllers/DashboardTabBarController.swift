import UIKit
import SnapKit

class DashboardTabBarController: UITabBarController {
    
    // MARK: - Views
    lazy var background: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        
        let circleOnePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwoPath = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePaths = CGMutablePath()
        circlePaths.addPath(circleOnePath.cgPath)
        circlePaths.addPath(circleTwoPath.cgPath)
        
        shapeLayer.fillColor = UIColor.app.other().cgColor
        shapeLayer.path = circlePaths
        shapeLayer.zPosition = -1
        return shapeLayer
    }()
    
    lazy var leftSwipe: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(handleSwipes(_:)))
        swipeGesture.direction = .left
        return swipeGesture
    }()
    lazy var rightSwipe: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(handleSwipes(_:)))
        swipeGesture.direction = .right
        return swipeGesture
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        setUpTabBarViewControllers()
        setup()
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            animateBackground(selectedIndex)
            animateToTab(toIndex: selectedIndex)
        }
    }

    override var selectedIndex: Int {
        didSet {
            animateBackground(selectedIndex)
            animateToTab(toIndex: selectedIndex)
        }
    }
        
    func setup() {
        view.backgroundColor = UIColor.app.background()
        
        tabBar.clipsToBounds = true
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.app.background().cgColor
        tabBar.layer.backgroundColor = UIColor.app.background().cgColor
        tabBar.barTintColor =  UIColor.app.background()
        tabBar.tintColor = UIColor.app.buttonText()
        tabBar.unselectedItemTintColor = UIColor.app.solidText()
        view.layer.addSublayer(background)
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    func setUpTabBarViewControllers() {
        
        let homeNavigationController: UIViewController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [HomeViewController()]
            navigationController.title = "Home"
            navigationController.tabBarItem?.image = UIImage(named: "home")
            return navigationController
        }()
        
        let highlightsNavigationController: UIViewController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [HighlightsViewController()]
            navigationController.title = "Highlights"
            navigationController.tabBarItem?.image = UIImage(named: "for_you")
            return navigationController
        }()
        
        let actionsNavigationController: UIViewController = {
            let navigationController = DashboardNavigationController()
            navigationController.viewControllers = [ActionsViewController()]
            navigationController.title = "Actions"
            navigationController.tabBarItem?.image = UIImage(named: "globe")
            return navigationController
        }()
        
        self.viewControllers = [highlightsNavigationController, homeNavigationController, actionsNavigationController,]
        self.selectedIndex = 1
    }
    
    func animateBackground(_ selectedIndex: Int) {
        let newBackgroundPaths = CGMutablePath()
        if selectedIndex == 0 {
            // Highlights
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 450,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 400,y: 650), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        } else if selectedIndex == 1 {
            // Home
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        } else if selectedIndex == 2 {
            // Challenges
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: -50,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 0,y: 650), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        }
        
        let backgroundAnimation = CABasicAnimation(keyPath: "path")
        backgroundAnimation.fromValue = self.background.path
        backgroundAnimation.toValue = newBackgroundPaths
        backgroundAnimation.duration = 0.3
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.background.path = newBackgroundPaths
        self.background.add(backgroundAnimation, forKey: "path")
    }
    
    // MARK: - Functions
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left && (selectedIndex + 1) <= (self.viewControllers?.count)! - 1 {
            animateToTab(toIndex: self.selectedIndex + 1)
            self.selectedIndex += 1
        }
        if sender.direction == .right && (selectedIndex - 1) >= 0 {
            animateToTab(toIndex: self.selectedIndex - 1)
            self.selectedIndex -= 1
        }
    }
    
}

// MARK: - TabBar Delegate
extension DashboardTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers,
            let toIndex = tabViewControllers.index(of: viewController)
        else { return false }
        animateToTab(toIndex: toIndex)
        return true
    }
    
    func animateToTab(toIndex: Int) {
        print(toIndex)
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController,
            let oldView = selectedVC.view,
            let newView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.index(of: selectedVC),
            fromIndex != toIndex
        else { return }
        
        oldView.superview?.addSubview(newView)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        newView.center = CGPoint(x: oldView.center.x + offset, y: newView.center.y)
        
        // Temperarily disable tabbar during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut, .transitionCrossDissolve, .preferredFramesPerSecond60],
                       animations: {
                            oldView.center = CGPoint(x: oldView.center.x - offset, y: oldView.center.y)
                            newView.center = CGPoint(x: newView.center.x - offset, y: newView.center.y)
                            oldView.layer.opacity = 0
                            newView.layer.opacity = 1
        }, completion: { finished in
            oldView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}
