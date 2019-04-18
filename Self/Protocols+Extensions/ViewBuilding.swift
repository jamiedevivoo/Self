import UIKit

protocol ViewBuilding {
    func setupChildViews()
}

protocol ScreenSliderViewControllerDelegate: class {
    // Delegate protocol for controlling a PageViewController (Subclass of UIPageViewController, with built in PageControl).
    //// The delegate should set itself as the Delegate for a PageViewController.
    //// The delagate should set the methods for out of range indexes (including ending the slider) as well as set the pages property.
    //// The declare can also set whether the pageViewController should loop (false by default), and the initial page (0 by default).
    func beforeStartIndexOfSlider(_ pageSliderViewController: ScreenSliderViewController)
    func afterEndIndexOfSlider(_ pageSliderViewController: ScreenSliderViewController)
}

extension ScreenSliderViewControllerDelegate {
    // Optional helper method to set up a PageViewController. Method will set a a PageViewControllers delegate to self by default.
    func setupPageViewController<T>(
            _ screenSliderViewController: ScreenSliderViewController,
            pages: [UIViewController],
            delegate: T.Type = T.self,
            loop: Bool = false,
            optionalSetup: @escaping () -> () = {} )
        where T : UIViewController
    {
        screenSliderViewController.screenSliderViewControllerDelegate = self
        screenSliderViewController.pages = pages
        screenSliderViewController.sliderIsLooped = loop
        optionalSetup()
    }
}

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

protocol ViewIsDependantOnAccountData { }
extension ViewIsDependantOnAccountData {
    var accountRef: Account {
        return AccountManager.shared().accountRef!
    }
}

protocol DictionaryConvertable {
    var dictionary: [String: Any] { get }
}
