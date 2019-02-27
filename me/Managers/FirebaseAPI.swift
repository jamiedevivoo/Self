class FirebaseAPI {
    
    //Test
    static func getProfiles() -> [Profile]{
        let user:Dictionary = [
            "uid":"123",
            "name":"Jamie"
        ]
        let profile = [
                Profile(dictionary: user),
                Profile(dictionary: user)
        ]
        return profile
    }
}
