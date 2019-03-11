protocol Onboarding {
        
    var onboardingIndex: Int {get}
}
protocol OnboardingMoodViewDelegate {
    var mood: Float? { get }
}
protocol OnboardingNameViewDelegate {
    var name: String? { get }
}
protocol OnboardingMissionViewDelegate {
    var mission: String? { get }
}
protocol OnboardingAccountViewDelegate {
    var email: String? { get}
    var password: String? { get}
    var passwordConfirm: String? { get}
}
