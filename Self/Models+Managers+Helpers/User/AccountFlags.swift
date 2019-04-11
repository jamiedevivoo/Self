struct AccountFlags {
    let tutorialIsActive: Bool
    let verified: Bool
    
    init(tutorialIsActive: Bool = true,
         verified: Bool = false) {
        
        self.tutorialIsActive = tutorialIsActive
        self.verified = verified
    }
}

// Convenience Iniitialiser
extension AccountFlags {
    init(accountFlagPairs: [String:Any]) {
        let tutorialIsActive = accountFlagPairs["tutorial_active"] as! Bool
        let verified = accountFlagPairs["verified"] as! Bool
        self.init(tutorialIsActive: tutorialIsActive, verified: verified)
    }
}

extension AccountFlags: DictionaryConvertable {
    var dictionary: [String: Any] {
        return ["tutorial_active":tutorialIsActive,
                "verified":verified]
    }
}
