import UIKit

protocol ViewBuilding {
    func addSubViews()
    func addConstraints()
}
protocol AddingChildViewControllers {
    func addChildViewController(viewController: UIViewController)

    // Example Content:
    // Remember to add function to viewDidLoad
    //    func addChildControllers() {
    //        addChild(actionListViewController)
    //        actionListViewController.didMove(toParent: self)
    //    }
}
