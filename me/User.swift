import Firebase

class User: Profile {
    var surname: String
    var email: String
    
    override init(snapshot: DocumentSnapshot) {
        self.surname = "Name"
        self.email = "Email"
        super.init(snapshot: snapshot)
    }
    
}
