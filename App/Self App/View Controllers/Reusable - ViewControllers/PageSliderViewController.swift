import UIKit
import SnapKit

class ScreenSliderViewController: UIPageViewController {
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = UIColor.app.interactive.selectable.selected()
        pageControl.pageIndicatorTintColor = UIColor.app.interactive.selectable.unselected()
        pageControl.currentPageIndicatorTintColor = UIColor.app.interactive.selectable.selected()
        return pageControl
    }()
    
    weak var screenSliderViewControllerDelegate: ScreenSliderViewControllerDelegate?
    var sliderIsLooped: Bool = false
    var initialPage: Int = 0
    
    var pages: [UIViewController] = [] {
        didSet {
            // Only set page when pages have been set (exist)
            setupPageView()
            setupPageController()
        }
    }
}

// MARK: - Methods
extension ScreenSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        setupChildViews()
    }
    
    func setupPageView() {
        guard pages.count > 1 else { return }
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func setupPageController() {
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
    }
}

// MARK: - PageView Page Controller Methods
extension ScreenSliderViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController) else { return nil }
        if viewControllerIndex > 0 {
            return self.pages[viewControllerIndex - 1]
        } else {
            if sliderIsLooped {
                // wrap to the last page
                return self.pages.last
            } else {
                // call the delegates unstart method
                screenSliderViewControllerDelegate?.beforeStartIndexOfSlider(pageViewController as! ScreenSliderViewController)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController) else { return nil }
        if viewControllerIndex < self.pages.count - 1 {
            // go to next page in array
            return self.pages[viewControllerIndex + 1]
        } else {
            if sliderIsLooped {
                // go to previous page in array
                return self.pages.first
            } else {
                // call the delegates end method
                screenSliderViewControllerDelegate?.afterEndIndexOfSlider(pageViewController as! ScreenSliderViewController)
            }
        }
        return nil
    }
}

// MARK: - PageControl Methods
extension ScreenSliderViewController {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}

// MARK: - View Building
extension ScreenSliderViewController: ViewBuilding {
    func setupChildViews() {
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}
