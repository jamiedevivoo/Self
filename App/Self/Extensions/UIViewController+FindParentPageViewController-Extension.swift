import UIKit

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
