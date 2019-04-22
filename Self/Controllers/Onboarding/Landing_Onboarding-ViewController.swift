import UIKit
import SnapKit

class LandingOnboardingViewController: ViewController {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self"
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    
    lazy var sliderViewController = ViewSliderViewController()
    var delegate : OnboardingDelegate?

    lazy var registerButton = StandardButton(title: "Get Started", action: #selector(LandingOnboardingViewController.navigateToRegister), type: .primary)
    lazy var loginButton = StandardButton(title: "Login", action: #selector(LandingOnboardingViewController.navigateToLogin), type: .secondary)
}

// MARK: - Overide Methods
extension LandingOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderViewController.slides = createOnboardingScreens()
        setupChildViews()
    }
}

// MARK: - ClassMethods
extension LandingOnboardingViewController {
    func createOnboardingScreens() -> [LandingSlideView] {
        
        let onboardingSlideOne: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
            onboardingSlide.image.image = UIImage(named: "home")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = "Self is all about you, it's your personal assistant. Every day you'll get a unique message based on what you share and what it learns."
            return onboardingSlide
        }()
        
        let onboardingSlideTwo: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
            onboardingSlide.image.image = UIImage(named: "globe")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = "Challenge yourself with positive wellbeing tasks and a community of people all improving their wellbeing."
            return onboardingSlide
        }()
        
        let onboardingSlideThree: LandingSlideView = {
            let onboardingSlide = LandingSlideView()
            onboardingSlide.image.image = UIImage(named: "for_you")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = "Keep track of your best moments, your mood and gain insights and suggestions based on what affects your wellbeing."
            return onboardingSlide
        }()
        
        return [onboardingSlideOne, onboardingSlideTwo, onboardingSlideThree]
    }
}

// MARK: - Button Methods
extension LandingOnboardingViewController {
    @objc func navigateToLogin(_ sender: Any) {
        self.present(LoginViewController(), animated: true)
    }
    @objc func navigateToRegister(_ sender: Any) {
        (self.parent as! OnboardingScreenSliderViewController).nextScreen()
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
