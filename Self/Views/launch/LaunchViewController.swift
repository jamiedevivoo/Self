import UIKit
import SnapKit

class LaunchViewController: UIViewController, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .green
        return pageControl
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(LoginViewController.loginButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(LoginViewController.loginButtonAction), for: .touchUpInside)
        return button
    }()
    
    var onboardingSlides:[OnboardingSlide] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.bringSubviewToFront(pageControl)
        
        onboardingSlides = createOnboardingFlow()
        setupOnboardingScrollView(slides: onboardingSlides)
        
        pageControl.numberOfPages = onboardingSlides.count
        pageControl.currentPage = 0
        
        addConstraints()

    }
    
    func createOnboardingFlow() -> [OnboardingSlide] {
        let onboardingSlideOne: OnboardingSlide = {
            let onboardingSlide = OnboardingSlide()
            onboardingSlide.image.image = UIImage(named: "home")
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = "Self is all about you, it's your personal assistant. Every day you'll get a unique message based on what you share and what it learns."
            return onboardingSlide
        }()
        let onboardingSlideTwo: OnboardingSlide = {
            let onboardingSlide = OnboardingSlide()
            onboardingSlide.image.image = UIImage(named: "globe")
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = "Challenge yourself with positive wellbeing tasks"
            return onboardingSlide
        }()
        let onboardingSlideThree: OnboardingSlide = {
            let onboardingSlide = OnboardingSlide()
            onboardingSlide.image.image = UIImage(named: "for_you")
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = "Keep track of your best moments"
            return onboardingSlide
        }()
        return [onboardingSlideOne, onboardingSlideTwo, onboardingSlideThree]
    }
    
    func setupOnboardingScrollView(slides : [OnboardingSlide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    

}

extension LaunchViewController: ConstraintBuilding {
    func addConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(250)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(registerButton.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(100)
            make.left.equalToSuperview()
        }
        registerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginButton.snp.top).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
}
