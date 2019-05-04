import UIKit
import SnapKit
import Firebase

class CommunitiesViewController: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            print("LOG: Communities Screen")
            view.backgroundColor = .yellow
            navigationItem.title = "Communities"
            
            var db:Firestore!
            db = Firestore.firestore()
//            var userSnapshot = db.collection("user").child().get()

            db.collection("user").getDocuments() { querySnapshot, error in
                if let error = error {
                    print ("\(error.localizedDescription)")
                } else {
                    print(querySnapshot!.documents)
                }
            }
            
//            var profile = Profile(snapshot: userSnapshot)
        }
        
}
