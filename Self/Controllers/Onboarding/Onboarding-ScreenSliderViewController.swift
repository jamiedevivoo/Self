import UIKit
import Firebase


final class OnboardingScreenSliderViewController: ScreenSliderViewController {
    var name: String?
}


// MARK: - Override Methods
extension OnboardingScreenSliderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController(self, withPages: setupScreens(), withDelegate: self, isLooped: false, showPageIndicator: false, enableSwiping: true)
    }
    
}


// MARK: - Setup Methods
private extension OnboardingScreenSliderViewController {
    
    func setupScreens() -> [UIViewController] {
        let landingOnboardingVC = LandingOnboardingViewController()
        landingOnboardingVC.delegate = self
        let nameOnboardingVC = NameOnboardingViewController()
        nameOnboardingVC.delegate = self
        let inductionOnboardingVC = InductionOnboardingViewController()
        inductionOnboardingVC.delegate = self
        return [landingOnboardingVC,nameOnboardingVC,inductionOnboardingVC]
    }
    
}


// MARK: - Class Methods
extension OnboardingScreenSliderViewController: OnboardingDelegate {
    
    func setData(_ dataDict: [String:String?]) {
        guard let name = dataDict["name"] else {
            self.name = nil
            return
        }
        self.name = name
    }
    
    func isOnboardingComplete() -> Bool {
        guard let _ = self.name else { return false }
        return true
    }
    
    func finishOnboarding() {
        guard let name = self.name else { return }
        signInAnonymously(withName: name)
    }
    
}


// MARK: - ScreenSliderViewControllerDelegate Methods
extension OnboardingScreenSliderViewController: ScreenSliderViewControllerDelegate {
    func reachedFirstIndex(_ pageSliderViewController: ScreenSliderViewController) {
    
    }
    
    func reachedFinalIndex(_ pageSliderViewController: ScreenSliderViewController) {
    
    }
    
}


// MARK: - OnboardingDelegate Methods
extension OnboardingScreenSliderViewController {
    
    func signInAnonymously(withName name: String) {
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
