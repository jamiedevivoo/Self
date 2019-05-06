import Firebase

extension ActionManager {
    struct Log {
        var uid: String?,
            actionRef: DocumentReference,
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
        self.actionRef          = (actionDictionary["action_ref"] as! DocumentReference)
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
    
      return [
            "action_ref":           actionRef as DocumentReference,
            "was_daily_action":     wasDailyAction as Bool,
            "title":                title as String,
            "description":          description as String,
            "added_timestamp":      addedTimestamp as Date,
            "completed":            completed as Bool,
            "complete_timestamp":   completeTimestamp ?? ""
        ]
        /// Timestamps aren't included in the dictionary, these are only set by the modelController when needed. This is because the dictionary is used to update the log and repetedly converting the timestamp into a date would corrupt it.
        
    }
}
