import UIKit

class OnboardingController: UIViewController {
    
    var mood: Float?
    var name: String?
    var mission: String?
    var email: String?
    var password: String?
    var passwordConfirm: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        self.navigationController?.isNavigationBarHidden = true
        title = "Onboarding"
        navigationController?.pushViewController(MoodOnboardingViewController(), animated: true)
    }
    
    // Needs to display the initial onboardingviewcontroller.
    // The specific onboarding viewcontroller will handle the subviews on the screen and DataHandling
    // The specific onboarding viewController will then pass the submiteddata back to this controller
    // This controller will then display the next controller and repeat, merging the new data with it's own instance.
    
    // On the final viewcontroller the submit button will submit the data to the database.


}

extension OnboardingController: OnboardingMoodViewDelegate {
    func childViewControllerWillDismiss(childViewController: MoodOnboardingViewController)
    {
        print("\(name ?? "No Name")")
        mood = childViewController.mood
    }
}
extension OnboardingController: OnboardingNameViewDelegate {
    func childViewControllerWillDismiss(childViewController: NameOnboardingViewController)
    {
        name = childViewController.name
    }
}
extension OnboardingController: OnboardingMissionViewDelegate {
    func childViewControllerWillDismiss(childViewController: WellbeingOnboardingViewController)
    {
        mission = childViewController.mission
    }
}
extension OnboardingController: OnboardingAccountViewDelegate {
    func childViewControllerWillDismiss(childViewController: AccountOnboardingViewController)
    {
        email = childViewController.email
        password = childViewController.password
        passwordConfirm = childViewController.passwordConfirm
    }
}
