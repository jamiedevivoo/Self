import Firebase

class UserData {
    
    let uid: UIDString
    var name: NameString

    private init(uid: UIDString, name: NameString) {
        print("Creating UserData")
        self.uid = uid
        self.name = name
    }
}

// Convenience initialisers
extension UserData {
    
    convenience init(withDictionary dictionary: [UserProperty: String]) {
        self.init(uid: dictionary[.uid]!,
                  name: dictionary[.name]!)
    }
    
    convenience init(withSnapshot snapshot: DocumentSnapshot) {
        let accountData = snapshot.data()! as [String: Any]
        self.init(uid: snapshot.documentID,
                  name: accountData["name"]! as! NameString)
    }
    
    convenience init(withUser userData: UserData) {
        self.init(uid: userData.uid,
                  name: userData.name)
    }
}

// Dictionary Keys
extension UserData {
    enum UserProperty: String, CaseIterable, DefinedDictionaryKeys { //CustomStringConvertable
        case uid = "uid"
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
                case .uid: dictionary[property.key] = uid
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
