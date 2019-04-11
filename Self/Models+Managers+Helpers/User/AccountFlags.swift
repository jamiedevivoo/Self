struct AccountFlags {
    let tutorialIsActive: Bool
    let verified: Bool

    // TODO: Must be a better way of setting defaults
    init(tutorialIsActive: Bool? = true,
         verified: Bool? = false) {
        
        self.tutorialIsActive = tutorialIsActive ?? true
        self.verified = verified ?? false
    }
}

// MARK: - Convenience Iniitialiser
extension AccountFlags {
    init(_ accountFlagPairs: [String:Any]) {
        let tutorialIsActive = accountFlagPairs["tutorial_active"] as? Bool
        let verified = accountFlagPairs["verified"] as? Bool
        self.init(tutorialIsActive: tutorialIsActive, verified: verified)
    }
}

extension AccountFlags: DictionaryConvertable {
    var dictionary: [String: Any] {
        return ["tutorial_active":tutorialIsActive,
                "verified":verified]
    }
}
