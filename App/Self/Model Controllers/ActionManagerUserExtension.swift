import Firebase

// Setup
extension ActionManager {
    class User: ActionManager {
        
        // Dependencies 
        let userActionLogsReference: CollectionReference
        
        init(account: Account) {
            userActionLogsReference = Firestore.firestore().collection("user").document(account.uid).collection("action_logs")
        }
    }
}


//Build Action Logs
extension ActionManager.User {
    
    /// Converting a brief into a log
    func constructActionLog(fromBrief actionBrief: ActionManager.Brief) -> ActionManager.Log {
        var actionData = actionBrief.dictionary
        
        /// Create a document reference using the Brief's UID
        actionData["action_ref"] = Firestore.firestore().collection("actions").document(actionBrief.uid)
        
        /// Automatically set the completed to false and added date to now.
        actionData["completed"] = false
        actionData["added_timestamp"] = Date()
        
        var actionLog = ActionManager.Log(actionData)
        updateLog(actionLog, true) { (action) in
            actionLog = action
        }
        
        return actionLog
    }
    
    /// Returning a users logs
    private func constructActionLog(fromSnapshot actionSnapshot: DocumentSnapshot) -> ActionManager.Log {
        var actionData = actionSnapshot.data()!
        
        /// Get UID from snapshot
        actionData["uid"] = actionSnapshot.documentID
        
        /// Convert Firebase Timestamp into Date
        actionData["added_timestamp"] = (actionData["added_timestamp"] as! Timestamp).dateValue()
        
        /// See if action has been completed (We can't get a completion_timestamp if it isn't)
        if actionData["completed"] as! Bool == true {
            actionData["complete_timestamp"] = (actionData["complete_timestamp"] as! Timestamp).dateValue()
        }
        
        let actionLog = ActionManager.Log(actionData)
        return actionLog
    }
    
}


// Set Actions
extension ActionManager.User {
    func updateLog(_ actionLog:ActionManager.Log, _ withTimestamp: Bool = false, completion: @escaping (ActionManager.Log) -> ()) {
        var actionLog = actionLog
        var actionLogDictionary = actionLog.dictionary
        
        if withTimestamp == true {
            actionLogDictionary["added_timestamp"] = actionLog.addedTimestamp
        }
        
        /// Check if the Log already has a UID (If it was created from a Brief then it won't, so create one)
        if actionLog.uid == "" || actionLog.uid == nil {
            actionLog.uid = userActionLogsReference.document().documentID
        }
        
        /// Check if the Action is marked as completed, if it is and a timestamp doesn't exist we will create one
        if actionLog.completed == true && actionLog.completeTimestamp == nil {
            actionLogDictionary["complete_timestamp"] = Timestamp.init()
        }
        
        userActionLogsReference.document(actionLog.uid!).setData(actionLogDictionary, merge: true) { error in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
            
            /// Mathod returns new version of log (with updated UID and and/or completeTimestamp if it wasn't set already)
            completion(ActionManager.Log(actionLogDictionary))
        }
    }
    
}

// Get Actions
extension ActionManager.User {
    func getIncompleteActions(completion: @escaping ([ActionManager.Log]?) -> ()) {
        userActionLogsReference.whereField("completed", isEqualTo: false).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [ActionManager.Log] = []
            for document in querySnapshot.documents {
                let action = self.constructActionLog(fromSnapshot: document)
                actions.append(action)
            }
            
            completion(actions)
        }
    }
}


extension ActionManager.User {
}
