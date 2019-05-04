import Firebase

struct Wildcard {
    var ref: DocumentReference
    var question: String
    var answer: String          = ""
    var isComplete: Bool        = false
}

extension Wildcard {
    init(_ wildcardDictionary: [String:Any]) {
        self.ref        = (wildcardDictionary["wildcard_ref"] as! DocumentReference)
        self.question   = (wildcardDictionary["question"] as! String)
        self.answer     = (wildcardDictionary["answer"] as? String ?? answer)
        self.isComplete = (wildcardDictionary["complete"] as? Bool ?? isComplete)
    }
}

// MARL: - Output / Describing the model
extension Wildcard: DictionaryConvertable {
    var dictionary: [String: Any] {
        return [
            "wildcard_ref"  : ref as DocumentReference,
            "question"      : question,
            "answer"        : answer as Any,
            "complete"      : isComplete as Bool
        ]
    }
}
