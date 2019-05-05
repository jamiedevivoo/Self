import Firebase

class Actions {
    private var ActionsFirebaseReference:CollectionReference = Firestore.firestore().collection("actions")
}


// Helpers
extension Actions {
    
    func user(_ account: Account) -> Actions.UserLogs {
        return UserLogs(account: account).self
    }

}


// Build actions
extension Actions {
    func createActionFromSnapshot(documentSnapshot actionSnapshot: DocumentSnapshot) -> Actions.Info {
        var actionData = actionSnapshot.data()!
        actionData["uid"] = actionSnapshot.documentID
        let action = Actions.Info(actionData)
        return action
    }
}


// Get Action Data from Database
extension Actions {
    func getAllActions(completion: @escaping ([Actions.Info]) -> ()) {
        ActionsFirebaseReference.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, let _ = error  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Info] = []
            for document in querySnapshot.documents {
                let action = self.createActionFromSnapshot(documentSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }

    func getDailyActions(completion: @escaping ([Actions.Info]) -> ()) {
        ActionsFirebaseReference.whereField("daily_action", isEqualTo: true).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Info] = []
            for document in querySnapshot.documents {
                let action = self.createActionFromSnapshot(documentSnapshot: document)
                actions.append(action)
            }
            completion(actions)
        }
    }
}
