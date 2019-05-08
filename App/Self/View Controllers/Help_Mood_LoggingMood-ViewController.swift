import UIKit
import SnapKit

class HelpMoodLoggingMoodViewController: ViewController {
    
    lazy var dismissButton = Button.init(title: "Close", action: #selector(dismissButtonAction), type: .secondary)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor.app.background.primaryBackground().withAlphaComponent(0.1)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
        
        self.view.addSubview(dismissButton)
        
        dismissButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }
    
    @objc func dismissButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}
