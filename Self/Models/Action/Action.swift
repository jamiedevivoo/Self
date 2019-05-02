struct Action {
    var uid: String,
        dailyAction: Bool,
        description: String,
        timeRequired: Double?,
        title: String,
        tags: [Tag] = [Tag](),
        completionCount: Int
}

// MARK: - Convenience Iniitialiser
extension Action {
    init(_ actionDictionary: [String:Any]) {
        self.uid                = (actionDictionary["uid"] as! String)
        self.dailyAction        = (actionDictionary["daily_action"] as! Bool)
        self.title              = (actionDictionary["title"] as! String)
        self.description        = (actionDictionary["description"] as! String)
        self.completionCount    = (actionDictionary["completion_count"] as! Int)
        self.timeRequired       = Double(actionDictionary["time_required"] as? String ?? "")
        for tag in actionDictionary["tags"] as! [[String:Any]] {
            let tag = Tag(tag)
            self.tags.append(tag)
        }
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension Action: DictionaryConvertable {
    var dictionary: [String: Any] {
        var tagsArray = [[String:Any]]()
        for tag in tags {
            tagsArray.append(tag.dictionary)
        }
        return [
            "action_ref":       uid as String,
            "title":            title as String,
            "description":      description as String,
            "completion_count": completionCount as Int,
            "tags":             tagsArray as Any,
            "time_required":    timeRequired as Any
        ]
    }
}
