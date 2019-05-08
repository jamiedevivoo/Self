import UIKit

class ViewSliderViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = UIColor.App.Interactive.Selectable.selected()
        pageControl.pageIndicatorTintColor = UIColor.App.Interactive.Selectable.unselected()
        pageControl.currentPageIndicatorTintColor = UIColor.App.Interactive.Selectable.selected()
        return pageControl
    }()
    
    weak var delegate: ScreenSliderViewControllerDelegate?
    var slides: [UIView] = [] {
        didSet { setup() }
    }
}
    
// MARK: - Overrides
extension ViewSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupChildViews()
        setup()
    }
    
    func setup() {
        setupScrolllView()
        setupPageController()
    }
}

// MARK: - Set Up Slider
extension ViewSliderViewController {
    private func setupScrolllView() {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for slideIndex in 0 ..< slides.count {
            slides[slideIndex].frame = CGRect(x: view.frame.width * CGFloat(slideIndex), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[slideIndex])
        }
    }
    
    private func setupPageController() {
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
    }
}

// MARK: - Delegate Methods
extension ViewSliderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

// MARK: - Methods
extension ViewSliderViewController {
    func nextStage() {
        print("Next Stage")
        guard pageControl.currentPage < (pageControl.numberOfPages - 1) else {
            //            pageSliderViewDelegate?.continueOnboarding()
            return
        }
        pageControl.currentPage += 1
        scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width * CGFloat(pageControl.currentPage)), y: scrollView.contentOffset.y), animated: true)
        
    }
    func previousStage() {
        guard pageControl.currentPage > 0 else { return }
        pageControl.currentPage -= 1
        scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width * CGFloat(pageControl.currentPage)), y: scrollView.contentOffset.y), animated: true)
    }
}

// MARK: - View Building
extension ViewSliderViewController: ViewBuilding {
    func setupChildViews() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}
