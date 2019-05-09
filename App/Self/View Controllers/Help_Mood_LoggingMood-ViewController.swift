import UIKit
import SnapKit

extension HelpMoodLoggingMoodViewController: UIGestureRecognizerDelegate { }

class HelpMoodLoggingMoodViewController: ViewController {
    
    lazy var headerLabel = HeaderLabel("Logging A Mood", .screen)
    lazy var paraLabel = ParaLabel("Blah Blah Blah", .standard)

    lazy var dismissButton = Button.init(title: "Close", action: #selector(dismissButtonAction), type: .secondary)

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPopover = true
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor.App.Background.primary().withAlphaComponent(0.1)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        
        self.view.addSubview(headerLabel)
        self.view.addSubview(paraLabel)
        self.view.addSubview(dismissButton)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
            make.centerX.equalToSuperview()
        }
        paraLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(100)
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
