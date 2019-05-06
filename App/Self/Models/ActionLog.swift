import Firebase

extension ActionManager {
    struct Log {
        var uid: String?,
            actionRef: String,
            addedTimestamp: Date,
            completeTimestamp: Date?,
            completed: Bool,
            wasDailyAction: Bool,
            description: String,
            title: String
    }
}
// MARK: - Convenience Iniitialiser
extension ActionManager.Log {
    init(_ actionDictionary: [String:Any]) {
        self.uid                = (actionDictionary["uid"] as? String ?? nil)
        self.actionRef          = (actionDictionary["action_ref"] as! String)
        self.wasDailyAction     = (actionDictionary["was_daily_action"] as! Bool)
        self.title              = (actionDictionary["title"] as! String)
        self.description        = (actionDictionary["description"] as! String)
        self.addedTimestamp     = (actionDictionary["added_timestamp"] as! Date)
        self.completed          = (actionDictionary["completed"] as! Bool)
        if self.completed == true {
            self.completeTimestamp  = (actionDictionary["complete_timestamp"] as! Date)
        }
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension ActionManager.Log: DictionaryConvertable {
    var dictionary: [String: Any] {
        var dictionary: [String:Any] = [
            "uid" :                 uid ?? "",
            "action_ref":           actionRef as String,
            "added_timestamp":      addedTimestamp as Date,
            "complete":             completed as Bool,
            "wasDailyAction":       wasDailyAction as Bool,
            "title":                title as String,
            "description":          description as String,
        ]
        
        if completed == true, completeTimestamp != nil {
            dictionary["complete_timestamp"] = completeTimestamp! as Date
        }
        
        return dictionary
    }
}
