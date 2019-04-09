import Firebase

class AccountManager {
    
    // MARK: - Properties
    static let shared = AccountManager()
    
    let userRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid)

    var user: UserInfo?

    // MARK: - Init
    private init() {
        if Auth.auth().currentUser !== nil {
//            self.state = .loggedIn(UserInfo(dictionary: ["uid" : "dhehqifu", "email":"edA"]))
        }
    }

    // MARK - Functions
    func loadUser(completion: @escaping () -> ()) {
        userRef.getDocument { snapshot, error in
            if let error = error {
                print(error)
            } else {
                if let snapshot = snapshot {
                    self.user = UserInfo(snapshot: snapshot)
                    completion()
                }
            }
        }
    }

    func update(_ user: UserInfo? = AccountManager.shared.user) {
        guard let user = user else { return }
        userRef.setData(user.dictionary, merge: true) { _ in }
    }
    
    func logout() {
        try! Auth.auth().signOut()
        AppManager.shared.state = .unregistered
    }
    
}
