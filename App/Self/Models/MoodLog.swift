import Firebase

extension Mood {
    struct Log {
        var uid: String?
        var headline: String
        var timestamp: Date
        var note: Note?
        var arousalRating: Double
        var valenceRating: Double
        
        var wildcard: Wildcard?
        var emotion: Emotion
        var tags = [Tag]()
    }
}
// MARK: - Convenience Iniitialiser
extension Mood.Log {
    init(_ moodDictionary: [String: Any]) {
        self.uid                = (moodDictionary["uid"] as? String ?? nil)
        self.headline           = (moodDictionary["headline"] as! String)
        self.timestamp          = (moodDictionary["timestamp"] as! Date)
        self.arousalRating      = (moodDictionary["arousal_rating"] as! Double)
        self.valenceRating      = (moodDictionary["valence_rating"] as! Double)
        if moodDictionary["note"] != nil {
            self.note = Note(moodDictionary["note"] as! [String: Any])
        }
        if moodDictionary["wildcard"] != nil {
            self.wildcard = Mood.Wildcard(moodDictionary["wildcard"] as! [String: Any])
        }
        self.emotion = EmotionManager.getEmotion(
            withValence: moodDictionary["valence_rating"] as! Double,
            withArousal: moodDictionary["arousal_rating"] as! Double)
        
        for tag in moodDictionary["tags"] as! [[String: Any]] {
            let tag = Tag(tag)
            self.tags.append(tag)
        }
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension Mood.Log: DictionaryConvertable {
    var dictionary: [String: Any] {
        return [
            "uid": uid as Any,
            "timestamp": timestamp as Any,
            "headline": headline as Any,
            "note": note?.dictionary as Any,
            "arousal_rating": arousalRating as Any,
            "valence_rating": valenceRating as Any,
            "tags": tags.map({$0.dictionary}) as Any,
            "wildcard": wildcard?.dictionary as Any
            ].filter({$0.value != nil})
    }
}

enum SentimentTrend {
    case positive
    case negative
    case neutral
}
