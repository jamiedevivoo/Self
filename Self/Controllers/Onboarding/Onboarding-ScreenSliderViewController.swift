import UIKit
import Firebase

extension OnboardingScreenSliderViewController: ScreenSliderViewControllerDelegate, OnboardingDelegate { }

final class OnboardingScreenSliderViewController: ScreenSliderViewController {
    private var name: String?
}

// MARK: - Override Methods
extension OnboardingScreenSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenSlider()
    }
}

// MARK: - Setup Methods
private extension OnboardingScreenSliderViewController {
    func setupScreenSlider() {
        screens = setupScreens()
        sliderIsLooped = false
        displayPageIndicator = false
        scrollingEnabled = true
        screenSliderViewControllerDelegate = self
    }
    
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
extension OnboardingScreenSliderViewController {
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
extension OnboardingScreenSliderViewController {
    func reachedFirstIndex(_ pageViewController: ScreenSliderViewController) {
        print("First Index")
        self.scrollView?.bounces = false
        displayPageIndicator = false
        scrollingEnabled = false
    }
    func reachedFinalIndex(_ pageViewController: ScreenSliderViewController) {
        print("End")
    }
}

// MARK: - Onboarding Delegate Methods
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
