import UIKit
import Firebase
import SwiftyJSON

final class OnboardingScreenSliderViewController: ScreenSliderViewController {
    var name: String?
}

// MARK: - Override Methods
extension OnboardingScreenSliderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController(self, withPages: setupScreens(), withDelegate: self, showPageIndicator: true, isLooped: false, enableSwiping: false)
    }
    
}

// MARK: - Setup Methods
private extension OnboardingScreenSliderViewController {
    
    func setupScreens() -> [(vc: UIViewController, enabled: Bool)] {
        let landingOnboardingVC = LandingOnboardingViewController()
        landingOnboardingVC.dataCollector = self
        landingOnboardingVC.screenSliderDelegate = self
        
        let nameOnboardingVC = NameOnboardingViewController()
        nameOnboardingVC.dataCollector = self
        nameOnboardingVC.screenSliderDelegate = self
        
        let inductionOnboardingVC = InductionOnboardingViewController()
        inductionOnboardingVC.dataCollector = self
        inductionOnboardingVC.screenSliderDelegate = self
        
        return [(landingOnboardingVC, true),
                (nameOnboardingVC, true),
                (inductionOnboardingVC, true)]
    }
    
}

// MARK: - Class Methods
extension OnboardingScreenSliderViewController: OnboardingDataCollectorDelegate {
    
    func setData(_ dataDict: [String: Any?]) {}
    
    func isDataCollectionComplete() -> Bool {
        guard self.name != nil else { return false }
        return true
    }
    
    func finishDataCollection() {
        guard let name = self.name else { return }
        signInAnonymously(withName: name)
    }
    
}

// MARK: - ScreenSliderViewControllerDelegate Methods
extension OnboardingScreenSliderViewController: ScreenSliderDelegate {
    func validateDataBeforeNextScreen(currentViewController: UIViewController, nextViewController: UIViewController) -> Bool {
        if nextViewController.isMember(of: InductionOnboardingViewController.self) {
            guard name != nil else {
                return true
            }
        }
        return true
    }
    
    //// Add to super's willTransitionTo function
    override func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        super.pageViewController(pageViewController, willTransitionTo: pendingViewControllers)
    }
    
    //// Add to super's didFinishAnimating function
    override func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        super.pageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
    
}

// MARK: - OnboardingDelegate Methods
extension OnboardingScreenSliderViewController {
    
    func signInAnonymously(withName name: String) {
        Auth.auth().signInAnonymously { (authResult, error) in
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
            let accountUser = Account.User(["name": name])
            let account = Account(uid: registeredCredentials.user.uid, accountUser: accountUser)
            AccountManager.shared().updateAccount(modifiedAccount: account) {
            }
        }
    }
    
}
