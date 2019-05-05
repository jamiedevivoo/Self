import Firebase

class Account {
    let uid: String!
    var user: Account.User!
    var settings: Account.Settings!
    var flags: Account.Flags!
    
    init(
        uid: String,
        accountUser: Account.User,
        accountSettings: Account.Settings    = Account.Settings(),
        accountFlags: Account.Flags          = Account.Flags())
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
            accountUser:        Account.User(snapshot.get("user")            as! [String:Any]),
            accountSettings:    Account.Settings(snapshot.get("settings")    as! [String:Any]),
            accountFlags:       Account.Flags(snapshot.get("flags")          as! [String:Any])
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
