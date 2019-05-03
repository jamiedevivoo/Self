import Firebase

struct MoodLog {
    var uid: String?
    var headline: String?
    var timestamp: Timestamp?
    var note: String?
    var arousalRating: Double?
    var valenceRating: Double?
    
    var wildcard: Wildcard?
    var emotion: Emotion?
    var tags = [Tag]()
}

// MARK: - Convenience Iniitialiser
extension MoodLog {
    init(_ moodDictionary: [String:Any]) {
        self.uid                = (moodDictionary["uid"] as! String)
        self.headline           = (moodDictionary["headline"] as! String)
        self.timestamp          = (moodDictionary["timestamp"] as! Timestamp)
        self.note               = (moodDictionary["note"] as! String)
        self.arousalRating      = (moodDictionary["arousal_rating"] as! Double)
        self.valenceRating      = (moodDictionary["valence_rating"] as! Double)
        self.wildcard           = Wildcard(moodDictionary["wildcard"] as! [String : Any])
        self.emotion            = EmotionManager.getEmotion(
                                    withValence: moodDictionary["valence_rating"] as! Double,
                                    withArousal: moodDictionary["arousal_rating"] as! Double)
        for tag in moodDictionary["tags"] as! [[String:Any]] {
            let tag = Tag(tag)
            self.tags.append(tag)
        }
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension MoodLog: DictionaryConvertable {
    var dictionary: [String: Any] {
        var tagsArray = [[String:Any]]()
        for tag in tags {
            tagsArray.append(tag.dictionary)
        }
        return [
            "uid":              uid as Any,
            "timestamp":        timestamp as Any,
            "headline":         headline as Any,
            "note":             note as Any,
            "arousal_rating":   arousalRating as Any,
            "valence_rating":   valenceRating as Any,
            "tags":             tagsArray as Any,
            "wildcard":         wildcard?.dictionary as Any,
        ]
    }
}

enum SentimentTrend {
    case positive
    case negative
    case neutral
}
