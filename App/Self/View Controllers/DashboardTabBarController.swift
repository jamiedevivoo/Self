import UIKit
import SnapKit

extension DashboardTabBarController {
    
}

class DashboardTabBarController: UITabBarController {
    
    lazy var leftSwipe: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(handleSwipes(_:)))
        swipeGesture.direction = .left
        swipeGesture.delegate = self
        return swipeGesture
    }()
    lazy var rightSwipe: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(handleSwipes(_:)))
        swipeGesture.direction = .right
        swipeGesture.delegate = self
        return swipeGesture
    }()
    lazy var profileButton = IconButton(UIImage(named: "menu-vertical")!, action: #selector(showMenu), .standard)
    lazy var helpButton = IconButton(UIImage(named: "safety-float")!, action: #selector(showHelp), .standard)
    lazy var overlays: [UIView] = []
}

// MARK: - INIT
extension DashboardTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        BackgroundManager.shared.backgroundContainer = self
        
        setUpTabBarViewControllers()
        setupTabBar()
        setupProfileButton()
        setupHelpButton()
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
}

// MARK: - Add Items
extension DashboardTabBarController {
    func setUpTabBarViewControllers() {
        let homeViewController = FeedViewController()
        let homeNavigationController = DashboardNavigationController(rootViewController: homeViewController)
        homeViewController.setTabBarItem()
        
        let highlightsViewController = HighlightsViewController()
        let highlightsNavigationController = DashboardNavigationController(rootViewController: highlightsViewController)
        highlightsViewController.setTabBarItem()
        
        let actionsViewController = ActionsViewController()
        let actionsNavigationController = DashboardNavigationController(rootViewController: actionsViewController)
        actionsViewController.setTabBarItem()
        
        self.viewControllers = [
            highlightsNavigationController,
            homeNavigationController,
            actionsNavigationController]
        self.selectedIndex = 1
    }
}

// MARK: - Setup
extension DashboardTabBarController {
    
    func setupTabBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.backgroundColor = .clear
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        tabBar.barTintColor =  UIColor.clear
        tabBar.tintColor = UIColor.App.Interactive.Selectable.selected()
        tabBar.unselectedItemTintColor = UIColor.App.Interactive.Selectable.unselected().withAlphaComponent(0.8)
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        frost.frame = tabBar.bounds
        frost.alpha = 0.0
        
        tabBar.insertSubview(frost, at: 0)
        overlays.append(tabBar)
    }
}

// MARK: - Handle Buttons
extension DashboardTabBarController {
    
    func setupProfileButton() {
        self.view.addSubview(profileButton)
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        overlays.append(profileButton)
    }
    
    func setupHelpButton() {
        self.view.addSubview(helpButton)
        helpButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(60)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        overlays.append(helpButton)
    }
    
    @objc func showMenu() {
        let settings = SettingsViewController()
        settings.modalPresentationStyle = .overFullScreen
        self.definesPresentationContext = true
        
        let currentNavigationController = viewControllers![selectedIndex] as! DashboardNavigationController
        currentNavigationController.pushViewController(settings, animated: true)
    }
    
    @objc func showHelp() {
        let help = HelpViewController()
        help.modalPresentationStyle = .overFullScreen
        self.definesPresentationContext = true
        
        let currentNavigationController = viewControllers![selectedIndex] as! DashboardNavigationController
        currentNavigationController.pushViewController(help, animated: true)
    }
    
    override func returnedToRootView() {
        for overlay in overlays {
            overlay.isHidden = false
        }
    }
    override func leavingRootView() {
        for overlay in overlays {
            overlay.isHidden = true
        }
    }
}

// MARK: - Handle Swipes
extension DashboardTabBarController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let current = viewControllers![selectedIndex] as! DashboardNavigationController
        guard current.viewControllers.count < 2 else { return false }
        return true
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left && (selectedIndex + 1) <= (self.viewControllers?.count)! - 1 {
            transitionViewController(toIndex: self.selectedIndex + 1)
        }
        if sender.direction == .right && (selectedIndex - 1) >= 0 {
            transitionViewController(toIndex: self.selectedIndex - 1)
        }
    }
}

// MARK: - TabBar Delegate
extension DashboardTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers,
            let toIndex = tabViewControllers.firstIndex(of: viewController)
        else { return false }
        transitionViewController(toIndex: toIndex)
        return true
    }
}

// MARK: - Animate ViewControllers
extension DashboardTabBarController {
    func transitionViewController(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController,
            let oldView = selectedVC.view,
            let newView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex
            else { return }
        
        oldView.superview?.addSubview(newView)
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        newView.center = CGPoint(x: oldView.center.x + offset, y: newView.center.y)
        view.isUserInteractionEnabled = false

        BackgroundManager.shared.animateBackgroundToTabOption(toIndex)
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
        }, completion: { _ in
            oldView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}
