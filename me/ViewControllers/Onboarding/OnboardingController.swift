import UIKit

class OnboardingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Needs to display the initial onboardingviewcontroller.
    // The specific onboarding viewcontroller will handle the subviews on the screen and DataHandling
    // The specific onboarding viewController will then pass the submiteddata back to this controller
    // This controller will then display the next controller and repeat, merging the new data with it's own instance.
    
    // On the final viewcontroller the submit button will submit the data to the database.


}
