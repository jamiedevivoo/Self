import UIKit

class ViewSliderViewController: UIViewController {
    
    // Delegates
    weak var delegate: ViewSliderDelegate?
    
    // Views
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var pageControl = PageIndicator()
    
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
        scrollView.contentSize = CGSize(width: (view.frame.width * CGFloat(slides.count)), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        
        for slideIndex in 0 ..< slides.count {
            slides[slideIndex].frame = CGRect(x: (view.frame.width * CGFloat(slideIndex)),
                                              y: 0,
                                              width: view.frame.width,
                                              height: view.frame.height)
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
        
        if Int(pageIndex) == slides.count - 1 {
            scrollView.bounces = true
        } else {
            scrollView.bounces = false
        }
        
        let width = view.frame.width
        if scrollView.contentOffset.x > (width * CGFloat(slides.count - 1)) {
            delegate?.continueAfterLastPage()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
}

// MARK: - Class Methods
extension ViewSliderViewController {
    func nextStage() {
        guard pageControl.currentPage < (pageControl.numberOfPages - 1) else {
            delegate?.continueAfterLastPage()
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
            make.bottom.equalToSuperview()
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}
