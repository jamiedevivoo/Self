extension ActionManager {
    struct Brief {
        var uid: String,
            isTodaysAction: Bool,
            description: String,
            timeRequired: Double?,
            title: String,
            tags: [Tag] = [Tag](),
            completionCount: Int,
            selectionCount: Int
    }
}
// MARK: - Convenience Iniitialiser
extension ActionManager.Brief {
    init(_ actionDictionary: [String: Any]) {
        self.uid                = (actionDictionary["uid"] as! String)
        self.isTodaysAction     = (actionDictionary["daily_action"] as! Bool)
        self.title              = (actionDictionary["title"] as! String)
        self.description        = (actionDictionary["description"] as! String)
        self.completionCount    = (actionDictionary["daily_completion_count"] as! Int)
        self.selectionCount     = (actionDictionary["daily_selection_count"] as! Int)
        self.timeRequired       = Double(actionDictionary["time_required"] as? String ?? "")
        
        for tag in actionDictionary["tags"] as! [[String: Any]] {
            let tag = Tag(tag)
            self.tags.append(tag)
        }
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension ActionManager.Brief: DictionaryConvertable {
    var dictionary: [String: Any] {
        
        return [
            "was_daily_action": isTodaysAction as Bool,
            "title": title as String,
            "description": description as String,
            "daily_completion_count": completionCount as Int,
            "daily_selection_count": selectionCount as Int,
            "tags": tags.map({$0.dictionary}),
            "time_required": timeRequired as Any
        ]
    }
}
