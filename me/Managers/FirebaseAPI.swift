import Firebase

class FirebaseAPI {
    
    //Test
    static func getProfiles() -> [User]{
        let user:Dictionary = [
            "uid":"123",
            "name":"Jamie"
        ]
        let profile = [
                User(dictionary: user),
                User(dictionary: user)
        ]
        return profile
    }
}
