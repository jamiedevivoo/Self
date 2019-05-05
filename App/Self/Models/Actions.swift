import Firebase

class Actions {
    private var ActionsFirebaseReference:CollectionReference = Firestore.firestore().collection("actions")
}


// Model Initialisers
extension Actions {

    
    func getAllActions(completion: @escaping ([Actions.Info]) -> ()) {
        ActionsFirebaseReference.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, let _ = error  else {
                print("Error Loading Actions: \(error!.localizedDescription)")
                return
            }
            
            var actions: [Actions.Info] = []
            for document in querySnapshot.documents {
                var actionData = document.data()
                actionData["uid"] = document.documentID
                let action = Actions.Info(actionData)
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
                var actionData = document.data()
                actionData["uid"] = document.documentID
                let action = Actions.Info(actionData)
                actions.append(action)
            }
            completion(actions)
        }
    }
}
