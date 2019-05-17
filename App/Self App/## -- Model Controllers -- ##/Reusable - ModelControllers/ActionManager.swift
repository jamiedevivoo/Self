import Firebase

class ActionManager {
    private var actionsFirebaseReference: CollectionReference = Firestore.firestore().collection("actions")
}

// Helpers
extension ActionManager {
    func user(_ account: Account) -> ActionManager.User {
        return User(account: account).self
    }
}

// Build Actions Brief
extension ActionManager {
    private func constructActionBrief(fromSnapshot actionSnapshot: DocumentSnapshot) -> ActionManager.Brief {
        var actionData = actionSnapshot.data()!
        actionData["uid"] = actionSnapshot.documentID
        let action = ActionManager.Brief(actionData)
        return action
    }
}

// Get Action Data from Database
extension ActionManager {
    func getAllActions(completion: @escaping ([ActionManager.Brief]) -> Void) {
        actionsFirebaseReference.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [ActionManager.Brief] = []
            for document in querySnapshot.documents {
                let action = self.constructActionBrief(fromSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }

    func getDailyActions(completion: @escaping ([ActionManager.Brief]) -> Void) {
        actionsFirebaseReference.whereField("daily_action", isEqualTo: true).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [ActionManager.Brief] = []
            for document in querySnapshot.documents {
                let action = self.self.constructActionBrief(fromSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }
}
    
extension ActionManager {
    func updateBriefCompletion(_ actionBrief: ActionManager.Brief) ->  ActionManager.Brief {
        var updatedBrief = actionBrief
        
        updatedBrief.completionCount += 1
        
        actionsFirebaseReference.document(updatedBrief.uid).setData(updatedBrief.dictionary, merge: true) { error in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
        }
        /// Mathod returns new version of log (with updated UID and and/or completeTimestamp from the new dictionary)
        return updatedBrief
    }
    
    func updateBriefSelection(_ actionBrief: ActionManager.Brief) ->  ActionManager.Brief {
        var updatedBrief = actionBrief
        
        updatedBrief.selectionCount += 1
        
        actionsFirebaseReference.document(updatedBrief.uid).setData(updatedBrief.dictionary, merge: true) { error in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
        }
        /// Mathod returns new version of log (with updated UID and and/or completeTimestamp from the new dictionary)
        return updatedBrief
    }
}
