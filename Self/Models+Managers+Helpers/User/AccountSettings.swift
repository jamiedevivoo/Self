struct AccountSettings {
    var notifications: AccountSettingsNotifications = AccountSettingsNotifications()
    var features: AccountSettingsFeatures           = AccountSettingsFeatures()
    var userColorMode: AppColorMode                 = .auto
}

// MARK: - Convenience Iniitialiser
extension AccountSettings {
    init(_ settingsDictionary: [String:Any]) {
        self.notifications  = AccountSettingsNotifications(settingsDictionary["notifications"] as! [String : Any])
        self.features       = AccountSettingsFeatures(settingsDictionary["features"] as! [String : Any])
        self.userColorMode  = AppColorMode.matchCase(string: settingsDictionary["color_mode"] as! String)
    }
}

// MARL: - Output / Describing the model
extension AccountSettings: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Settings"
    }
    
    var dictionary: [String: Any] {
        return [
            "color_mode"    : userColorMode.rawValue,
            "notifications" : notifications.dictionary,
            "features"      : features.dictionary
        ]
    }
}
