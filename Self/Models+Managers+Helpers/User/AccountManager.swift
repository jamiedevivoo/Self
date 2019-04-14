import Firebase

class AccountManager {
    static fileprivate var sharedInstance: AccountManager? // Singleton
    fileprivate var accountDBRef:DocumentReference?
    var accountRef: Account? // fileprivate(set)

    private init() {
        print("[Account Manager: Initialised]")
    }
    
    deinit {
        print("[Account Manager: Deinitialised]")
    }
    
}

// MARK: - Manage Account
extension AccountManager {
    func loadAccount(completion: @escaping () -> ()) {
        let authUser = Auth.auth().currentUser!
        accountDBRef = Firestore.firestore().collection("user").document(authUser.uid)
        
        accountDBRef?.getDocument { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                if let error = error { print("Error Loading User Data: \(error.localizedDescription)") }
                print("Error Loading User Data. Forcing logout") 
                AccountManager.logout()
                return
            }
            self.accountRef = Account(withSnapshot: snapshot)
            print(self.accountRef?.dictionary)
            completion()
        }
    }

    func updateAccount(modifiedAccount:Account? = nil) {
        if let modifiedAccount = modifiedAccount {
            AccountManager.shared().accountRef = modifiedAccount
        }
        
        var data = AccountManager.shared().accountRef!.dictionary
        data["metadata"] = ["account_last_modified":NSDate().timeIntervalSince1970]
        accountDBRef?.setData(AccountManager.shared().accountRef!.dictionary, merge: true) { _ in
            print(AccountManager.shared().accountRef!.dictionary)
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
