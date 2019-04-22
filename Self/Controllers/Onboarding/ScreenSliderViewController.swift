import UIKit
import SnapKit


class ScreenSliderViewController: UIPageViewController {
    
    /// SliderDelegate
    weak var sliderDelegate: ScreenSliderViewControllerDelegate?
    
    /// Page Indicator View
    lazy var pageIndicator: UIPageControl = PageIndicator()
    
    /// Accessing UIPageViewController's child ScrollView
    var scrollView: UIScrollView?
    
    /// References to screens
    var screens: [UIViewController] = [] {
        didSet { setup() } //// Only run setup when screens have been exist or are reset
    }
    
    /// Options for Screen Slider setup
    var sliderIsLooped: Bool = false
    var initialPage: Int = 0
    
    var scrollingEnabled: Bool = true {
        didSet { scrollView?.bounces = scrollingEnabled }
    }
    
    var displayPageIndicator: Bool = false {
        didSet { setupPageIndicator()  }
    }
    
    // MARK: - Init
    /// Helper Initialiser for setting up superClass UIPageViewController
    init() {
        super.init(
            transitionStyle: UIPageViewController.TransitionStyle.scroll,
            navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
            options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Overrides
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
        setupPageView()
        setupPageIndicator()
        setupScrollView()
    }
    
    /// Setup the initial page
    private func setupPageView() {
        guard screens.count > 0 else { return }
        setViewControllers([screens[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    /// Setup the pageIndicator
    private func setupPageIndicator() {
        guard displayPageIndicator == true else { return }
        self.pageIndicator.numberOfPages = self.screens.count
        self.pageIndicator.currentPage = initialPage
        
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


// MARK: - Custom Methods
extension ScreenSliderViewController {
    
    // Manually transition to the next screen
    func nextScreen() {
        let nextScreen = pageViewController(self, viewControllerAfter: viewControllers![0])!
        setViewControllers([nextScreen], direction: .forward, animated: true, completion: nil)
    }
    
    // Manually transition to the previous screen
    func previousScreen() {
        let previousScreen = pageViewController(self, viewControllerBefore: viewControllers![0])!
        setViewControllers([previousScreen], direction: .reverse, animated: true, completion: nil)
    }
    
}


// MARK: - UIPageViewControllerDataSourceDelegate  Methods
extension ScreenSliderViewController: UIPageViewControllerDataSource {
    
    // Deciding the next viewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.screens.firstIndex(of: viewController) else { return nil }
        
        /// If current controller isn't already at the last slide, go forward one slide.
        if viewControllerIndex < self.screens.count - 1 { return self.screens[viewControllerIndex + 1] }
            
        /// Otherwise the current slide is already the last slide, so either loop to the beginning or inform the delegate the slider has reached the end
        else {
            if sliderIsLooped { return self.screens.first }
            else { return nil }
        }
        return nil
    }
    
    // Deciding the previous viewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.screens.firstIndex(of: viewController) else { return nil }
        
        /// If current controller isn't already at the first slide, go back one slide.
        if viewControllerIndex > 0 { return self.screens[viewControllerIndex - 1] }
            
        /// Otherwise the current slide is already the first slide, so either loop to the end or inform the delegate the slider has reached the beginning
        else {
            if sliderIsLooped { return self.screens.last }
            else { return nil }
        }
        return nil
    }
    
}


// MARK: - UIPageViewControllerDelegate  Methods
extension ScreenSliderViewController: UIPageViewControllerDelegate {
    
    // The PageViewController is about to transition
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewControllerIndex = self.screens.firstIndex(of: pendingViewControllers.first!) else { return }
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
