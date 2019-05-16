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
        var actionBriefDictionary = actionBrief.dictionary
        
        /// Create a document reference using the Brief's UID
        actionBriefDictionary["action_ref"] = Firestore.firestore().collection("actions").document(actionBrief.uid)
        
        /// Automatically set the completed to false and added date to now.
        actionBriefDictionary["completed"] = false
        actionBriefDictionary["added_timestamp"] = Date()
        
        let actionLog = ActionManager.Log(actionBriefDictionary)
        return updateLog(actionLog)
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
        private func updateLog(_ actionLog: ActionManager.Log) -> ActionManager.Log {
            var updatedLog = actionLog
            
            /// Check if the Log already has a UID (If it was created from a Brief then it won't, so create one)
            if updatedLog.uid == nil {
                updatedLog.uid = userActionLogsReference.document().documentID
            }
            
            /// Check if the Action is marked as completed, if it is and a timestamp doesn't exist we will create one
            if updatedLog.completed == true && updatedLog.completeTimestamp == nil {
                updatedLog.completeTimestamp = Date()
            }
            
            userActionLogsReference.document(updatedLog.uid!).setData(updatedLog.dictionary, merge: true) { error in
                guard error == nil else {
                    print("\(error!.localizedDescription)")
                    return
                }
            }
            /// Mathod returns new version of log (with updated UID and and/or completeTimestamp from the new dictionary)
            return updatedLog
        }
    
    func markLogComplete(_ actionLog: ActionManager.Log) -> ActionManager.Log {
        var completedLog = actionLog
        completedLog.completed = true
        return updateLog(completedLog)
    }
}

// Get Actions
extension ActionManager.User {
    func getIncompleteActions(completion: @escaping ([ActionManager.Log]?) -> Void) {
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
    
    func getCompleteActions(completion: @escaping ([ActionManager.Log]?) -> Void) {
        userActionLogsReference.whereField("completed", isEqualTo: true).getDocuments { querySnapshot, error in
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
