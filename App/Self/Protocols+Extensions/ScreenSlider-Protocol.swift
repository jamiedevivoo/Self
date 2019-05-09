import UIKit

protocol ScreenSliderDelegate: ScreenSliderViewController {
    func validateDataBeforeNextScreen(currentViewController: UIViewController, nextViewController: UIViewController) -> Bool
    // Delegate protocol for controlling a PageViewController (Subclass of UIPageViewController, with built in PageControl).
    //// The delegate should set itself as the Delegate for a PageViewController.
    //// The delagate should set the methods for out of range indexes (including ending the slider) as well as set the pages property.
    //// The declare can also set whether the pageViewController should loop (false by default), and the initial page (0 by default).
//    func reachedFirstIndex(_ pageSliderViewController: ScreenSliderViewController)
//    func reachedFinalIndex(_ pageSliderViewController: ScreenSliderViewController)
}

extension ScreenSliderDelegate {
    // Optional helper method to set up a PageViewController. Method will set a a PageViewControllers delegate to self by default.
    /// And I wanted to try creating a generic method...
    func configurePageViewController<T: ScreenSliderDelegate>(
        _ screenSliderViewController: ScreenSliderViewController,
        withPages pages: [UIViewController],
        withDelegate delegate: T,
        showPageIndicator pageIndicator: Bool = false,
        isLooped loop: Bool = false,
        allScreensEnabled: Bool = false,
        enableSwiping: Bool = true,
        optionalSetup: @escaping () -> Void = {}) {
        screenSliderViewController.screens = pages
        screenSliderViewController.screenSliderDelegate = delegate
        screenSliderViewController.pageIndicatorEnabled = pageIndicator
        screenSliderViewController.loopingSliderEnabled = loop
        screenSliderViewController.allScreensEnabled = allScreensEnabled
        screenSliderViewController.gestureSwipingEnabled = enableSwiping
        optionalSetup()
    }
}
