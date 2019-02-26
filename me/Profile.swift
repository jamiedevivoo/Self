import Firebase

class Profile {
    var uid: String
    var name: String
    var me: Me!
    
    init(snapshot: DocumentSnapshot) {
        let userData = snapshot.data() as! [String: Any]
        let userMe = userData["me"] as! [String: Any]
        self.uid = snapshot.documentID
        self.name = userData["name"] as? String ?? ""
        self.me = Me(dictionary: userMe)
    }
    
    init(dictionary: [String: String]) {
        self.uid = dictionary["uid"]!
        self.name = dictionary["name"] ?? ""
        
        var userMe = dictionary["me"] as
        self.me = Me(dictionary: userMe)
    }
    
    private init(user: Profile) {
        self.uid = user.uid
        self.name = user.name
        self.me = Me(dictionary: userMe)
    }
    
    func author() -> [String: String] {
        return ["uid": uid, "name": name]
    }
}
