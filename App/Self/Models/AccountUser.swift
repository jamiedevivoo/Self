extension Account {
    
    struct User {
        var name: String!
    }
    
}
// MARK: - Convenience initialisers
extension Account.User {
    init(_ infoDictionary: [String: Any]) {
        self.name = infoDictionary["name"] as? String ?? name
    }
}

// Output / Describing the model
extension Account.User: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Reference for: \(String(describing: name))"
    }
    
    var dictionary: [String: Any] {
        return ["name": name!]
    }
}
