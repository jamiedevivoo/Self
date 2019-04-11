struct AccountNotificationConsents {
    var allowActions:   Bool
    var allowInsights:  Bool
    var allowMoods:     Bool
    var allowFun:       Bool
    
    // TODO: Must be a better way of setting defaults
    init(_ allowActions:  Bool? = true,
         _ allowInsights: Bool? = true,
         _ allowMoods:    Bool? = true,
         _ allowFun:      Bool? = false) {
        
        self.allowActions = allowActions ?? true
        self.allowInsights = allowInsights ?? true
        self.allowMoods = allowMoods ?? true
        self.allowFun = allowFun ?? false
    }
}

// MARK: - Convenience Iniitialiser
extension AccountNotificationConsents {
    init(_ accountNotificationConsentPairs: [String:Any]) {
        let allowActions = accountNotificationConsentPairs["allow_actions"] as? Bool
        let allowInsights = accountNotificationConsentPairs["allow_insights"] as? Bool
        let allowMoods = accountNotificationConsentPairs["allow_moods"] as? Bool
        let allowFun = accountNotificationConsentPairs["allow_fun"] as? Bool
        
        self.init(allowActions, allowInsights, allowMoods, allowFun)
    }
}

extension AccountNotificationConsents: DictionaryConvertable {
    var dictionary: [String: Any] {
        return ["allow_actions":allowActions,
                "allow_insights":allowInsights,
                "allow_moods":allowMoods,
                "allow_fun":allowFun]
    }
}
