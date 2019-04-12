import UIKit
import Firebase
import SnapKit

class OnboardingViewController: ViewController {
    
    lazy var onboardingSlider: OnboardingSliderViewController = {
        let viewController = OnboardingSliderViewController()
        self.addChild(viewController)
        return viewController
    }()
}

// MARK: - Init
extension OnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
        signInAnonymously()
    }
}

// MARK: - Functions
extension OnboardingViewController {
    func signInAnonymously() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let _ = authResult, error == nil else {
                let errorAlert: UIAlertController = {
                    let alertController = UIAlertController()
                    alertController.title = error!.localizedDescription
                    alertController.message = "Sorre there was a problem"
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    return alertController
                }()
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
        }
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
