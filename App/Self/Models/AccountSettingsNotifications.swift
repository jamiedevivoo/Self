extension Account.Settings {
    
    struct Notifications {
        var allowActions: Bool  = true
        var allowInsights: Bool = true
        var allowMoods: Bool    = true
        var allowFun: Bool      = false
    }
    
}
// MARK: - Convenience Iniitialiser
extension Account.Settings.Notifications {
    init(_ notificationsDictionary: [String:Any]) {
        self.allowActions   = notificationsDictionary["allow_actions"]  as? Bool ?? allowActions
        self.allowInsights  = notificationsDictionary["allow_insights"] as? Bool ?? allowInsights
        self.allowMoods     = notificationsDictionary["allow_moods"]    as? Bool ?? allowMoods
        self.allowFun       = notificationsDictionary["allow_fun"]      as? Bool ?? allowFun
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension Account.Settings.Notifications: DictionaryConvertable {
    var dictionary: [String: Any] {
        return [
            "allow_actions" : allowActions,
            "allow_insights": allowInsights,
            "allow_moods"   : allowMoods,
            "allow_fun"     : allowFun
        ]
    }
}
