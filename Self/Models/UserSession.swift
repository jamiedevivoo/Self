import Firebase

class UserSession: UserData {
    
    // MARK: - Describe Properties
    override var description: String {
        return "Logged in user: \(email)"
    }
    
}
