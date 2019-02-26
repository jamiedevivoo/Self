import Firebase
import FirebaseFirestore
import FirebaseCore

class FPUser {
    var uid: String
    var name: String
    var profilePictureURL: URL?
    
    init(snapshot: DocumentSnapshot) {
        self.uid = snapshot.documentID
        let value = snapshot.data() as! [String: Any]
        self.name = value["full_name"] as? String ?? ""
        guard let profile_picture = value["profile_picture"] as? String,
            let profilePictureURL = URL(string: profile_picture) else { return }
        self.profilePictureURL = profilePictureURL
    }
    
    init(dictionary: [String: String]) {
        self.uid = dictionary["uid"]!
        self.name = dictionary["full_name"] ?? ""
        guard let profile_picture = dictionary["profile_picture"],
            let profilePictureURL = URL(string: profile_picture) else { return }
        self.profilePictureURL = profilePictureURL
    }
    
    private init(user: User) {
        self.uid = user.uid
        self.name = user.displayName ?? ""
        self.profilePictureURL = user.photoURL
    }
    
    static func currentUser() -> FPUser {
        return FPUser(user: Auth.auth().currentUser!)
    }
    
    func author() -> [String: String] {
        return ["uid": uid, "name": name, "profile_picture": profilePictureURL?.absoluteString ?? ""]
    }
}

extension FPUser: Equatable {
    static func ==(lhs: FPUser, rhs: FPUser) -> Bool {
        return lhs.uid == rhs.uid
    }
    static func ==(lhs: FPUser, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
