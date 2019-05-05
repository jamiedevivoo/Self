import Firebase

// Setup
extension Actions {
    class UserLogs {
        let userReference: CollectionReference
        
        init(account: Account) {
            userReference = Firestore.firestore().collection("user").document(account.uid).collection("action_logs")
        }
        
    }
}

extension Actions.UserLogs {
    
    func userCompletedDailyAction() {
        
    }
    
    func getActiveActions(completion: @escaping ([Actions.Log]?) -> ()) {
        let todaysDate = Date()
        userReference.whereField("added_timestamp", isGreaterThanOrEqualTo: todaysDate).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Log] = []
            for document in querySnapshot.documents {
                var actionData = document.data()
                actionData["uid"] = document.documentID
                let action = Actions.Log(actionData)
                actions.append(action)
            }
            completion(actions)
        }
    }
    
    func getIncompleteActions(completion: @escaping ([Actions.Log]) -> ()) {
        userReference.whereField("completed", isEqualTo: false).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, let _ = error  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Log] = []
            for document in querySnapshot.documents {
                var actionData = document.data()
                actionData["uid"] = document.documentID
                let action = Actions.Log(actionData)
                actions.append(action)
            }
            completion(actions)
        }
    }
}
