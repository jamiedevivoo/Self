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
        
        if let note: [String: Any] = moodDictionary["note"] as? [String: Any] {
            self.note = Note(note)
        }
        
        if let wildcard: [String: Any] = moodDictionary["wildcard"] as? [String: Any] {
            self.wildcard = Mood.Wildcard(wildcard)
        }
        
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
        var dictionary = [
            "uid": uid as Any,
            "timestamp": timestamp as Any,
            "headline": headline as Any,
            "arousal_rating": arousalRating as Any,
            "valence_rating": valenceRating as Any,
            "tags": tags.map({
                $0.dictionary
            }) as Any
        ]
        
        if let wildcard = self.wildcard {
            dictionary["wildcard"] = wildcard.dictionary
        }
        
        if let note = self.note {
            dictionary["note"] = note.dictionary
        }
        
        return dictionary
    }
}
