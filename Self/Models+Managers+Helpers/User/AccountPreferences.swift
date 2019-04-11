import Firebase

class AccountPreferences {
    var flags: AccountFlags
    var notifications: AccountNotificationConsents
    var userColorMode: UserSpecifiedColorMode
    
    // TODO: Must be a better way of setting defaults
    init(accountFlags: AccountFlags = AccountFlags(),
         accountNotificationConsents: AccountNotificationConsents = AccountNotificationConsents(),
         userColorMode: UserSpecifiedColorMode = .auto) {
        
        self.flags = accountFlags
        self.notifications = accountNotificationConsents
        self.userColorMode = userColorMode
    }
}

// Mark: - Convenience Initialisers
extension AccountPreferences {
    convenience init(accountSettingPairs: [String:Any],
                     accountFlagPairs: [String:Any],
                     accountNotificationConsentPairs: [String:Any]) {
        
        let accountFlags = AccountFlags(accountFlagPairs)
        let accountNotificationConsents = AccountNotificationConsents(accountNotificationConsentPairs)
        
        let userColorMode = UserSpecifiedColorMode.matchCase(string: accountSettingPairs["color_mode"] as! String)
        
        self.init(accountFlags: accountFlags,
                  accountNotificationConsents: accountNotificationConsents,
                  userColorMode: userColorMode)
    }
    
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        let accountSettingPairs = snapshot.get("preferences") as! [String:Any]
        print(accountSettingPairs)
        let accountFlagPairs = snapshot.get("preferences.flags") as! [String:Any]
        let accountNotificationConsentPairs = snapshot.get("preferences.notification_consent") as! [String:Any]
        
        self.init(accountSettingPairs: accountSettingPairs,
                  accountFlagPairs: accountFlagPairs,
                  accountNotificationConsentPairs: accountNotificationConsentPairs)
    }
}

// MARL: - Output / Describing the model
extension AccountPreferences: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Settings"
    }
    
    var dictionary: [String: Any] {
        return ["color_mode":userColorMode.rawValue,
                "notification_consent":notifications.dictionary,
                "flags":flags.dictionary]
    }
}

// MARK: - Possible Colour Mode Settings
extension AccountPreferences {
    enum UserSpecifiedColorMode: String, CaseIterable {
        case light
        case dark
        case auto
        
        static func matchCase(string:String) -> UserSpecifiedColorMode {
            switch string {
            case self.light.rawValue:   return .light
            case self.dark.rawValue:    return .dark
            default:                    return .auto
            }
        }
    }
}
