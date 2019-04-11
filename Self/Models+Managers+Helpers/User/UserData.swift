import Firebase

enum UserProperties: String, CaseIterable { //CustomStringConvertable
    case uid = "uid"
    case name = "name"
}

class UserData {
    
    // MARK: - Properties
    let uid: UIDString
    var name: NameString
    var lastname: String?

    // MARK: - Init
    init(withDictionary dictionary: [UserProperties: String]) {
        self.uid = dictionary[.uid]!
        self.name = dictionary[.name]!
    }
    
    init(withSnapshot snapshot: DocumentSnapshot) {
        let userData = snapshot.data()! as [String: Any]
        self.uid = snapshot.documentID
        self.name = userData["name"] as! String
        self.lastname = userData["lastname"] as? String ?? ""
    }
    
    private init(userData: UserData) {
        self.uid = userData.uid
        self.name = userData.name
        self.lastname = userData.lastname
    }
}

// Output / Describing the model
extension UserData: CustomStringConvertible {
    var description: String {
        return "User Reference for: \(String(describing: name))"
    }
    
    var dictionary: [String: Any] {
        var userProperties = [String : Any]()
        for property in UserProperties.allCases {
            switch property {
                case .uid: userProperties[property.rawValue] = uid
                case .name: userProperties[property.rawValue] = name
            }
        }
        return userProperties
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
