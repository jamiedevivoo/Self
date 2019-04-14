import UIKit

protocol ViewBuilding {
    func addSubViews()
    func addConstraints()
}
protocol AddingChildViewControllers {
    func addChildViewController(viewController: UIViewController)

    // Example Content:
    // Remember to add function to viewDidLoad / lazy variable initialiser
    //    func addChildControllers() {
    //        addChild(actionListViewController)
    //        actionListViewController.didMove(toParent: self)
    //    }
}

extension UIViewController {
    func add(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
