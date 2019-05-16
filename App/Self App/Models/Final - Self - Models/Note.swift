struct Note {
    var text: String
}

extension Note {
    init(_ noteDictionary: [String: Any]) {
        self.text = (noteDictionary["text"] as! String)
    }
}

// MARL: - Output / Describing the model
extension Note: DictionaryConvertable {
    var dictionary: [String: Any] {
        return ["text": text as String]
    }
}
