import Firebase

class AccountManager {
    
    // MARK: - Properties
    static let shared = AccountManager()
    
    let userRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid)

    var user: User?

    // MARK: - Init
    private init() { }

    // MARK - Functions
    func loadUser(completion: @escaping () -> ()) {
        userRef.getDocument { snapshot, error in
            if let error = error {
                print(error)
            } else {
                if let snapshot = snapshot {
                    self.user = User(snapshot: snapshot)
                    completion()
                }
            }
        }
    }

    func update(_ user: User? = AccountManager.shared.user) {
        guard let user = user else { return }
        userRef.setData(user.dictionary, merge: true) { _ in }
    }
    
}
