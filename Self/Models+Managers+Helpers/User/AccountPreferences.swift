import Firebase

class AccountPreferences {
    var flags: AccountFlags
    var notifications: AccountNotificationConsents
    var userColorMode: AppColorMode
    
    // TODO: Must be a better way of setting defaults
    init(accountFlags: AccountFlags = AccountFlags(),
         accountNotificationConsents: AccountNotificationConsents = AccountNotificationConsents(),
         userColorMode: AppColorMode = .auto) {
        
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
        
        let userColorMode = AppColorMode.matchCase(string: accountSettingPairs["color_mode"] as! String)
        
        self.init(accountFlags: accountFlags,
                  accountNotificationConsents: accountNotificationConsents,
                  userColorMode: userColorMode)
    }
    
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        let accountSettingPairs = snapshot.get("preferences") as! [String:Any]
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
