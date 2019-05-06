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
    init(_ actionDictionary: [String:Any]) {
        self.uid                = (actionDictionary["uid"] as! String)
        self.isTodaysAction     = (actionDictionary["daily_action"] as! Bool)
        self.title              = (actionDictionary["title"] as! String)
        self.description        = (actionDictionary["description"] as! String)
        self.completionCount    = (actionDictionary["completion_count"] as! Int)
        self.selectionCount     = (actionDictionary["selection_count"] as! Int)
        self.timeRequired       = Double(actionDictionary["time_required"] as? String ?? "")
        for tag in actionDictionary["tags"] as! [[String:Any]] {
            let tag = Tag(tag)
            self.tags.append(tag)
        }
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension ActionManager.Brief: DictionaryConvertable {
    var dictionary: [String: Any] {
        var tagsArray = [[String:Any]]()
        for tag in tags {
            tagsArray.append(tag.dictionary)
        }
        
        return [
            "action_ref":       "actions/\(uid)" as String,
            "was_daily_action": isTodaysAction as Bool,
            "title":            title as String,
            "description":      description as String,
            "completion_count": completionCount as Int,
            "selection_count":  selectionCount as Int,
            "tags":             tagsArray as Any,
            "time_required":    timeRequired as Any
        ]
    }
}

