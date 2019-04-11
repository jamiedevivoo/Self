import UIKit
import Firebase

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
protocol SubclassSetup {
    func setupSubclass()
}
