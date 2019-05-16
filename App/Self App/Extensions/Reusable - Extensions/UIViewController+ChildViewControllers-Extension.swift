import UIKit

// Adding and removing Child View Controllers
extension UIViewController {
    func add(_ viewController: UIViewController, andView: Bool = true) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        if andView {
            self.view.addSubview(viewController.view)
        }
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// Finding the parent viewController
extension UIView {
    func findViewController(forView view: UIView) -> UIViewController? {
        var responder: UIResponder? = view
        repeat {
            responder = responder?.next
            guard let vc = responder as? UIViewController else { return nil }
            return vc
        } while responder != nil
    }
}
