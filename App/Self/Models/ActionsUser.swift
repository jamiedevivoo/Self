import Firebase

// Setup
extension Actions {
    class User: Actions {
        let userReference: CollectionReference
        
        init(account: Account) {
            userReference = Firestore.firestore().collection("user").document(account.uid).collection("action_logs")
        }
    }
}


//Build Action Logs
extension Actions.User {
    private func constructActionLog(fromSnapshot actionSnapshot: DocumentSnapshot) -> Actions.Log {
        var actionData = actionSnapshot.data()!
        actionData["uid"] = actionSnapshot.documentID
        let action = Actions.Log(actionData)
        return action
    }
}


// Get Actions
extension Actions.User {
    func getIncompleteActions(completion: @escaping ([Actions.Log]?) -> ()) {
        userReference.whereField("completed", isEqualTo: false).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Log] = []
            for document in querySnapshot.documents {
                let action = self.constructActionLog(fromSnapshot: document)
                actions.append(action)
            }
            
            completion(actions)
        }
    }
}


extension Actions.User {
}
