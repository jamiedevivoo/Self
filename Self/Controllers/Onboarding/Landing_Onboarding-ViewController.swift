import UIKit
import SnapKit
import Lottie


final class LandingOnboardingViewController: ViewController {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self"
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    
    lazy var sliderViewController = ViewSliderViewController()
    var delegate : DataCollectionSequenceDelegate?

    lazy var registerButton = Button(title: "Get Started", action: #selector(LandingOnboardingViewController.navigateToRegister), type: .primary)
    lazy var loginButton = Button(title: "Login", action: #selector(LandingOnboardingViewController.navigateToLogin), type: .secondary)
    
    lazy var leftSwipe: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(handleSwipes))
        swipeGesture.direction = .left
        return swipeGesture
    }()
    
}


// MARK: - Overide Methods
extension LandingOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderViewController.slides = createOnboardingScreens()
        setupChildViews()
        self.view.addGestureRecognizer(leftSwipe)
    }
}


// MARK: - Button Methods
extension LandingOnboardingViewController {
    @objc func navigateToLogin() {
        self.present(LoginViewController(), animated: true)
    }
    @objc func navigateToRegister() {
        (self.parent as! ScreenSliderViewController).gestureSwipingEnabled = true
        (self.parent as! ScreenSliderViewController).nextScreen()
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        print("swiped")
        guard sliderViewController.pageControl.currentPage >= 2 else { return }
        print("over 2")
        navigateToRegister()
    }
}


// MARK: - Setup Methods
private extension LandingOnboardingViewController {
    func createOnboardingScreens() -> [LandingSlideView] {
        
        let onboardingSlideOne: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
//            onboardingSlide.image.image = UIImage(named: "home")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.animationView.animation = Animation.named("profile")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on videDidLoad
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = "Self is all about you, it's your personal assistant. Every day you'll get a unique message based on what you share and what it learns."
            return onboardingSlide
        }()
        
        let onboardingSlideTwo: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
//            onboardingSlide.image.image = UIImage(named: "globe")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.animationView.animation = Animation.named("goal")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on videDidLoad
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = "Challenge yourself with positive wellbeing tasks and a community of people all improving their wellbeing."
            return onboardingSlide
        }()
        
        let onboardingSlideThree: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
//            onboardingSlide.image.image = UIImage(named: "for_you")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.animationView.animation = Animation.named("heart")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on videDidLoad
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = "Keep track of your best moments, your mood and gain insights and suggestions based on what affects your wellbeing."
            return onboardingSlide
        }()
        
        onboardingSlideThree.addGestureRecognizer(leftSwipe)
        
        return [onboardingSlideOne, onboardingSlideTwo, onboardingSlideThree]
    }
    
}


// MARK: - View Building
extension LandingOnboardingViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(welcomeLabel)
        self.add(sliderViewController, alsoAddView: true)
        self.view.addSubview(registerButton)
        self.view.addSubview(loginButton)
        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.right.equalToSuperview().inset(20)
        }
        sliderViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(50)
            make.bottom.equalTo(registerButton.snp.top).offset(-25)
            make.left.right.equalToSuperview()
        }
        registerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginButton.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
    
}
