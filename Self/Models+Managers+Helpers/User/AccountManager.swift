import Firebase

class AccountManager {
    static fileprivate var sharedInstance: AccountManager? // Singleton
    fileprivate let accountRef:DocumentReference
    fileprivate(set) var account: Account?

    private init() {
        print("[Account Manager: Initialised]")
        let authUser = Auth.auth().currentUser!
        accountRef = Firestore.firestore().collection("user").document(authUser.uid)
    }
    
    deinit {
        print("[Account Manager: Deinitialised]")
    }
    
}

// MARK: - Manage Account
extension AccountManager {
    func loadAccount(completion: @escaping () -> ()) {
        accountRef.getDocument { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                if let error = error { print("Error Loading User Data: \(error.localizedDescription)") }
                AccountManager.logout()
                return
            }
            self.account = Account(withSnapshot: snapshot)
            completion()
        }
    }

    func updateAccount(newAccount:Account? = nil) {
        if let newAccount = newAccount {
            AccountManager.shared().account = newAccount
        }
        accountRef.setData(AccountManager.shared().account!.dictionary, merge: true) { _ in
            print(AccountManager.shared().account!.dictionary)
        }
    }
}

// MARK: - Manage Instance
extension AccountManager {
    static func shared() -> AccountManager {
        guard let shared = sharedInstance else {
            sharedInstance = AccountManager()
            return sharedInstance!
        }
        return shared
    }
    
    static func destroy() {
        sharedInstance = nil
    }
}

// MARK: - Manage Auth
extension AccountManager {
    static func logout() {
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
