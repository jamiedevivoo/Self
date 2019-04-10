import Firebase

class AccountManager {
    static let shared = AccountManager() // Singleton
    private let userRef:DocumentReference
    var user: UserData?
    
    init() {
        userRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid)
    }
}
// MARK: - Functions
extension AccountManager {
    func loadUser(completion: @escaping () -> ()) {
        userRef.getDocument { snapshot, error in
            if let error = error {
                print(error)
            } else {
                if let snapshot = snapshot {
                    self.user = UserData(snapshot: snapshot)
                    completion()
                }
            }
        }
    }

    func update(_ user: UserData? = AccountManager.shared.user) {
        guard let user = user else { return }
        userRef.setData(user.dictionary, merge: true) { _ in }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
}
