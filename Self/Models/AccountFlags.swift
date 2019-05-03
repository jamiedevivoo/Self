struct AccountFlags {
    var accountIsValidated: Bool    = false
    var accountIsComplete: Bool     = false
    var accountIsActive: Bool       = true
    var tutorialIsActive: Bool      = true
}

// MARK: - Convenience Iniitialiser
extension AccountFlags {
    init(_ flagsDictionary: [String:Any]) {
        self.accountIsValidated = flagsDictionary["account_validated"]   as? Bool ?? accountIsValidated
        self.accountIsComplete  = flagsDictionary["account_complete"]  as? Bool ?? accountIsComplete
        self.accountIsActive    = flagsDictionary["account_active"]   as? Bool ?? accountIsActive
        self.tutorialIsActive   = flagsDictionary["tutorial_active"]   as? Bool ?? tutorialIsActive
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension AccountFlags: DictionaryConvertable {
    var dictionary: [String: Any] {
        return [
            "account_active"    : accountIsActive,
            "account_complete"  : accountIsComplete,
            "account_validated" : accountIsValidated,
            "tutorial_active"   : tutorialIsActive
        ]
    }
}
