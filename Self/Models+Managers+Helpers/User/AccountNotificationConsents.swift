struct AccountNotificationConsents {
    let allowActions: Bool
    let allowInsights: Bool
    let allowMoods: Bool
    let allowFun: Bool
    
    init(allowActions: Bool = true,
         allowInsights: Bool = true,
         allowMoods: Bool = true,
         allowFun: Bool = false) {
        
        self.allowActions = allowActions
        self.allowInsights = allowInsights
        self.allowMoods = allowMoods
        self.allowFun = allowFun
    }
}

// Convenience Iniitialiser
extension AccountNotificationConsents {
    init(accountNotificationConsentPairs: [String:Any]) {
        let allowActions = accountNotificationConsentPairs["allow_actions"] as! Bool
        let allowInsights = accountNotificationConsentPairs["allow_insights"] as! Bool
        let allowMoods = accountNotificationConsentPairs["allow_moods"] as! Bool
        let allowFun = accountNotificationConsentPairs["allow_fun"] as! Bool
        
        self.init(allowActions: allowActions, allowInsights: allowInsights, allowMoods: allowMoods, allowFun: allowFun)
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
