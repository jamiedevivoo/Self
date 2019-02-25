import Firebase

class User {
    
    // MARK: - Properties
    
    var db:Firestore!
    let uid: String?
    var name: String?
    var surname: String?
    var email: String?

    // MARK: - Initialization
    
    init?(uid:String? = AccountManager.shared.user?.uid) {
        self.uid = uid ?? (AccountManager.shared.user?.uid)!
        getDetailsUsing(uid: self.uid!)
    }

    
    // MARK: - Functions

    private func getDetailsUsing(uid:String) {
        self.db = Firestore.firestore()
        db.collection("users").document(uid).getDocument() { document, error in
            if let error = error {
                print ("\(error)")
            } else if let document = document {
                let data = document.data()!
                self.email = data["email"] as? String ?? ""
                self.name = data["name"] as? String ?? ""
                self.surname = data["surname"] as? String ?? ""
            }
        }
        
    }
    
}
