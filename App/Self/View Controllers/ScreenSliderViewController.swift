import UIKit
import SnapKit


class ScreenSliderViewController: UIPageViewController {
    
    // MARK: - Properties
    /// SliderDelegate
    weak var sliderDelegate: ScreenSliderViewControllerDelegate?
    
    /// Page Indicator View
    lazy var pageIndicator: UIPageControl = PageIndicator()
    
    /// Accessing UIPageViewController's child ScrollView
    var scrollView: UIScrollView?
    
    /// References to all screens in slider.
    var screens: [UIViewController] = [] {
        didSet { setup();} //// Only run setup when screens exist or are reset
    }
    /// A progressive array of the active viewControllers that can be transitioned to.
    var activeScreens: [UIViewController] = []
    
    /// Options for Screen Slider setup
    var initialScreenIndex: Int = 0
    var loopingSliderEnabled: Bool = false
    var forwardNavigationEnabled: Bool = true
    var backwardNavigationEnabled: Bool = true
    var allScreensEnabled: Bool = true {
        didSet { setup() }
    }
    var gestureSwipingEnabled: Bool = true {
        didSet { scrollView?.isScrollEnabled = gestureSwipingEnabled; print("Gesture Swiping Enabled?: \(gestureSwipingEnabled)") }
    }
    var pageIndicatorEnabled: Bool = false {
        didSet { setupPageIndicator()  }
    }
    
    
    // MARK: - Init
    /// Helper Initialiser for setting up the superClass UIPageViewController
    init(navigationOrientation: NavigationOrientation = .horizontal) {
        super.init(
            transitionStyle: UIPageViewController.TransitionStyle.scroll,
            navigationOrientation: navigationOrientation,
            options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Overriding Methods
extension ScreenSliderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }
    
}


// MARK: - Setup Methods
extension ScreenSliderViewController {
    
    /// Start setting up the child views
    private func setup() {
        view.backgroundColor = UIColor.app.background.primaryBackground()
        setupPageView()
        setupPageIndicator()
        setupScrollView()
    }
    
    /// Setup the initial page
    private func setupPageView() {
        guard screens.count > 0 else { return }
        
        if allScreensEnabled == true { activeScreens = screens }
        else { activeScreens = [screens[initialScreenIndex]] }
        
        setViewControllers([activeScreens[0]], direction: .forward, animated: true, completion: nil)
    }
    
    /// Setup the pageIndicator
    private func setupPageIndicator() {
        guard pageIndicatorEnabled == true else { return }
        self.pageIndicator.numberOfPages = self.screens.count
        self.pageIndicator.currentPage = initialScreenIndex
        
        self.view.addSubview(pageIndicator)
        pageIndicator.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    /// Setup the ScrollView
    private func setupScrollView() {
        self.scrollView = (view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView)
        scrollView?.delegate = self
    }
    
}


// MARK: - Class Methods
extension ScreenSliderViewController {
    
    // Manually transition to the next screen
    func nextScreen() {
        guard let viewControllerIndex = self.activeScreens.firstIndex(of: viewControllers![0]) else { return }
        activeScreens.append(screens[viewControllerIndex + 1])
        guard let screen = pageViewController(self, viewControllerAfter: viewControllers![0]) else { return }
        setViewControllers([screen], direction: .forward, animated: true, completion: nil)
    }
    
    // Manually transition to the previous screen
    func previousScreen() {
        guard let screen: UIViewController = pageViewController(self, viewControllerBefore: viewControllers![0]) else { return }
        setViewControllers([screen], direction: .reverse, animated: true, completion: nil)
    }
    
}


// MARK: - UIPageViewControllerDataSourceDelegate  Methods
extension ScreenSliderViewController: UIPageViewControllerDataSource {
    
    // # FIXME: There is a bug here somewhere.
    // # Steps to repeat:
    // - If the user swpies forward without completing the required fields, they'll get sent to a blank sceen, if the user then tries to swipe backwards or forwards they're stuck in a loop where they continually get sent to the blank screen.
    
    // Deciding the next viewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        /// If the current viewController doesn't exists in screens, bail.
        guard let viewControllerIndex = self.activeScreens.firstIndex(of: viewController) else { return nil }
        
        /// If forward navigation isn't enabled, bail.
        guard forwardNavigationEnabled else { return nil }
        
        /// If this isn't the last slide, check the delegate for validation, then go forward one slide.
        if viewControllerIndex < self.activeScreens.count - 1 {
            let nextScreen = self.activeScreens[viewControllerIndex + 1]
            guard let sliderDelegate = sliderDelegate else { return nextScreen }
            guard sliderDelegate.validateDataBeforeNextScreen(nextViewController: nextScreen) else { return nil }
            return nextScreen
        }
        else {
            /// Otherwise if looping is enabled, go to the first slide.
            guard !loopingSliderEnabled else { return self.activeScreens.first }
            /// If looping is disabled, there is nothing to do.
            return nil
        }
    }
    
    // Deciding the previous viewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        /// If the current viewController doesn't exists in screens, bail.
        guard let viewControllerIndex = self.activeScreens.firstIndex(of: viewController) else { return nil }
        /// If backward navigation isn't enabled, bail.
        guard backwardNavigationEnabled else { return nil }
        /// If this isn't the first slide, go forward one slide.
        if viewControllerIndex > 0 { return self.activeScreens[viewControllerIndex - 1] }
        else {
            /// Otherwise if looping is enabled, go to the last slide.
            guard !loopingSliderEnabled else { return self.activeScreens.last }
            /// If looping is disabled, there is nothing to do.
            return nil
        }
    }
    
}


// MARK: - UIPageViewControllerDelegate  Methods
extension ScreenSliderViewController: UIPageViewControllerDelegate {
    
    // The PageViewController is about to transition
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        guard let viewControllerIndex = self.screens.firstIndex(of: pendingViewControllers.first!) else { return }
    }
    
    // The pageViewController finished the transition
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        /// Set the pageControl.currentPage to the index of the current viewController in screens
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.screens.firstIndex(of: viewControllers[0]) {
                self.pageIndicator.currentPage = viewControllerIndex
            }
        }
    }
    
}


// MARK: - ScrollView Delegate Methods
extension ScreenSliderViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
}
