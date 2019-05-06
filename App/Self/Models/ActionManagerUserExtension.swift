import Firebase

// Setup
extension ActionManager {
    class User: ActionManager {
        let userReference: CollectionReference
        
        init(account: Account) {
            userReference = Firestore.firestore().collection("user").document(account.uid).collection("action_logs")
        }
    }
}


//Build Action Logs
extension ActionManager.User {
    private func constructActionLog(fromSnapshot actionSnapshot: DocumentSnapshot) -> ActionManager.Log {
        var actionData = actionSnapshot.data()!
        actionData["uid"] = actionSnapshot.documentID
        actionData["added_timestamp"] = (actionData["added_timestamp"] as! Timestamp).dateValue()
        if actionData["completed"] as! Bool == true {
            actionData["complete_timestamp"] = (actionData["complete_timestamp"] as! Timestamp).dateValue()
        }
        let action = ActionManager.Log(actionData)
        return action
    }
    func constructActionLog(fromBrief actionBrief: ActionManager.Brief) -> ActionManager.Log {
        var actionData = actionBrief.dictionary
        actionData["action_ref"] = Firestore.firestore().collection("actions").document(actionBrief.uid)
        actionData["completed"] = false
        actionData["added_timestamp"] = Date()
        let action = ActionManager.Log(actionData)
        return action
    }
}


// Get Actions
extension ActionManager.User {
    func getIncompleteActions(completion: @escaping ([ActionManager.Log]?) -> ()) {
        userReference.whereField("completed", isEqualTo: false).getDocuments { querySnapshot, error in
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
