import UIKit
import Firebase
import SnapKit

class OnboardingViewController: ViewController {
    
    lazy var onboardingSlider: OnboardingSliderViewController = {
        let viewController = OnboardingSliderViewController()
        self.addChild(viewController)
        return viewController
    }()
    @objc func nextStage() {
    }
    @nonobjc func previousStage() {
        
    }
}

// MARK: - Init
extension OnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
}

// MARK: - View Building
extension OnboardingViewController: ViewBuilding, AddingChildViewControllers {
    
    func addChildViewController(viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func addSubViews() {
        view.addSubview(onboardingSlider.view)
    }
    
    func addConstraints() {
        onboardingSlider.view.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
    }
}
