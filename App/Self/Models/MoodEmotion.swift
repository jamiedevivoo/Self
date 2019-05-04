extension Mood {
    struct Emotion: Hashable {
        var name: String
        var adj: String
        var valence: Double
        var arousal: Double
    }
}

extension Mood.Emotion {
    init(_ emotionDictionary: [String:Any]) {
        self.name        = emotionDictionary["name"] as! String
        self.adj         = emotionDictionary["adj"] as! String
        self.valence     = emotionDictionary["valence"] as! Double
        self.arousal     = emotionDictionary["arousal"] as! Double
    }
}
