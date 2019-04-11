import Firebase

class AccountSettings {
    var flags: AccountFlags
    var notifications: AccountNotificationConsents
    var userColorMode: UserColorMode
    
    init(accountFlags: AccountFlags = AccountFlags(),
         accountNotificationConsents: AccountNotificationConsents = AccountNotificationConsents(),
         userColorMode: UserColorMode = .auto)
    {
        self.flags = accountFlags
        self.notifications = accountNotificationConsents
        self.userColorMode = userColorMode
    }
}

// Convenience Initialisers
extension AccountSettings {
    convenience init?(withSnapshot snapshot: DocumentSnapshot) {
        let userData = snapshot.data()! as [String: Any]
        self.init(accountFlags: AccountFlags(), accountNotificationConsents: AccountNotificationConsents(), userColorMode: .auto)
//        self.init(uid: snapshot.documentID,
//                  name: userData["name"]! as! NameString,
//                  email: userData["email"]! as! EmailString)
    }
}

// Output / Describing the model
extension AccountSettings: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Settings"
    }
    
    var dictionary: [String: Any] {
        return ["color_mode":userColorMode,
                "notification_consent":notifications.dictionary,
                "flags":flags.dictionary]
    }
}

// Possible Colour Mode Settings
extension AccountSettings {
    enum UserColorMode {
        case light
        case dark
        case auto
    }
}
