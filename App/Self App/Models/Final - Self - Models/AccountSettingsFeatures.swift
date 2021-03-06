extension Account.Settings {
    
    struct Features {
            var highlightsAreActive: Bool   = false
            var insightsAreActive: Bool     = false
    }
    
}

// MARK: - Convenience Iniitialiser
extension Account.Settings.Features {
    init(_ featuresDictionary: [String: Any]) {
        self.highlightsAreActive    = featuresDictionary["highlights_active"]  as? Bool ?? highlightsAreActive
        self.insightsAreActive      = featuresDictionary["insights_active"]    as? Bool ?? insightsAreActive
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension Account.Settings.Features: DictionaryConvertable {
    var dictionary: [String: Any] {
        return [
            "highlights_active": highlightsAreActive,
            "insights_active": insightsAreActive
        ]
    }
}
