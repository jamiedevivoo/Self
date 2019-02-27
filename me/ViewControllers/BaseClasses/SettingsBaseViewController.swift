import UIKit
import SnapKit
import Firebase

class SettingsBaseViewController: UIViewController {
    
    let uid: String = Auth.auth().currentUser!.uid
    var db: Firestore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
