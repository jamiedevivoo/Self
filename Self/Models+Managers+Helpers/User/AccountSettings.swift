import Firebase

class AccountSettings {
    var flags: AccountFlags
    var notifications: AccountNotificationConsents
    var userColorMode: UserColorMode
    
    init(accountFlags: AccountFlags = AccountFlags(),
         accountNotificationConsents: AccountNotificationConsents = AccountNotificationConsents(),
         userColorMode: UserColorMode = .auto) {
        
        self.flags = accountFlags
        self.notifications = accountNotificationConsents
        self.userColorMode = userColorMode
    }
}

// Convenience Initialisers
extension AccountSettings {
    convenience init(accountSettingPairs: [String:Any], accountFlagPairs: [String:Any], accountNotificationConsentPairs: [String:Any]) {
        let userColorMode = accountSettingPairs["color_mode"]
        let accountFlags = AccountFlags(accountFlagPairs: accountFlagPairs)
        let accountNotificationConsents = AccountNotificationConsents(accountNotificationConsentPairs: accountNotificationConsentPairs)
        self.init(accountFlags: accountFlags, accountNotificationConsents: accountNotificationConsents, userColorMode: userColorMode)
    }
    
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        let accountSettingPairs = snapshot.get("settings") as! [String:Any]
        let accountFlagPairs = snapshot.get("settings.flags") as! [String:Any]
        let accountNotificationConsentPairs = snapshot.get("settings.notification_consent") as! [String:Any]
        
        self.init(accountSettingPairs: accountSettingPairs,
                  accountFlagPairs: accountFlagPairs,
                  accountNotificationConsentPairs: accountNotificationConsentPairs)
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
