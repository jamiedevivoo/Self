import Firebase

class ActionManager {
    private static let actionRef:CollectionReference = Firestore.firestore().collection("actions")
    static var allActions: QuerySnapshot?
}

extension ActionManager {
    
    static func getActions(completion: @escaping (QuerySnapshot) -> ()) {
        actionRef.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            completion(querySnapshot)
        }
    }
}
