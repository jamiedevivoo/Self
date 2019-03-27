import UIKit

class OnboardingController: UIViewController {
    
//    var mood: Float?
//    var name: String?
//    var mission: String?
//    var email: String?
//    var password: String?
//    var passwordConfirm: String?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addConstraints()
    }
    
    
    // MARK: - Functions
    
    func setupView() {
        title = "Get Started"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItems = nil
        
        self.view.addSubview(scrollView)
        self.view.addSubview(pageControl)
    }

    // Needs to display the initial onboardingviewcontroller.
    // The specific onboarding viewcontroller will handle the subviews on the screen and DataHandling
    // The specific onboarding viewController will then pass the submiteddata back to this controller
    // This controller will then display the next controller and repeat, merging the new data with it's own instance.
    
    // On the final viewcontroller the submit button will submit the data to the database.


}

//extension OnboardingController: OnboardingMoodViewDelegate {
//    func childViewControllerWillDismiss(childViewController: MoodOnboardingViewController)
//    {
//        print("\(name ?? "No Name")")
//        mood = childViewController.mood
//    }
//}
//extension OnboardingController: OnboardingNameViewDelegate {
//    func childViewControllerWillDismiss(childViewController: NameOnboardingViewController)
//    {
//        name = childViewController.name
//    }
//}
//extension OnboardingController: OnboardingMissionViewDelegate {
//    func childViewControllerWillDismiss(childViewController: WellbeingOnboardingViewController)
//    {
//        mission = childViewController.mission
//    }
//}
//extension OnboardingController: OnboardingAccountViewDelegate {
//    func childViewControllerWillDismiss(childViewController: AccountOnboardingViewController)
//    {
//        email = childViewController.email
//        password = childViewController.password
//        passwordConfirm = childViewController.passwordConfirm
//    }
//}
extension OnboardingController: ConstraintBuilding {
    func addConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(150)
            make.top.equalTo(0)
        }
        pageControl.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(100)
            make.bottom.equalTo(0)
        }
    }
}
