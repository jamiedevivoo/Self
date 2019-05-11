import UIKit
import SnapKit
import Lottie
import SwiftyJSON

final class LandingOnboardingViewController: ViewController {
    
    // Delegates
    weak var dataCollector: OnboardingDataCollectorDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var sliderView = ViewSliderViewController()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self"
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.App.Text.text()
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var registerButton = Button(title: "Get Started", action: #selector(navigateToRegister), type: .primary)
    lazy var loginButton = Button(title: "Login", action: #selector(navigateToLogin), type: .secondary)
    
    lazy var swipeLeftForOnboarding: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(handleSwipes))
        swipeGesture.direction = .left
        return swipeGesture
    }()

    lazy var tapGestureForViewSlider = UITapGestureRecognizer(target: self, action: #selector(continueViewSlider))
    
}

// MARK: - Overide Methods
extension LandingOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        sliderView.slides = createOnboardingScreens()
        sliderView.delegate = self
        sliderView.view.addGestureRecognizer(tapGestureForViewSlider)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenSliderDelegate?.pageIndicator.isVisible = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addGestureRecognizer(swipeLeftForOnboarding)
        sliderView.view.addGestureRecognizer(swipeLeftForOnboarding)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.removeGestureRecognizer(swipeLeftForOnboarding)
        sliderView.view.removeGestureRecognizer(swipeLeftForOnboarding)
    }
}

// MARK: - Button Methods
extension LandingOnboardingViewController {
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        guard sliderView.pageControl.currentPage >= 2 else { return }
        navigateToRegister()
    }
    
    @objc func navigateToLogin() {
        self.present(LoginViewController(), animated: true)
    }
    @objc func navigateToRegister() {
        screenSliderDelegate?.forwardNavigationEnabled = true
        screenSliderDelegate?.goToNextScreen()
    }
    @objc func continueViewSlider() {
        sliderView.nextStage()
    }
}

// MARK: - Setup Methods
private extension LandingOnboardingViewController {
    
    func createOnboardingScreens() -> [LandingSlideView] {
        
        let onboardingSlideOne: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
            onboardingSlide.animationView.animation = Animation.named("profile")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on viewDidLoad
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = StaticMessages.get["splashScreen"]["personal"]["text"].stringValue
            return onboardingSlide
        }()
        
        let onboardingSlideTwo: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
            onboardingSlide.animationView.animation = Animation.named("goal")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on viewDidLoad
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = StaticMessages.get["splashScreen"]["challenges"]["text"].stringValue
            return onboardingSlide
        }()
        
        let onboardingSlideThree: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
            onboardingSlide.animationView.animation = Animation.named("heart")
            onboardingSlide.animationView.play() // TODO: Need to pause and play on viewDidLoad
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = StaticMessages.get["splashScreen"]["journal"]["text"].stringValue
            return onboardingSlide
        }()
        
        return [onboardingSlideOne, onboardingSlideTwo, onboardingSlideThree]
    }
}

extension LandingOnboardingViewController: ViewSliderDelegate {
    func continueAfterLastPage() {
        print("HEY")
        navigateToRegister()
    }
}

// MARK: - View Building
extension LandingOnboardingViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(welcomeLabel)
        self.add(sliderView, andView: true)
        self.view.addSubview(registerButton)
        self.view.addSubview(loginButton)
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.right.equalToSuperview().inset(30)
        }
        sliderView.view.snp.makeConstraints { (make) in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(50)
            make.bottom.equalTo(registerButton.snp.top).offset(-25)
            make.left.right.equalToSuperview()
        }
        registerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginButton.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
    }
    
}
