import Firebase

class Account {
    var user: UserData
    var settings: AccountSettings
    
    init(userData:UserData, accountSettings: AccountSettings = AccountSettings()) {
        print("Creating Account")
        self.user = userData
        self.settings = accountSettings
    }
}
extension Account {
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        let userData: UserData = UserData(withSnapshot: snapshot)
        let accountSettings: AccountSettings = AccountSettings(withSnapshot: snapshot)
        self.init(userData: userData, accountSettings: accountSettings)
    }
}

