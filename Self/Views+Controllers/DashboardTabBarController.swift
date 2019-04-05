import UIKit
import SnapKit

class DashboardTabBarController: UITabBarController {
    
    // MARK: - Views
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
        setupView()
        setUpTabBarViewControllers()
        styleTabBar()
    }
    
    func setupView() {
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
        BackgroundController.shared.backgroundContainer = self
        BackgroundController.shared.addBackground()
    }
    
    func styleTabBar() {
        tabBar.clipsToBounds = true
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.app.background().cgColor
        tabBar.layer.backgroundColor = UIColor.app.background().cgColor
        tabBar.barTintColor =  UIColor.app.background()
        tabBar.tintColor = UIColor.app.buttonText()
        tabBar.unselectedItemTintColor = UIColor.app.solidText()
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
    
    // MARK: - Functions
    override var selectedViewController: UIViewController? {
        didSet {
            BackgroundController.shared.tabSwitchAnimation(selectedIndex)
            animateToTab(toIndex: selectedIndex)
        }
    }
    
    override var selectedIndex: Int {
        didSet {
            BackgroundController.shared.tabSwitchAnimation(selectedIndex)
            animateToTab(toIndex: selectedIndex)
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.view ==  self.view {
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
