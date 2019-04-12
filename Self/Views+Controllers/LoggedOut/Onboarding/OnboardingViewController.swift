import UIKit
import Firebase
import SnapKit

class OnboardingViewController: ViewController {
    
    lazy var onboardingSlider: OnboardingSliderViewController = {
        let viewController = OnboardingSliderViewController()
        self.addChild(viewController)
        return viewController
    }()
//    lazy var onboardingAccount = Account()
}

// MARK: - Init
extension OnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
        onboardingSlider.onboardingManagerDelegate = self
    }
}

// MARK: - Functions
extension OnboardingViewController {
    func signInAnonymously() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let registeredCredentials = authResult, error == nil else {
                let errorAlert: UIAlertController = {
                    let alertController = UIAlertController()
                    alertController.title = error!.localizedDescription
                    alertController.message = "Sorry there was a problem"
                    print(error, authResult)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    return alertController
                }()
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
//            let userData = UserData(withDictionary: [.name:name])
//            let account = Account(withID: registeredCredentials.user.uid, withData: userData)
//            AccountManager.shared().updateAccount(newAccount: account)
        }
    }
}

extension OnboardingViewController: OnboardingManagerDelegate {
    func continueOnboarding() {
        signInAnonymously()
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
