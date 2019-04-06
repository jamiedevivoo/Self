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
        let homeNavigationController = DashboardNavigationController(rootViewController: HomeViewController())
        homeNavigationController.title = "Home"
        homeNavigationController.tabBarItem?.image = UIImage(named: "home")
        let highlightsNavigationController = DashboardNavigationController(rootViewController: HighlightsViewController())
        highlightsNavigationController.title = "Highlights"
        highlightsNavigationController.tabBarItem?.image = UIImage(named: "for_you")
        let actionsNavigationController = DashboardNavigationController(rootViewController: ActionsViewController())
        actionsNavigationController.title = "Actions"
        actionsNavigationController.tabBarItem?.image = UIImage(named: "globe")
        
        self.viewControllers = [highlightsNavigationController, homeNavigationController, actionsNavigationController,]
        self.selectedIndex = 1
    }
    
    // MARK: - Functions
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        // FIXME: Needs to compare the view the gesture occured in to tab bar root view controllers and only move on if they're equal
        guard sender.view == self.view else { return }
        if sender.direction == .left && (selectedIndex + 1) <= (self.viewControllers?.count)! - 1 {
            transitionViewController(toIndex: self.selectedIndex + 1)
        }
        if sender.direction == .right && (selectedIndex - 1) >= 0 {
            transitionViewController(toIndex: self.selectedIndex - 1)
        }
    }
}

// MARK: - TabBar Delegate
extension DashboardTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers,
            let toIndex = tabViewControllers.index(of: viewController)
        else { return false }
        transitionViewController(toIndex: toIndex)
        return true
    }
    
    func transitionViewController(toIndex: Int) {
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

        BackgroundController.shared.tabSwitchAnimation(toIndex)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut, .transitionCrossDissolve, .preferredFramesPerSecond60],
                       animations: {
                            oldView.center = CGPoint(x: oldView.center.x - offset, y: oldView.center.y)
                            oldView.layer.opacity = 0
                            newView.center = CGPoint(x: newView.center.x - offset, y: newView.center.y)
                            newView.layer.opacity = 1
        }, completion: { finished in
            oldView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}
