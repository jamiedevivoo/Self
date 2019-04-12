import Firebase

class UserData {
    var name: NameString!

    private init(name: NameString! = "Stranger") {
        self.name = name
    }
}

// MARK: - Convenience initialisers
extension UserData {
    
    convenience init(withDictionary dictionary: [UserProperty: String]) {
        self.init(name: dictionary[.name])
    }
    
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        self.init(name: (snapshot.get("name") as! NameString))
    }
    
    convenience init(withUser userData: UserData) {
        self.init(name: userData.name)
    }
    
    convenience init() {
        self.init(name: "Stranger")
    }
}

// Dictionary Keys
extension UserData {
    enum UserProperty: String, CaseIterable, DefinedDictionaryKeys { //CustomStringConvertable
        case name = "name"
        
        var key: String {
            return rawValue
        }
    }
}

// Output / Describing the model
extension UserData: CustomStringConvertible, DictionaryConvertable {
    var description: String {
        return "User Reference for: \(String(describing: name))"
    }
    
    var dictionary: [String: Any] {
        var dictionary = [String : Any]()
        for property in UserProperty.allCases {
            switch property {
                case .name: dictionary[property.key] = name
            }
        }
        return dictionary
    }
}

/* Links
 Type Safe Stuff
 https://blog.usejournal.com/type-safe-swift-models-fce55d6eccc7
 Dictionary enum keys
 https://www.swiftbysundell.com/posts/enum-iterations-in-swift-42
 Custom Collection Definitions
 https://www.swiftbysundell.com/posts/creating-custom-collections-in-swift
 */
