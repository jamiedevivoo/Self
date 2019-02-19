import Firebase

class AccountManager {
    
    static let shared = AccountManager()
    
    let user = Auth.auth().currentUser
    
//    let userData:Array = [
//        "uid" : user.uid,
//        "email": user.email,
//        "
//
//        ]
    
    private init() { }


    
}
