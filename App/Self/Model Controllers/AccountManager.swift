import Firebase

class AccountManager {
    static fileprivate var sharedInstance: AccountManager? // Singleton
    fileprivate var accountDBRef: DocumentReference?
    private var accountObserver: ListenerRegistration?
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
    func loadAccount(completion: @escaping () -> Void) {
        
        let authUser = Auth.auth().currentUser!
        accountDBRef = Firestore.firestore().collection("user").document(authUser.uid)
        
        accountObserver = accountDBRef?.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                if let error = error { print("Error Loading User Data: \(error.localizedDescription)") }
                print("Error Loading User Data. Forcing logout") 
                AccountManager.logout()
                return
            }
            self.accountRef = Account(withSnapshot: snapshot)
            print("Account Data Updated:", AccountManager.shared().accountRef?.dictionary as AnyObject)
            completion()
        }
    }

    func updateAccount(modifiedAccount: Account? = nil, completion: @escaping () -> Void) {
        
        if let modifiedAccount = modifiedAccount {
            AccountManager.shared().accountRef = modifiedAccount
        }
        
        var data = AccountManager.shared().accountRef!.dictionary
        data["metadata"] = ["account_last_modified": Date()]
        accountDBRef?.setData(data, merge: true) { _ in
            self.loadAccount {
                print("Account Updated")
                completion()
            }
        }
    }
    
    func checkMilestone(_ milestone: String) -> Bool {
        guard let milestone = accountRef?.milestones.milestones[milestone] else { return false }
        guard milestone == true else { return false }
        return true
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
