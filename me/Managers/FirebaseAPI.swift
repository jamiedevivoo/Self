import Firebase

class FirebaseAPI {
    
    static let shared = FirebaseAPI()
    
    let db = Firestore.firestore()
    
    private init() { }
    
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
