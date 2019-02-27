import Firebase

class User: Profile, CustomStringConvertible {
    
    var description: String {
        return "User: name: \(surname), email: \(email)"
    }
    
    var dictionary: [String: Any] {
        return [
            "email": email,
            "surname": surname
        ]
    }
    
    var surname: String!
    var email: String!
    
//    init() {
//        let currentUser = Auth.auth().currentUser
//        super.init(snapshot: <#T##DocumentSnapshot#>)
//        self.uid = currentUser!.uid
//        
//    }
    
    
    override init(snapshot: DocumentSnapshot) {
        self.surname = "Name"
        self.email = "Email"
        super.init(snapshot: snapshot)
    }

    
    
}
