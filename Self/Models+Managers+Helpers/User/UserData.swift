import Firebase

class UserData {
    
    // MARK: - Properties
    var uid: String
    var name: String?
    var email: String
    var lastname: String?

    // MARK: - Init
    init(dictionary: [String: String]) {
        self.uid = dictionary["uid"]!
        self.name = dictionary["name"] ?? ""
        self.lastname = dictionary["lastname"] ?? ""
        self.email = dictionary["email"] ?? ""
    }
    
    init(snapshot: DocumentSnapshot) {
        let userData = snapshot.data()! as [String: Any]
        self.uid = snapshot.documentID
        self.name = userData["firstname"] as? String ?? ""
        self.email = userData["email"] as? String ?? ""
        self.lastname = userData["lastname"] as? String ?? ""
    }
    
    private init(userData: UserData) {
        self.uid = userData.uid
        self.name = userData.name
        self.lastname = userData.lastname
        self.email = userData.email
    }
}

// MARK: - Convenience Init
extension UserData {
//    
//    private convenience init(authUser: User) {
//        var userData: [String:String]
//        userData["uid"] = authUser.uid
//        userData["email"] = authUser.email!
//        self.init(dictionary: userData)
//    }
}
// MARK: - Output Data
extension UserData {
//    func author() -> [String: String] {
//        return ["uid": uid, "name": name]
//    }
    
}

// MARK: - User Settings
extension UserData {
    
}

extension UserData: CustomStringConvertible {
    // MARK: - Describe Properties
    var description: String {
        return "User: name: \(String(describing: name)), email: \(email)"
    }
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "name": name!,
            "email": email
        ]
    }
}
