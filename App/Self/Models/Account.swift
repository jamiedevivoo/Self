import Firebase

class Account {
    let uid: String!
    var user: AccountUser!
    var settings: AccountSettings!
    var flags: AccountFlags!
    
    init(
        uid: String,
        accountUser: AccountUser,
        accountSettings: AccountSettings    = AccountSettings(),
        accountFlags: AccountFlags          = AccountFlags())
    {
        self.uid        = uid
        self.user       = accountUser
        self.settings   = accountSettings
        self.flags      = accountFlags
    }
}

// MARK: - Convenience Initialisers
extension Account {
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        self.init(
            uid:                snapshot.documentID,
            accountUser:        AccountUser(snapshot.get("user")            as! [String:Any]),
            accountSettings:    AccountSettings(snapshot.get("settings")    as! [String:Any]),
            accountFlags:       AccountFlags(snapshot.get("flags")          as! [String:Any])
        )
    }
}

// MARK: - Output / Describing the model
extension Account: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Account Object"
    }

    var dictionary: [String: Any] {
        return ["user":user.dictionary,
                "flags":flags.dictionary,
                "settings":settings.dictionary]
    }
}
