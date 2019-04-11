import Firebase

class Account {
    let uid: UIDString!
    var user: UserData
    var preferences: AccountPreferences
    
    init(uid: UIDString!, userData:UserData, accountPreferences: AccountPreferences = AccountPreferences()) {
        self.uid = uid
        self.user = userData
        self.preferences = accountPreferences
    }
}
extension Account {
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        let uid: UIDString = snapshot.data()!.documentID
        let userData: UserData = UserData(withSnapshot: snapshot)
        let accountPreferences: AccountPreferences = AccountPreferences(withSnapshot: snapshot)
        self.init(uid: uid, userData: userData, accountPreferences: accountPreferences)
    }
}

// MARK: - Output / Describing the model
extension Account: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Account Object"
    }
    
    var dictionary: [String: Any] {
        // TODO: Eventually need to make this loop through 'userdata' and add dictionary pairs generically
        return ["name":user.name,
                "settings":preferences.dictionary]
    }
}
