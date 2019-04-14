import UIKit

protocol OnboardingFlowDelegate: class {
    func nextStage()
}
protocol OnboardingManagerDelegate: class {
     func continueOnboarding()
}

protocol UpdateAccountViews {
    var accountDependantViews: [UIView] { get }
}
//
//extension UpdateAccountViews {
//    func updateAccountViews(accountDependantViews: [UIView] = accountDependantViews) {
//        for view in accountDependantViews {
//        }
//    }
//}

protocol AccountInfoObject { }
