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
