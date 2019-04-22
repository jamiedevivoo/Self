import UIKit
import Firebase

final class OnboardingScreenSliderViewController: ScreenSliderViewController {
    
    lazy var launchOnboardingViewController = LandingOnboardingViewController()
    lazy var nameOnboardingViewController = NameOnboardingViewController()
    lazy var inductionOnboardingViewController = InductionOnboardingViewController()
    
    private var name: String?
}

// MARK: - Overrides
extension OnboardingScreenSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        launchOnboardingViewController.onboardingDelegate = self
        nameOnboardingViewController.onboardingDelegate = self
        inductionOnboardingViewController.onboardingDelegate = self
        self.configurePageViewController(self, withPages: [launchOnboardingViewController, nameOnboardingViewController, inductionOnboardingViewController], isLooped: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        scrollView?.bounces = false
    }
}


// MARK: - Onboarding Logic
extension OnboardingScreenSliderViewController: OnboardingDelegate {
    func setData(_ dataDict: [String:String]) {
        if let name = dataDict["name"] {
            print("Found Name")
            self.name = name
        }
    }
    
    func onboardingIsComplete() -> Bool {
        guard let _ = self.name else { return false }
        return true
    }
    
    func finishOnboarding() {
        signInAnonymously()
        print("Finishing Onboarding")
    }
}

// MARK: - ScreenSliderViewController Delegate Methods
extension OnboardingScreenSliderViewController: ScreenSliderViewControllerDelegate {
    func reachedFirstIndex(_ pageViewController: ScreenSliderViewController) {
        self.navigationController?.isNavigationBarHidden = false
        print("Start")
    }
    func reachedFinalIndex(_ pageViewController: ScreenSliderViewController) {
        print("End")
    }
}

// MARK: - Onboarding Methods
extension OnboardingScreenSliderViewController {
    func signInAnonymously() {
        guard let name = self.name else { return }
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let registeredCredentials = authResult, error == nil else {
                let errorAlert: UIAlertController = {
                    let alertController = UIAlertController()
                    alertController.title = error!.localizedDescription
                    alertController.message = "Sorry there was a problem"
                    print(error as AnyObject, authResult as AnyObject)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    return alertController
                }()
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            let accountUser = AccountUser(["name":name])
            let account = Account(uid: registeredCredentials.user.uid, accountUser: accountUser)
            AccountManager.shared().updateAccount(modifiedAccount: account) {
                
            }
        }
    }
}
