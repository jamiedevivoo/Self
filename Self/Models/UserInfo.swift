import Firebase

class UserInfo: CustomStringConvertible {
    
    // MARK: - Describe Properties
    var description: String {
        return "User: name: \(name), email: \(email)"
    }
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "email": email
        ]
    }

    // MARK: - Properties
    var uid: String
    var name: String?
    var email: String
    var lastname: String?
    
    // MARK: - Init
    init(snapshot: DocumentSnapshot) {
        let userData = snapshot.data()! as [String: Any]
        self.uid = snapshot.documentID
        self.name = userData["firstname"] as? String ?? ""
        self.email = userData["email"] as? String ?? ""
        self.lastname = userData["lastname"] as? String ?? ""
    }
    
    init(dictionary: [String: String]) {
        self.uid = dictionary["uid"]!
        self.name = dictionary["name"] ?? ""
        self.lastname = dictionary["lastname"] ?? ""
        self.email = dictionary["email"] ?? ""
    }
    
//    init(authUser: UserInfo) {
//        self.uid = authUser.uid
//    }
    
    private init(userInfo: UserInfo) {
        self.uid = userInfo.uid
        self.name = userInfo.name
        self.lastname = userInfo.lastname
        self.email = userInfo.email
    }
    
    private init(authUser: User) {
        self.uid = authUser.uid
        self.email = authUser.email!
    }
    
    // MARK: - Functions
    // Only functions for Outputing User Data belong here, Database functions are stored in Account Manager
    
//    func author() -> [String: String] {
//        return ["uid": uid, "name": name]
//    }
    
}
