import UIKit
import SnapKit
import Lottie
import SwiftyJSON

final class LandingOnboardingViewController: ViewController {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self"
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.App.Text.text()
        return label
    }()
    
    lazy var sliderViewController = ViewSliderViewController()
    weak var delegate: DataCollectionSequenceDelegate?

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
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        guard sliderViewController.pageControl.currentPage >= 2 else { return }
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
            onboardingSlide.animationView.play() // TODO: Need to pause and play on viewDidLoad
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = StaticMessages.get["splashScreen"]["personal"]["text"].stringValue
            return onboardingSlide
        }()
        
        let onboardingSlideTwo: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
//            onboardingSlide.image.image = UIImage(named: "globe")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.animationView.animation = Animation.named("goal")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on viewDidLoad
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = StaticMessages.get["splashScreen"]["challenges"]["text"].stringValue
            return onboardingSlide
        }()
        
        let onboardingSlideThree: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
//            onboardingSlide.image.image = UIImage(named: "for_you")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.animationView.animation = Animation.named("heart")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on viewDidLoad
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = StaticMessages.get["splashScreen"]["journal"]["text"].stringValue
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
