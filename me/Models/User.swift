import Firebase

class User: CustomStringConvertible {
    
    var description: String {
        return "User: name: \(surname), email: \(email)"
    }
    
    var dictionary: [String: Any] {
        return [
            "email": email,
            "surname": surname
        ]
    }
    
    var uid: String
    var name: String
    var surname: String!
    var email: String!
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
        self.name = userData["name"] as? String ?? ""
    }
    
    init(dictionary: [String: String]) {
        self.uid = dictionary["uid"]!
        self.name = dictionary["name"] ?? ""
    }
    
    private init(user: User) {
        self.uid = user.uid
        self.name = user.name
    }
    
//    func author() -> [String: String] {
//        return ["uid": uid, "name": name]
//    }
    
}
