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
        pageControl.tintColor = UIColor.app.interactive.selectable.selected()
        pageControl.pageIndicatorTintColor = UIColor.app.interactive.selectable.unselected()
        pageControl.currentPageIndicatorTintColor = UIColor.app.interactive.selectable.selected()
        return pageControl
    }()
    
    weak var delegate: ScreenSliderViewControllerDelegate?
    var pages: [ViewController] = []
}
    
// MARK: - Overrides
extension ViewSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        setupChildViews()
        setupSlider(onboardingStages: pages)
    }
}

// MARK: - Functions
extension ViewSliderViewController: UIScrollViewDelegate {
    func setupSlider(onboardingStages stages: [ViewController]) {
        pageControl.numberOfPages = stages.count
        pageControl.currentPage = 0
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(stages.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< stages.count {
            let stageController = stages[i]
            add(stageController, alsoAddView: false)
            scrollView.addSubview(stageController.view)
            stageController.view.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension ViewSliderViewController: ScreenSliderViewControllerDelegate {
    func beforeStartIndexOfSlider(_ screenSliderViewController: ScreenSliderViewController) {
        
    }
    
    func afterEndIndexOfSlider(_ screenSliderViewController: ScreenSliderViewController) {
        
    }
    
    func nextStage() {
        print("Next Stage")
        guard pageControl.currentPage < (pageControl.numberOfPages - 1) else {
//            pageSliderViewDelegate?.continueOnboarding()
            return
        }
        pageControl.currentPage = pageControl.currentPage + 1
        scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width * CGFloat(pageControl.currentPage)), y: scrollView.contentOffset.y), animated: true)
        
    }
    func previousStage() {
        guard pageControl.currentPage > 0 else { return }
        pageControl.currentPage = pageControl.currentPage - 1
        scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width * CGFloat(pageControl.currentPage)), y: scrollView.contentOffset.y), animated: true)
    }
}

extension ViewSliderViewController: ViewBuilding {
    
    func setupChildViews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(pageControl.snp.top).offset(10)
        }
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}

