import Firebase

class ActionManager {
    private static let actionRef:CollectionReference = Firestore.firestore().collection("actions")
    static var allActions: QuerySnapshot?
}

extension ActionManager {
    
    static func getAllActions(completion: @escaping (QuerySnapshot) -> ()) {
        actionRef.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            completion(querySnapshot)
        }
    }
    
    static func getActions(completion: @escaping (QuerySnapshot) -> ()) {
        actionRef.whereField("daily_action", isEqualTo: true).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            completion(querySnapshot)
        }
    }
    
    static func getSelectedAction(completion: @escaping (QuerySnapshot) -> ()) {
        let userActionLogsRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid).collection("action_logs")
        let todaysDate = Date()
        print(todaysDate)
        userActionLogsRef.whereField("timestamp", isGreaterThanOrEqualTo: todaysDate).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            completion(querySnapshot)
        }
    }
    
    static func getIncompleteActions(completion: @escaping (QuerySnapshot) -> ()) {
        let userActionLogsRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid).collection("action_logs")
        userActionLogsRef.whereField("completed", isEqualTo: false).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            completion(querySnapshot)
        }
    }
}
