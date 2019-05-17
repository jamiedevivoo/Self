import UIKit

// Delegate for controller a ScreenSliderViewController.
protocol ScreenSliderDelegate: class {
    func validateDataBeforeNextScreen(_ sender: ScreenSliderViewController, currentViewController: UIViewController, nextViewController: UIViewController) -> Bool
}

extension ScreenSliderDelegate where Self: ScreenSliderViewController {

    // Optional helper method to set up a PageViewController. Method will set a a PageViewControllers delegate to self by default.
    /// And I wanted to try creating a generic method...
    func configurePageViewController<T>(
        _ screenSliderViewController: ScreenSliderViewController,
        withPages pages: [(UIViewController, Bool)],
        withDelegate delegate: T,
        showPageIndicator pageIndicator: Bool = false,
        isLooped loop: Bool = false,
        enableSwiping: Bool = true,
        optionalSetup: @escaping () -> Void = {})
    where T: ScreenSliderDelegate
    {
        screenSliderViewController.screens = pages
        screenSliderViewController.screenSliderDelegate = delegate as? ScreenSliderViewController
        screenSliderViewController.pageIndicatorEnabled = pageIndicator
        screenSliderViewController.sliderShouldloop = loop
        screenSliderViewController.gestureScrollingEnabled = enableSwiping
        optionalSetup()
    }
}
