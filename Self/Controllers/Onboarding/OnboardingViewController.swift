import UIKit
import Firebase
import SnapKit

class OnboardingViewController: UIViewController {
    
    lazy var onboardingPageView = ScreenSliderViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var stages: [UIViewController] = [NameOnboardingViewController(),
                                      InductionOnboardingViewController(),
                                      InductionOnboardingViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        self.setupPageViewController(onboardingPageView, pages: stages, loop: false)
    }
}

extension OnboardingViewController: ScreenSliderViewControllerDelegate {
    func beforeStartIndexOfSlider(_ pageViewController: ScreenSliderViewController) {
        print("Start")
//        self.navigationController?.popToRootViewController(animated: true)
    }
    func afterEndIndexOfSlider(_ pageViewController: ScreenSliderViewController) {
        print("End")
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

extension OnboardingViewController {
    func continueOnboarding() {
        signInAnonymously()
    }
}

// MARK: - View Building
extension OnboardingViewController: ViewBuilding {
    func setupChildViews() {
        self.add(onboardingPageView)
        onboardingPageView.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
