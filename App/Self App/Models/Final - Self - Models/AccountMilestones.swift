extension Account {
    
    struct Milestones {
        var milestones: [String:Bool] = [:]
    }
    
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension Account.Milestones: DictionaryConvertable {
    var dictionary: [String: Any] {
        return milestones
    }
}
