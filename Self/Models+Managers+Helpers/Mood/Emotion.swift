struct Emotion: Hashable {
    var name: NameString
    var adj: String
    var valence: ValenceDouble
    var arousal: ArousalDouble
}

extension Emotion {
    init(_ emotionDictionary: [String:Any]) {
        self.name        = emotionDictionary["name"] as! String
        self.adj         = emotionDictionary["adj"] as! String
        self.valence     = emotionDictionary["valence"] as! ValenceDouble
        self.arousal     = emotionDictionary["arousal"] as! ArousalDouble
    }
}
