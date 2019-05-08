extension Mood {
    struct Emotion: Hashable {
        var name: String
        var adj: String
        var valence: Double
        var arousal: Double
        
        var valenceMultiplier: Double {
            get { return valence + 1 }
        }
        var arousalMultiplier: Double {
            get { return arousal + 1 }
        }
    }
}

extension Mood.Emotion {
    init(_ emotionDictionary: [String: Any]) {
        self.name        = emotionDictionary["name"] as! String
        self.adj         = emotionDictionary["adj"] as! String
        self.valence     = emotionDictionary["valence"] as! Double
        self.arousal     = emotionDictionary["arousal"] as! Double
    }
}
