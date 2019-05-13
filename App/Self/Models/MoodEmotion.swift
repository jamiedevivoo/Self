extension Mood {
    struct Emotion: Hashable {
        var name: String
        var adj: String
        var friendly: String
        var emoji: String
        var valence: Double
        var arousal: Double
        
        var valenceMultiplier: Double {
            return valence + 1
        }
        var arousalMultiplier: Double {
            return arousal + 1
        }
    }
}

extension Mood.Emotion {
    init(_ emotionDictionary: [String: Any]) {
        self.name        = emotionDictionary["name"] as! String
        self.adj         = emotionDictionary["adj"] as! String
        self.friendly    = emotionDictionary["friendly"] as! String
        self.emoji       = emotionDictionary["emoji"] as! String
        self.valence     = emotionDictionary["valence"] as! Double
        self.arousal     = emotionDictionary["arousal"] as! Double
    }
}
