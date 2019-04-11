import Firebase

class Account {
    var user: UserData
    var settings: AccountSettings
    
    init(userData:UserData, accountSettings: AccountSettings = AccountSettings()) {
        self.user = userData
        self.settings = accountSettings
    }
}
extension Account {
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        let userData: UserData = UserData(withSnapshot: snapshot)
        let accountSettings: AccountSettings = AccountSettings()
        self.init(userData: userData, accountSettings: accountSettings)
    }
}

