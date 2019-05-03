import UIKit
import Firebase


final class OnboardingScreenSliderViewController: ScreenSliderViewController {
    var name: String?
}


// MARK: - Override Methods
extension OnboardingScreenSliderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController(self, withPages: setupScreens(), withDelegate: self, enableSwiping: false)
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
extension OnboardingScreenSliderViewController: DataCollectionSequenceDelegate {
    
    func setData(_ dataDict: [String:String?]) {
        guard let name = dataDict["name"] else {
            self.name = nil
            return
        }
        self.name = name
    }
    
    func isDataCollectionComplete() -> Bool {
        guard let _ = self.name else { return false }
        return true
    }
    
    func finishDataCollection() {
        guard let name = self.name else { return }
        signInAnonymously(withName: name)
    }
    
}


// MARK: - ScreenSliderViewControllerDelegate Methods
extension OnboardingScreenSliderViewController: ScreenSliderViewControllerDelegate {
    func validateDataBeforeNextScreen(nextViewController: UIViewController) -> Bool {
        if nextViewController.isMember(of: InductionOnboardingViewController.self) {
            guard let _ = name else {
                print("Next Screen failed Validation")
                return true
            }
        }
        print("validation duccess")
        return true
    }
    
    //// Add to super's willTransitionTo function
    override func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if !pendingViewControllers[0].isKind(of: LandingOnboardingViewController.self) {
            self.scrollView?.isScrollEnabled = true
            print(true)
        }
        super.pageViewController(pageViewController, willTransitionTo: pendingViewControllers)
    }
    
    //// Add to super's didFinishAnimating function
    override func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if viewControllers?[0].isKind(of: LandingOnboardingViewController.self) ?? false {
            self.scrollView?.isScrollEnabled = false
            print(false)
        }
        
        super.pageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
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
