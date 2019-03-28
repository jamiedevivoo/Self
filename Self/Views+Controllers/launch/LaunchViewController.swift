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
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(LaunchViewController.navigateToRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(LaunchViewController.navigateToLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        
        let circleOnePath = UIBezierPath(arcCenter: CGPoint(x: 400,y: 200), radius: CGFloat(250), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwoPath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 600), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePaths = CGMutablePath()
        circlePaths.addPath(circleOnePath.cgPath)
        circlePaths.addPath(circleTwoPath.cgPath)
        
        shapeLayer.fillColor = UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1).cgColor
        shapeLayer.strokeColor = UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.path = circlePaths
        return shapeLayer
    }()
    
    var onboardingSlides:[OnboardingSlideView] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Welcome to Self"
        scrollView.delegate = self
        
        onboardingSlides = createOnboardingFlow()
        setupOnboardingScrollView(slides: onboardingSlides)
        
        pageControl.numberOfPages = onboardingSlides.count
        pageControl.currentPage = 0
        
        addSubViews()
        addConstraints()
    }
    
    func createOnboardingFlow() -> [OnboardingSlideView] {
        let onboardingSlideOne: OnboardingSlideView = {
            let onboardingSlide = OnboardingSlideView()
            onboardingSlide.image.image = UIImage(named: "home")
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = "Self is all about you, it's your personal assistant.Every day you'll get a unique message based on what you share and what it learns."
            return onboardingSlide
        }()
        let onboardingSlideTwo: OnboardingSlideView = {
            let onboardingSlide = OnboardingSlideView()
            onboardingSlide.image.image = UIImage(named: "globe")
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = "Challenge yourself with positive wellbeing tasks and a community of people all improving their wellbeing."
            return onboardingSlide
        }()
        let onboardingSlideThree: OnboardingSlideView = {
            let onboardingSlide = OnboardingSlideView()
            onboardingSlide.image.image = UIImage(named: "for_you")
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = "Keep track of your best moments, your mood and gain insights and suggestions based on what affects your wellbeing."
            return onboardingSlide
        }()
        return [onboardingSlideOne, onboardingSlideTwo, onboardingSlideThree]
    }
    
    func setupOnboardingScrollView(slides : [OnboardingSlideView]) {
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
    
    @objc func navigateToLogin(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    @objc func navigateToRegister(_ sender: Any) {
        navigationController?.pushViewController(OnboardingController(), animated: true)
    }
    
}

extension LaunchViewController: ViewBuilding {
    func addSubViews() {
        view.layer.addSublayer(shapeLayer)
        view.addSubview(scrollView)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func addConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(300)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(registerButton.snp.top).inset(-100)
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalToSuperview()
        }
        registerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginButton.snp.top).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
}
