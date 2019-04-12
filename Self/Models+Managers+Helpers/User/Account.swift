import Firebase

class Account {
    let uid: UIDString!
    var user: UserData!
    var preferences: AccountPreferences
    
    init(uid: UIDString! = nil, userData:UserData! = UserData(), accountPreferences: AccountPreferences = AccountPreferences()) {
        self.uid = uid
        self.user = userData
        self.preferences = accountPreferences
    }
}
extension Account {
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        self.init(uid: snapshot.documentID,
                  userData: UserData(withSnapshot: snapshot),
                  accountPreferences: AccountPreferences(withSnapshot: snapshot))
        }
    
    convenience init(withID uid:UIDString!, withData userData:UserData!) {
        self.init(uid: uid, userData: userData)
    }
}

// MARK: - Output / Describing the model
extension Account: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Account Object"
    }
    
    var dictionary: [String: Any] {
        // TODO: Look to see if there's a way to make this loop through 'userdata' and add dictionary pairs generically
        return ["name":user.name!,
                "preferences":preferences.dictionary]
    }
}
