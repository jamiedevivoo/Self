import UIKit

class AccountOnboardingViewController: UIViewController {

    let onboardingIndex = 4
    var email: String?
    var password: String?
    var passwordConfirm: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension AccountOnboardingViewController: Onboarding {
}
extension AccountOnboardingViewController: OnboardingAccountViewDelegate {
    
}
