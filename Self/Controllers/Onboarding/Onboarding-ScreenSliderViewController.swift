import UIKit
import Firebase

class OnboardingScreenSliderViewController: ScreenSliderViewController {
    
    var stages: [UIViewController] = [NameOnboardingViewController(),
                                      InductionOnboardingViewController(),
                                      InductionOnboardingViewController()]
}

// MARK: - Overrides
extension OnboardingScreenSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPageViewController(self, pages: stages, loop: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - ScreenSliderViewController Delegate Methods
extension OnboardingScreenSliderViewController: ScreenSliderViewControllerDelegate {
    func beforeStartIndexOfSlider(_ pageViewController: ScreenSliderViewController) {
        print("Start")
    }
    func afterEndIndexOfSlider(_ pageViewController: ScreenSliderViewController) {
        print("End")
    }
}

// MARK: - Onboarding Methods
extension OnboardingScreenSliderViewController {
    func signInAnonymously() {
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
            let name = "TESTEWSD"
            let accountUser = AccountUser(["name":name])
            let account = Account(uid: registeredCredentials.user.uid, accountUser: accountUser)
            AccountManager.shared().updateAccount(modifiedAccount: account) {
                
            }
        }
    }
}

extension OnboardingScreenSliderViewController {
    func continueOnboarding() {
        signInAnonymously()
    }
}
