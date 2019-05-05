import Firebase

class Actions {
    private var ActionsFirebaseReference:CollectionReference = Firestore.firestore().collection("actions")
}


// Helpers
extension Actions {
    func user(_ account: Account) -> Actions.User {
        return User(account: account).self
    }
}


// Build Actions Brief
extension Actions {
    private func constructActionBrief(FromSnapshot actionSnapshot: DocumentSnapshot) -> Actions.Brief {
        var actionData = actionSnapshot.data()!
        actionData["uid"] = actionSnapshot.documentID
        let action = Actions.Brief(actionData)
        return action
    }
}


// Get Action Data from Database
extension Actions {
    func getAllActions(completion: @escaping ([Actions.Brief]) -> ()) {
        ActionsFirebaseReference.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, let _ = error  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Brief] = []
            for document in querySnapshot.documents {
                let action = self.constructActionBrief(FromSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }

    func getDailyActions(completion: @escaping ([Actions.Brief]) -> ()) {
        ActionsFirebaseReference.whereField("daily_action", isEqualTo: true).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Brief] = []
            for document in querySnapshot.documents {
                let action = self.self.constructActionBrief(FromSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }
}
