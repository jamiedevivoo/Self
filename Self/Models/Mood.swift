
import Firebase

class Mood {
    
    // MARK: - Properties
    var uid: String?
    var timestamp: Timestamp?
    var headline: String?
    var note: String?
    var tags: [String]?
    var arousal_rating: Double?
    var valence_rating: Double?
    var wildcard: [String:String]?
    
    var dictionary: [String: Any] {
        return [
            "uid": uid as Any,
            "timestamp": timestamp,
        	"headline": headline,
        	"note": note,
        	"tags": tags,
        	"arousal_rating": arousal_rating,
        	"valence_rating": valence_rating,
            "wildcard": wildcard
        ]
    }
    
    init() {
        
    }
    
    // MARK: - Init
    
//
//    init(snapshot: DocumentSnapshot) {
//        let moodData = snapshot.data()
//        self.uid = snapshot.documentID
//        self.timestamp = (moodData?["timestamp"] as? Timestamp ?? nil)!
//        self.headline = moodData["headline"] as? String ?? ""
//        self.note = moodData["note"] as? String ?? ""
//        self.tags = moodData["tags"] as? [String] ?? ""
//        self.arousal_rating = moodData["arousal_rating"] as? Double ?? ""
//        self.valence_rating = moodData["valence_rating"] as? Double ?? ""
//        self.wildcard = moodData["wildcard"] as? [String:String] ?? ""
//    }
    
//        init?(dictionary: [String: Any]){
//            guard let firstName = dictionary["firstName"] as? String else { return nil }
//            guard let lastName = dictionary["lastName"] as? String else { return nil }
//        }
//        self.init(firstName: firstName, lastName: lastName)
//
//    init(dictionary: [String: Any]) {
//        guard self.headline = dictionary. else {
//            <#statements#>
//        }
//        self.uid = dictionary["uid"]!
//        self.name = dictionary["name"] ?? ""
//        self.lastname = dictionary["lastname"] ?? ""
//        self.email = dictionary["email"] ?? ""
//    }
    
}
