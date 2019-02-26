import Firebase

class Profile {
    var uid: String
    var name: String
    var me: Me?
    
    init(snapshot: DocumentSnapshot) {
        let userData = snapshot.data() as! [String: Any]
        self.uid = snapshot.documentID
        self.name = userData["name"] as? String ?? ""
    }
    
    init(dictionary: [String: String]) {
        self.uid = dictionary["uid"]!
        self.name = dictionary["name"] ?? ""
    }
    
    private init(user: Profile) {
        self.uid = user.uid
        self.name = user.name
    }
    
    func author() -> [String: String] {
        return ["uid": uid, "name": name]
    }
}
