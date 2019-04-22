import UIKit

protocol ScreenSliderViewControllerDelegate: class {
    // Delegate protocol for controlling a PageViewController (Subclass of UIPageViewController, with built in PageControl).
    //// The delegate should set itself as the Delegate for a PageViewController.
    //// The delagate should set the methods for out of range indexes (including ending the slider) as well as set the pages property.
    //// The declare can also set whether the pageViewController should loop (false by default), and the initial page (0 by default).
    func reachedFirstIndex(_ pageSliderViewController: ScreenSliderViewController)
    func reachedFinalIndex(_ pageSliderViewController: ScreenSliderViewController)
}

extension ScreenSliderViewControllerDelegate {
    // Optional helper method to set up a PageViewController. Method will set a a PageViewControllers delegate to self by default.
    func configurePageViewController<T: ScreenSliderViewControllerDelegate>(
        _ screenSliderViewController: ScreenSliderViewController,
        withPages pages: [UIViewController],
        withDelegate delegate: T,
        isLooped loop: Bool = false,
        showPageIndicator pageIndicator: Bool = true,
        enableSwiping swiping: Bool = true,
        optionalSetup: @escaping () -> () = {} )
        where T : UIViewController
    {
        screenSliderViewController.sliderDelegate = self
        screenSliderViewController.screens = pages
        screenSliderViewController.sliderIsLooped = loop
        screenSliderViewController.displayPageIndicator = pageIndicator
        screenSliderViewController.scrollingEnabled = swiping
        optionalSetup()
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
