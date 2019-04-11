import Firebase

class AccountManager {
    static fileprivate var sharedInstance: AccountManager? // Singleton // private(set)
    fileprivate(set) var userData: UserData?
    fileprivate(set) var userAuth: User
    fileprivate let userRef:DocumentReference

    private init() {
        print("[Account Manager: Initialised]")
        userAuth = Auth.auth().currentUser!
        userRef = Firestore.firestore().collection("user").document(userAuth.uid)
    }
    
    deinit {
        print("[Account Manager: Deinitialised]")
    }
}

// MARK: - Manage Instance
extension AccountManager {
    static func shared() -> AccountManager {
        print("Shared Instance Request ...")
        guard let shared = sharedInstance else {
            print("... Shared Instance Doesn't exist ...")
            sharedInstance = AccountManager()
            return sharedInstance!
        }
        print("... Returning static self instance")
        return shared
    }
    
    static func destroy() {
        print("Destroying Shared Instance")
        sharedInstance = nil
    }
}

// MARK: - Manage User
extension AccountManager {
    func loadUser(completion: @escaping () -> ()) {
        print("Loading User")
        userRef.getDocument { snapshot, error in
            if let error = error {
                print(error)
            } else {
                if let snapshot = snapshot {
                    self.userData = UserData(withSnapshot: snapshot)
                    completion()
                }
            }
        }
    }

    func updateUser(_ user: UserData? = shared().userData) {
        print("Attempting to update (or add) User")
        guard let user = user else {
            print("No userdata supplied")
            return
        }
        userRef.setData(user.dictionary, merge: true) { _ in
            print("User updated")
        }
    }
}

// MARK: - Manage Auth
extension AccountManager {
    static func logout() {
        print("Logout Called")
        do {
            try Auth.auth().signOut()
            AccountManager.destroy()
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
}
/*
 Sources / Notes
 https://stackoverflow.com/questions/34046940/how-to-reset-singleton-instance
 https://firebase.google.com/docs/auth/
 https://stackoverflow.com/questions/33705976/when-should-i-use-static-methods
 
 Static - functions and properties shared by the class, they belong to the class, not the instance.
 
 */
