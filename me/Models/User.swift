import Firebase

class User: CustomStringConvertible {
    
    var description: String {
        return "User: name: \(name), email: \(email)"
    }
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "email": email,
            "surname": surname
        ]
    }
    
    var uid: String
    var name: String
    var surname: String
    var email: String
    var me: Me?
    
//    init() {
//        let currentUser = Auth.auth().currentUser
//        super.init(snapshot: <#T##DocumentSnapshot#>)
//        self.uid = currentUser!.uid
//        
//    }
    
    init(snapshot: DocumentSnapshot) {
        let userData = snapshot.data()! as [String: Any]
        self.uid = snapshot.documentID
        self.name = userData["firstname"] as? String ?? ""
        self.surname = userData["surname"] as? String ?? ""
        self.email = userData["email"] as? String ?? ""
    }
    
    init(dictionary: [String: String]) {
        self.uid = dictionary["uid"]!
        self.name = dictionary["name"] ?? ""
        self.surname = dictionary["surname"] ?? ""
        self.email = dictionary["email"] ?? ""
    }
    
    private init(user: User) {
        self.uid = user.uid
        self.name = user.name
        self.surname = user.uid
        self.email = user.email
    }
    
//    func author() -> [String: String] {
//        return ["uid": uid, "name": name]
//    }
    
}
