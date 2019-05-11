import UIKit
import SnapKit
import Lottie

extension HelpMoodLoggingMoodViewController: UIGestureRecognizerDelegate { }

class HelpMoodLoggingMoodViewController: ViewController {
    
    lazy var headerLabel = HeaderLabel(StaticMessages.get["helpScreen"]["moodLogging"]["title"].stringValue, .largeScreen)
    lazy var paraLabel = ParaLabel(StaticMessages.get["helpScreen"]["moodLogging"]["text"].stringValue, .doubleStandard)
    
    lazy var dismissButton = Button.init(title: "Close", action: #selector(dismissButtonAction), type: .secondary)
    
    lazy var animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.tintAdjustmentMode = UIView.TintAdjustmentMode.normal
        animationView.tintColor = UIColor.white
        animationView.loopMode = LottieLoopMode.loop
        animationView.animation = Animation.named("fingertouch")
        animationView.animationSpeed = 0.6
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPopover = true
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.pause()
    }
    
    func setup() {
        view.backgroundColor = UIColor.App.Background.primary().withAlphaComponent(0.1)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        
        self.view.addSubview(headerLabel)
        self.view.addSubview(animationView)
        self.view.addSubview(paraLabel)
        self.view.addSubview(dismissButton)
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        paraLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(100)
            make.centerX.equalToSuperview()
        }
        animationView.snp.makeConstraints { make in
            make.top.equalTo(paraLabel.snp.bottom).offset(20)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        dismissButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
        }
    }
    
    @objc func dismissButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    // Gesture Handling
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
