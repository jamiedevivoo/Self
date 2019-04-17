import Firebase

class HighlightManager {
    private static let highlightRef:CollectionReference = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid).collection("mood_logs")
    static var allHighlights: QuerySnapshot?
}

extension HighlightManager {
    
    static func getHighlights(completion: @escaping (QuerySnapshot) -> ()) {
        print(highlightRef)
        print(highlightRef.path)
        highlightRef.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
            print(querySnapshot)
            completion(querySnapshot)
        }
    }
}
