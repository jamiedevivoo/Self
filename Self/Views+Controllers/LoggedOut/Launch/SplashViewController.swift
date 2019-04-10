import UIKit
import SnapKit

class SplashViewController: UIViewController, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
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
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.app.pinkColor()
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.app.pinkColor().cgColor
        button.addTarget(self, action: #selector(SplashViewController.navigateToRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.app.pinkColor(), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.app.pinkColor().cgColor
        button.addTarget(self, action: #selector(SplashViewController.navigateToLogin), for: .touchUpInside)
        return button
    }()
    
    var onboardingSlides:[LaunchSlideView] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Welcome to Self"
        scrollView.delegate = self
        
        onboardingSlides = createOnboardingScreens()
        addOnboardingScreensToScrollView(slides: onboardingSlides)
        
        BackgroundManager.shared.backgroundContainer = self
        BackgroundManager.shared.addBackgroundToView()
        
        pageControl.numberOfPages = onboardingSlides.count
        pageControl.currentPage = 0
        
        addSubViews()
        addConstraints()
    }
    
    func createOnboardingScreens() -> [LaunchSlideView] {
        
        let onboardingSlideOne: LaunchSlideView = {
            let onboardingSlide = LaunchSlideView()
            onboardingSlide.frame.size.height = scrollView.frame.size.height
            onboardingSlide.image.image = UIImage(named: "home")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = "Self is all about you, it's your personal assistant. Every day you'll get a unique message based on what you share and what it learns."
            return onboardingSlide
        }()
        
        let onboardingSlideTwo: LaunchSlideView = {
            let onboardingSlide = LaunchSlideView()
            onboardingSlide.image.image = UIImage(named: "globe")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = "Challenge yourself with positive wellbeing tasks and a community of people all improving their wellbeing."
            return onboardingSlide
        }()
        
        let onboardingSlideThree: LaunchSlideView = {
            let onboardingSlide = LaunchSlideView()
            onboardingSlide.image.image = UIImage(named: "for_you")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = "Keep track of your best moments, your mood and gain insights and suggestions based on what affects your wellbeing."
            return onboardingSlide
        }()
        
        return [onboardingSlideOne, onboardingSlideTwo, onboardingSlideThree]
    }
    
    func addOnboardingScreensToScrollView(slides : [LaunchSlideView]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
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
    
    @objc func navigateToLogin(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
        BackgroundManager.shared.fillScreen()
    }
    
    @objc func navigateToRegister(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
}

extension SplashViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(scrollView)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func addConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(10)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(registerButton.snp.top).offset(-25)
            make.height.equalTo(10)
            make.left.right.equalToSuperview()
        }
        registerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginButton.snp.top).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
}
