import Firebase

class ActionManager {
    private var ActionsFirebaseReference:CollectionReference = Firestore.firestore().collection("actions")
}


// Helpers
extension ActionManager {
    func user(_ account: Account) -> ActionManager.User {
        return User(account: account).self
    }
}


// Build Actions Brief
extension ActionManager {
    private func constructActionBrief(FromSnapshot actionSnapshot: DocumentSnapshot) -> ActionManager.Brief {
        var actionData = actionSnapshot.data()!
        actionData["uid"] = actionSnapshot.documentID
        let action = ActionManager.Brief(actionData)
        return action
    }
}


// Get Action Data from Database
extension ActionManager {
    func getAllActions(completion: @escaping ([ActionManager.Brief]) -> ()) {
        ActionsFirebaseReference.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, let _ = error  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [ActionManager.Brief] = []
            for document in querySnapshot.documents {
                let action = self.constructActionBrief(FromSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }

    func getDailyActions(completion: @escaping ([ActionManager.Brief]) -> ()) {
        ActionsFirebaseReference.whereField("daily_action", isEqualTo: true).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [ActionManager.Brief] = []
            for document in querySnapshot.documents {
                let action = self.self.constructActionBrief(FromSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }
}
