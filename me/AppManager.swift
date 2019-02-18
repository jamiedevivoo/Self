import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    var appContainer: LaunchViewController!
    
    private init() { }
    
    func showApp() {
        
        var viewController: UIViewController
        
        if Auth.auth().currentUser == nil {
            let viewController = LoginViewController()
        } else {
            let viewController = MainViewController()
        }
        
//       appContainer.present(viewController, animated: true, completion: nil)
        
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
