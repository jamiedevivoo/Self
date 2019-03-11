import UIKit

class NameOnboardingViewController: UIViewController {
    
    let onboardingIndex = 2
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension NameOnboardingViewController: Onboarding {
}
extension NameOnboardingViewController: OnboardingNameViewDelegate {
    
}
