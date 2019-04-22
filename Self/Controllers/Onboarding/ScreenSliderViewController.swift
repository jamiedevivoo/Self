import UIKit
import SnapKit

class ScreenSliderViewController: UIPageViewController {
    
    lazy var pageIndicator: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = UIColor.app.interactive.selectable.selected()
        pageControl.pageIndicatorTintColor = UIColor.app.interactive.selectable.unselected()
        pageControl.currentPageIndicatorTintColor = UIColor.app.interactive.selectable.selected()
        return pageControl
    }()
    
    weak var screenSliderViewControllerDelegate: ScreenSliderViewControllerDelegate?
    var sliderIsLooped: Bool = false
    var displayPageIndicator: Bool = false
    var initialPage: Int = 0
    
    var scrollView: UIScrollView?
    
    var screens: [UIViewController] = [] {
        didSet { setup() } // Only set page when screens have been set (exist)
    }
    
    // MARK: - Init
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

// MARK: - Setup Methods
extension ScreenSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }
    
    func setup() {
        setupPageView()
        setupPageIndicator()
        setupScrollView()
    }
    
    private func setupPageView() {
        guard screens.count > 0 else { return }
        setViewControllers([screens[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
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
}

// MARK:Methods
extension ScreenSliderViewController: UIScrollViewDelegate {
    private func setupScrollView() {
        self.scrollView = (view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView)
        scrollView?.delegate = self
    }
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//    }

}

// MARK: - PageView Page Controller Methods
extension ScreenSliderViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.screens.firstIndex(of: viewController) else { return nil }
        if viewControllerIndex > 0 {
            print("Controller Before: \(self.screens[viewControllerIndex - 1])")
            return self.screens[viewControllerIndex - 1]
        } else {
            if sliderIsLooped {
                // wrap to the last page
                return self.screens.last
            } else {
                // call the delegates unstart method
                screenSliderViewControllerDelegate?.reachedFirstIndex(pageViewController as! ScreenSliderViewController)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.screens.firstIndex(of: viewController) else { return nil }
        if viewControllerIndex < self.screens.count - 1 {
            // go to next page in array
            print("Controller After: \(self.screens[viewControllerIndex + 1])")
            return self.screens[viewControllerIndex + 1]
        } else {
            if sliderIsLooped {
                // go to previous page in array
                return self.screens.first
            } else {
                // call the delegates end method
                screenSliderViewControllerDelegate?.reachedFinalIndex(pageViewController as! ScreenSliderViewController)
            }
        }
        return nil
    }
    
    func nextScreen() {
        let nextScreen = pageViewController(self, viewControllerAfter: viewControllers![0])!
        print("Next Screen: \(nextScreen)")
        setViewControllers([nextScreen], direction: .forward, animated: true, completion: nil)
    }

    func previousScreen() {
        let previousScreen = pageViewController(self, viewControllerBefore: viewControllers![0])!
        print("Previous Screen: \(previousScreen)")
        setViewControllers([previousScreen], direction: .reverse, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewControllerIndex = self.screens.firstIndex(of: pendingViewControllers.first!) else { return }
        print("willTransitionTo Screen: \(viewControllerIndex)")
    }
}

// MARK: - PageControl Methods
extension ScreenSliderViewController {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("Controller finished animating: \(previousViewControllers)")

        // set the pageControl.currentPage to the index of the current viewController in screens
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.screens.firstIndex(of: viewControllers[0]) {
                print("Finished Index: \(viewControllerIndex)")
                self.pageIndicator.currentPage = viewControllerIndex
            }
        }
    }
}
