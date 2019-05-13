import UIKit
import SnapKit
import Lottie

final class InductionOnboardingViewController: ViewController {

    // Delegates
    weak var dataCollector: OnboardingDataCollectorDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel("Hey...", .largeScreen)
    lazy var congratsLabel = ParaLabel(StaticMessages.get["onboarding"]["induction"]["congrats"].stringValue, .doubleStandard)
    lazy var paraLabel = ParaLabel(StaticMessages.get["onboarding"]["induction"]["text"].stringValue, .doubleStandard)
    lazy var continueButton = Button(title: "Continue", action: #selector(InductionOnboardingViewController.continueOnboarding), type: .primary)
    
    lazy var animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.tintAdjustmentMode = UIView.TintAdjustmentMode.dimmed
        animationView.tintColor = UIColor.black
        animationView.loopMode = LottieLoopMode.playOnce
        animationView.animation = Animation.named("green-tick")
        animationView.animationSpeed = 0.6
        animationView.contentMode = .scaleAspectFit
        animationView.alpha = 0
        return animationView
    }()
}

// MARK: - Override Methods
extension InductionOnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerLabel.text = "Hi \(dataCollector?.name ?? "...")!"
        screenSliderDelegate?.pageIndicator.isVisible = false
        checkCompletion()
    }
}

// MARK: - Class Methods
extension InductionOnboardingViewController {
    
    func checkCompletion() {
        if dataCollector!.isDataCollectionComplete() != nil {
            continueButton.applyState(.normal)
            animationView.alpha = 1
            animationView.currentFrame = 0
            animationView.play()
        } else {
            continueButton.applyState(.disabled)
            animationView.alpha = 0
        }
    }
    
    @objc func continueOnboarding(_ sender: UIButton) {
        dataCollector?.finishDataCollection()
        animationView.animation = Animation.named("circleLoading")
        animationView.loopMode = .loop
        animationView.play()
        UIView.animate(withDuration: 0.3) {
            self.headerLabel.alpha = 0.5
            self.congratsLabel.alpha = 0.5
            self.paraLabel.alpha = 0.5
            self.continueButton.alpha = 0.7
            sender.isEnabled = false
            self.continueButton.applyState(.disabled)
        }
    }
    
}

// MARK: - View Building
extension InductionOnboardingViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(animationView)
        self.view.addSubview(congratsLabel)
        self.view.addSubview(paraLabel)
        self.view.addSubview(continueButton)
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        
        animationView.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(congratsLabel.snp.top).offset(-50)
        }
        
        congratsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(paraLabel.snp.top).offset(-30)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(50)
        }
        paraLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(continueButton.snp.top).offset(-50)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(50)
        }
        continueButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
    
}
