extension Account {
    
    struct Settings {
        var notifications: Account.Settings.Notifications = Account.Settings.Notifications()
        var features: Account.Settings.Features           = Account.Settings.Features()
        var userColorMode: AppColorMode                 = .auto
    }
    
}
// MARK: - Convenience Iniitialiser
extension Account.Settings {
    init(_ settingsDictionary: [String: Any]) {
        self.notifications  = Account.Settings.Notifications(settingsDictionary["notifications"] as! [String: Any])
        self.features       = Account.Settings.Features(settingsDictionary["features"] as! [String: Any])
        self.userColorMode  = AppColorMode.matchCase(string: settingsDictionary["color_mode"] as! String)
    }
}

// MARL: - Output / Describing the model
extension Account.Settings: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Settings"
    }
    
    var dictionary: [String: Any] {
        return [
            "color_mode": userColorMode.rawValue,
            "notifications": notifications.dictionary,
            "features": features.dictionary
        ]
    }
}
