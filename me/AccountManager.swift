import Firebase

class AccountManager {
    
    static let shared = AccountManager()
    
    let user = Auth.auth().currentUser
    
    let userID = Auth.auth().currentUser?.uid
    
    
    let db = Firestore.firestore()
//    db.collection("users").document(child).observeSingleEvent(of: .value, with: { (snapshot) in

    
//    let userData:Array = [
//        "uid" : user.uid,
//        "email": user.email,
//        "
//
//        ]

    private init() { }


    
}
