struct AccountNotificationConsents {
    let allowActions: Bool = true
    let allowInsights: Bool = true
    let allowMoods: Bool = true
    let allowFun: Bool = false
}

extension AccountNotificationConsents: DictionaryConvertable {
    var dictionary: [String: Any] {
        return ["allow_actions":allowActions,
                "allow_insights":allowInsights,
                "allow_moods":allowMoods,
                "allow_fun":allowFun]
    }
}
