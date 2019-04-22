import UIKit

extension UIViewController {
    func add(_ viewController: UIViewController, alsoAddView: Bool = true) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        if alsoAddView {
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

extension UIViewController {
    func findPageController(forViewController viewController: UIViewController) -> UIPageViewController? {
        var responder: UIResponder? = viewController
        repeat {
            responder = responder?.next
            guard let vc = responder as? UIPageViewController else { return nil }
            return vc
        } while responder != nil
    }
}
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
