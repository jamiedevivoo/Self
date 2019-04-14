struct AccountUser {
    var name: NameString!
}

// MARK: - Convenience initialisers
extension AccountUser {
    init(_ infoDictionary: [String:Any]) {
        self.name = infoDictionary["name"] as? String ?? name
    }
}

// Output / Describing the model
extension AccountUser: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Reference for: \(String(describing: name))"
    }
    
    var dictionary: [String: Any] {
        return ["name":name!]
    }
}
