import UIKit
import Firebase


final class LoggingAMoodScreenSliderViewController: ScreenSliderViewController {
    var uid: String?
    var headline: String?
    var timestamp: Timestamp?
    var note: String?
    var arousalRating: Double?
    var valenceRating: Double?
    
    var wildcard: Wildcard?
    var emotion: Emotion?
    var tags = [Tag]()
    
    init() {
        super.init(navigationOrientation: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - Override Methods
extension LoggingAMoodScreenSliderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController(self, withPages: setupScreens(), withDelegate: self, enableSwiping: false)
        navigationController?.isNavigationBarHidden = true
    }
    
}


// MARK: - Setup Methods
private extension LoggingAMoodScreenSliderViewController {
    
    func setupScreens() -> [UIViewController] {
        let moodLoggingAMoodViewController = MoodLoggingMoodViewController()
        moodLoggingAMoodViewController.dataCollectionDelegate = self
        moodLoggingAMoodViewController.screenSlider = self
        let detailLoggingAMoodViewController = DetailLoggingMoodViewController()
        detailLoggingAMoodViewController.dataCollectionDelegate = self
        detailLoggingAMoodViewController.screenSlider = self
        let wildcardLoggingAMoodViewController = WildcardLoggingMoodViewController()
        wildcardLoggingAMoodViewController.dataCollectionDelegate = self
        wildcardLoggingAMoodViewController.screenSlider = self
        let overviewLoggingAMoodViewController = OverviewLoggingMoodViewController()
        overviewLoggingAMoodViewController.dataCollectionDelegate = self
        overviewLoggingAMoodViewController.screenSlider = self
        return [moodLoggingAMoodViewController,
                detailLoggingAMoodViewController,
                wildcardLoggingAMoodViewController,
                overviewLoggingAMoodViewController]
    }
    
}


// MARK: - Class Methods
extension LoggingAMoodScreenSliderViewController: DataCollectionSequenceDelegate {
    
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
extension LoggingAMoodScreenSliderViewController: ScreenSliderViewControllerDelegate {
    func reachedFirstIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
    func reachedFinalIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
}


// MARK: - OnboardingDelegate Methods
extension LoggingAMoodScreenSliderViewController {
    
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
