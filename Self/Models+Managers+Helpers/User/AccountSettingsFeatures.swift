struct AccountSettingsFeatures {
        var highlightsAreActive: Bool   = false
        var insightsAreActive: Bool     = false
}

// MARK: - Convenience Iniitialiser
extension AccountSettingsFeatures {
    init(_ featuresDictionary: [String:Any]) {
        self.highlightsAreActive    = featuresDictionary["highlights_active"]  as? Bool ?? highlightsAreActive
        self.insightsAreActive      = featuresDictionary["insights_active"]    as? Bool ?? insightsAreActive
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension AccountSettingsFeatures: DictionaryConvertable {
    var dictionary: [String: Any] {
        return [
            "highlights_active" : highlightsAreActive,
            "insights_active"   : insightsAreActive
        ]
    }
}
